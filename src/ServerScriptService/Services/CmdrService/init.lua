--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local utilities = ReplicatedStorage.Utilities
local Cmdr = require(utilities.Cmdr)

local CmdrService = {}

function CmdrService.init(self: CmdrService)
	Cmdr:RegisterDefaultCommands()
	Cmdr:RegisterHooksIn(script.Hooks)
	Cmdr:RegisterTypesIn(script.Types)
	Cmdr:RegisterCommandsIn(script.Commands)
end

type CmdrService = typeof(CmdrService)

return CmdrService
