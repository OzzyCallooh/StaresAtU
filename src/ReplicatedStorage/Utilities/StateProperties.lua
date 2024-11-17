--!strict
--[[

	A StateProperties represents a set of properties on an Instance which
	represents some state. To apply a StateProperties means to set the
	properties to their respective values.

	Usage:
	
		local light = workspace.Model.Part.PointLight
		local stateGo = StateProperties.new(light, {
			Color = BrickColor.new("Lime green").Color,
			Brightness = 1,
		})
		stateGo:Apply() --> The light is now green.
	
	Best used with multiple other properties:
		
		local stateStop = StateProperties.new(light, {
			Color = BrickColor.new("Really red").Color,
			Brightness = 1,
		})
		local stateOff = StateProperties.new(light, {
			Brightness = 0,
		})
		-- Blink red and off, like at a 4-way stop:
		while true do
			stateStop:Apply()
			wait(1)
			stateOff:Apply()
			wait(1)
		end
		
	If you don't feel like putting a ton of property values in your code, try
	using the prefixed attributes constructor:
		
		local stateGo = StateProperties.fromPrefixedAttributes(light, "Go_")
		local stateStop = StateProperties.fromPrefixedAttributes(light, "Stop_")
		local stateOff = StateProperties.fromPrefixedAttributes(light, "Off_")
]]

local InstanceExt = require(script.Parent.InstanceExt)
local beginsWith = require(script.Parent.String).beginsWith

export type PropertyValues = { [string]: any }

export type StatePropertiesImpl = {
	__index: StatePropertiesImpl,

	-- Constructors
	fromPrefixedAttributes: (Instance, attributePrefix: string) -> (),
	new: (Instance, PropertyValues) -> StateProperties,

	Apply: (self: StateProperties) -> (),
	Check: (self: StateProperties) -> (),
}

export type StateProperties = typeof(setmetatable(
	{} :: {
		Instance: Instance,
		PropertyValues: PropertyValues,
	},
	{} :: StatePropertiesImpl
))

local StateProperties: StatePropertiesImpl = {} :: StatePropertiesImpl
StateProperties.__index = StateProperties

--[[
	Returns a copy of dictionary containing only the keys which began with
	keyPrefix in the original. The copy's keys have the prefix removed.
]]
local function extractPrefixedKeys(dictionary: { [string]: any }, keyPrefix: string)
	local unprefixed: { [string]: any } = {}
	for key, value in dictionary do
		if beginsWith(key, keyPrefix) then
			local unprefixedKey = key:sub(keyPrefix:len() + 1)
			unprefixed[unprefixedKey] = value
		end
	end
	return unprefixed
end

--[[
	Returns a StateProperties whose property values match respective prefixed attributes
	on the given instance.
]]
function StateProperties.fromPrefixedAttributes(instance: Instance, attributePrefix: string): StateProperties
	local propertyValues: { [string]: any } = extractPrefixedKeys(instance:GetAttributes(), attributePrefix)
	return StateProperties.new(instance, propertyValues)
end

--[[
	Constructs a new StateProperties object for a given instance and dictionary of property values.
]]
function StateProperties.new(instance: Instance, propertyValues: { [string]: any }): StateProperties
	assert(typeof(instance) == "Instance", "argument 1 expects instance")
	assert(typeof(propertyValues) == "table", "argument 2 expects table")
	local self = setmetatable({}, StateProperties)
	self.Instance = instance
	self.PropertyValues = propertyValues
	self:Check()

	return self
end

--[[
	Applies this StateProperty's values to its instance.
]]
function StateProperties:Apply()
	for propertyName: string, propertyValue: any in self.PropertyValues do
		InstanceExt.safeSetProperty(self.Instance, propertyName, propertyValue)
	end
end

--[[
	Checks that the PropertyValues are present on the instance, emitting warnings
	for incorrect ones.
]]
function StateProperties:Check()
	for propertyName: string, _propertyValue: any in self.PropertyValues do
		local didGet = InstanceExt.safeGetProperty(self.Instance, propertyName)
		if not didGet then
			warn(debug.traceback(nil, 2))
		end
	end
end

return StateProperties
