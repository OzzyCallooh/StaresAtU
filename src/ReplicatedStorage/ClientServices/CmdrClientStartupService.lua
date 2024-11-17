--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"))

local CmdrClientStartupService = {}

function CmdrClientStartupService.init(self: CmdrClientStartupService)
	CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 })
end

type CmdrClientStartupService = typeof(CmdrClientStartupService)

return CmdrClientStartupService
