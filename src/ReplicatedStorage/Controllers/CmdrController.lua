--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"))

local CmdrController = {}

function CmdrController.init(self: CmdrController)
	CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 })
end

type CmdrController = typeof(CmdrController)

return CmdrController
