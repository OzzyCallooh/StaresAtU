--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local data = ReplicatedStorage.Data
local Icons = require(data.Icons)

return function(registry)
	local names: { string } = {}
	for name, _icon in Icons do
		table.insert(names, name)
	end
	local singleType = registry.Cmdr.Util.MakeEnumType("Chip", names)
	registry:RegisterType("chip", singleType)
	registry:RegisterType("chips", registry.Cmdr.Util.MakeListableType(singleType))
end
