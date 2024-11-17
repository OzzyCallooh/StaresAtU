local RunService = game:GetService("RunService")

local allowed = {
	[193711988] = true, -- OzzyCallooh
	[18697683] = true, -- Chippy
}

local function hasPermission(userId: number): boolean
	return allowed[userId]
end

return function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		-- Allow everything in studio
		if RunService:IsStudio() then
			return
		end

		if not hasPermission(context.Executor.UserId) then
			return "You don't have permission to run this command"
		end
	end)
end
