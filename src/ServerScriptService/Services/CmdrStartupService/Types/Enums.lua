local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Enums = require(ReplicatedStorage.Enums)

return function (registry)
	for enumName: string, enumValues: { [string]: string } in Enums do
		local enumValuesAsArray = {}
		for _, enumValue in enumValues do
			table.insert(enumValuesAsArray, enumValue)
		end
		local singleType = registry.Cmdr.Util.MakeEnumType(enumName, enumValuesAsArray)
		registry:RegisterType("enum" .. enumName, singleType)
		registry:RegisterType("enum" .. enumName .. "s", registry.Cmdr.Util.MakeListableType(singleType))
	end
end
