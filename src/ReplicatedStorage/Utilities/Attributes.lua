--!strict

export type AttributeName = string
export type AttributeValue = any

local Attributes = {}

function Attributes.wrap(instance: Instance, t: {}?)
	return setmetatable(t or {}, {
		__index = function(_, key: AttributeName)
			return instance:GetAttribute(key)
		end,
		__newindex = function(_, key: AttributeName, value: AttributeValue)
			instance:SetAttribute(key, value)
		end,
		__tostring = function()
			return ("Attributes<%s>"):format(instance:GetFullName())
		end,
		__metatable = "Attributes",
	})
end

function Attributes.componentGetter(attributeName: AttributeName, defaultValue: AttributeValue?)
	return function(componentInstance: { Instance: Instance })
		local value = componentInstance.Instance:GetAttribute(attributeName)
		if value == nil and defaultValue ~= nil then
			value = defaultValue
		end
		return value
	end
end

function Attributes.componentSetter(attributeName: AttributeName)
	return function(componentInstance: { Instance: Instance }, value: AttributeValue)
		componentInstance.Instance:SetAttribute(attributeName, value)
	end
end

function Attributes.wrapComponentGetters()
	return setmetatable({}, {
		__index = function(_, attributeName: AttributeName)
			return Attributes.componentGetter(attributeName)
		end,
		__tostring = function()
			return "ComponentAttributeWrappedGetters"
		end,
		__metatable = "ComponentAttributeWrappedGetters",
	})
end

--[[
	Example usage:
		MyThing.Attributes = Attributes.wrapComponentClass(MyThing)
		MyThing.Attributes["Format"] = "Format" --> GetFormat, SetFormat
		MyThing.Attributes["Cool"] = "Coolness" --> GetCool, SetCool, which use attribute "Coolness"
		MyThing.Attributes[{ get = "IsCool", set = "SetCool" }] = "Cool"
		MyThing.Attributes[{ get = "IsReadOnly", set = nil }] = "ReadOnly"
]]
function Attributes.wrapComponentClass(componentClass)
	return setmetatable({}, {
		__newindex = function(_, key: string | { get: string?, set: string? }, value: AttributeName)
			local getterName
			local setterName
			if typeof(key) == "table" then
				getterName = key.get
				setterName = key.set
			else
				getterName = "Get" .. key
				setterName = "Set" .. key
			end
			if getterName then
				componentClass[getterName] = Attributes.componentGetter(value)
			end
			if setterName then
				componentClass[setterName] = Attributes.componentSetter(value)
			end
		end,
	})
end

--[[
	Wraps a component class, then sets attributes on the wrapper before returning it.
]]
function Attributes.componentAttributes(componentClass, attributes: { AttributeName }?)
	local wrapped = Attributes.wrapComponentClass(componentClass)
	for _, attribute: AttributeName in attributes or {} do
		wrapped[attribute] = attribute
	end
	return wrapped
end

return Attributes
