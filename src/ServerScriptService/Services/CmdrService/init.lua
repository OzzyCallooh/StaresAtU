--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local utilities = ReplicatedStorage.Utilities
local Cmdr = require(utilities.Cmdr)

local CmdrService = {}

function CmdrService.init(self: CmdrService)
	Cmdr:RegisterDefaultCommands()
	self:AddCmdrContent(script)
end

function CmdrService.AddCmdrContent(self: CmdrService, container: Instance)
	local hooks = container:FindFirstChild("Hooks")
	if hooks then
		Cmdr:RegisterHooksIn(script.Hooks)
	end
	local types = container:FindFirstChild("Types")
	if types then
		Cmdr:RegisterTypesIn(script.Types)
	end
	local commands = container:FindFirstChild("Commands")
	if commands then
		Cmdr:RegisterCommandsIn(script.Commands)
	end
end

type CmdrService = typeof(CmdrService)

return CmdrService
