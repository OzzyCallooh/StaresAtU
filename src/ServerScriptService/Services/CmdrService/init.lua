--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local utilities = ReplicatedStorage.Utilities
local Cmdr = require(utilities.Cmdr)

local CmdrStartupService = {}

function CmdrStartupService.init(self: CmdrStartupService)
	Cmdr:RegisterDefaultCommands()
	Cmdr:RegisterHooksIn(script.Hooks)
	Cmdr:RegisterTypesIn(script.Types)
	Cmdr:RegisterCommandsIn(script.Commands)
end

type CmdrStartupService = typeof(CmdrStartupService)

return CmdrStartupService
