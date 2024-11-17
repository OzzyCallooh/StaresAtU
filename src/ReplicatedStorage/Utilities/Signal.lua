local HttpService = game:GetService("HttpService")

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({
		_connections = {},
	}, Signal)

	return self
end

function Signal:fire(...)
	for _code, callback in pairs(self._connections) do
		task.spawn(callback, ...)
	end
end

function Signal:connect(callback)
	local code = HttpService:GenerateGUID(false)
	self._connections[code] = callback
	return {
		disconnect = function(_self)
			self._connections[code] = nil
		end,
	}
end

return Signal
