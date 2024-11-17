return function(registry)
	for _, enum: Enum in Enum:GetEnums() do
		local name = tostring(enum)
		local singleType = registry.Cmdr.Util.MakeEnumType(name, enum:GetEnumItems())
		registry:RegisterType("robloxEnum" .. name, singleType)
		registry:RegisterType("robloxEnum" .. name .. "s", registry.Cmdr.Util.MakeListableType(singleType))
	end
end
