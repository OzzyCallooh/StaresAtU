--!strict

--[[
	A module of helper functions related to instances.
]]
local InstanceExt = {}

--[[
	Safely attempt to set a property on an instance, emitting a warning on failure.
]]
function InstanceExt.safeSetProperty(instance: Instance, propertyName: string, propertyValue: any): boolean
	local didSet = false
	xpcall(function ()
		-- This type cast suppresses the dynamic property access type check error,
		-- which is acceptable because it is in a protected call.
		(instance :: any)[propertyName] = propertyValue
		didSet = true
	end, function (_err)
		warn(("%s does not have property %s"):format(instance:GetFullName(), propertyName))
	end)
	return didSet
end

--[[
	Safely attempt to get a property on an instance, emitting a warning on failure.
]]
function InstanceExt.safeGetProperty(instance: Instance, propertyName: string, propertyValue: any): (boolean, any)
	local didAccess = false
	local propertyValue
	xpcall(function ()
		-- This type cast suppresses the dynamic property access type check error,
		-- which is acceptable because it is in a protected call.
		propertyValue = (instance :: any)[propertyName]
		didAccess = true
	end, function (_err)
		warn(("%s does not have property %s"):format(instance:GetFullName(), propertyName))
	end)
	return didAccess, propertyValue
end


return InstanceExt
