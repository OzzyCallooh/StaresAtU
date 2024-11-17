--!strict

export type Function<Args..., Rets...> = (Args...)->(Rets...)

--[[
	A module containing helpers for using calling and wrapping functions.
]]
local Functions = {}

--[[
	Calls a function with the given arguments, discarding the result.
	Returns a measurement of how long the function took to call
]]
function Functions.benchmark(fn, ...): number
	local start = os.clock()
	fn(...)
	local elapsed = os.clock() - start
	return elapsed
end

--[[
	Wraps a function to ensure it can only ever be called N times.
	If another thread calls the wrapped function after it has been
	called N times, an error is raised.
	
	Usage:
	
		local printJustOnce = Functions.limitCalls(print,2)
		printJustOnce("The one true yeen")    --> This one executes normally. (1 call)
		printJustOnce("Bears the ring")       --> This one executes normally. (2 calls)
		printJustOnce("He arrives at Mordor") --> This one raises an error.
]]
function Functions.limitCalls<T..., U...>(fn: Function<T..., U...>, maxCalls_: number?): Function<T..., U...>
	local maxCalls = maxCalls_ or 1
	local calls = 0
	local wrapped: Function<T..., U...> = function (...: T...): U...
		if calls >= maxCalls then
			error("Function call limit reached", 2)
		end
		calls += 1
		return fn(...)
	end
	return wrapped
end

--[[
	Wraps a function to ensure it can only ever be called once.
	If another thread calls the wrapped function, an error is raised.
	
	Usage:
	
		local printJustOnce = Functions.callOnce(print)
		printJustOnce("The one true yeen") --> This one executes normally.
		printJustOnce("The one true yeen") --> This one raises an error.
]]
function Functions.callOnce<T..., U...>(fn: Function<T..., U...>): Function<T..., U...>
	return Functions.limitCalls(fn, 1)
end

--[[
	Wraps a function to ensure it is only running no more than the
	given maxThreads number of times concurrently.
	If another thread calls the wrapped function while it is already
	at its limit, it raises an error.
	
	Usage:
	
		local oneAtATime = Functions.strictMutex(function ()
			print("I'm playing the waiting game!")
			wait(2)
			print("I win!")
		end, 2)
		task.spawn(oneAtATime) --> This one executes normally. (1 thread)
		task.spawn(oneAtATime) --> This one executes normally. (2 threads)
 		taks.spawn(oneAtATime) --> This one raises an error. (Would be too many)
]]
function Functions.strictMutex<T..., U...>(fn: Function<T..., U...>, maxThreads_: number?): Function<T..., U...>
	local maxThreads: number = maxThreads_ or 1
	local numThreads = 0
	local wrapped: Function<T..., U...> = function (...: T...): U...
		if numThreads >= maxThreads then
			error("Function is already running", 2)
		end
		numThreads += 1
		local retVals = { fn(...) }
		numThreads -= 1
		return unpack(retVals)
	end
	return wrapped
end

export type Functions = typeof(Functions)

return Functions
