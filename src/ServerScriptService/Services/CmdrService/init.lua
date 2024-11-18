--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage.Packages.Cmdr)

local CmdrService = {}

function CmdrService.init(self: CmdrService)
	Cmdr:RegisterDefaultCommands()
	self:AddCmdrContent(script)
end

function CmdrService.AddCmdrContent(self: CmdrService, container: Instance)
	local didAddSomething = false
	local hooks = container:FindFirstChild("Hooks")
	if hooks then
		Cmdr:RegisterHooksIn(hooks)
		didAddSomething = true
	end
	local types = container:FindFirstChild("Types")
	if types then
		Cmdr:RegisterTypesIn(types)
		didAddSomething = true
	end
	local commands = container:FindFirstChild("Commands")
	if commands then
		Cmdr:RegisterCommandsIn(commands)
		didAddSomething = true
	end
	if not didAddSomething then
		warn(("CmdrService.AddCmdrContent: No content found in %s"):format(container:GetFullName()))
	end
end

type CmdrService = typeof(CmdrService)

return CmdrService
