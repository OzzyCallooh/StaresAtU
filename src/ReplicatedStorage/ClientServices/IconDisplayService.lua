--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")

local remotes = ReplicatedStorage.Remotes
local showIconRemote = remotes.showIcon

local player = Players.LocalPlayer

local IconDisplayService = {}

function IconDisplayService.init(self: IconDisplayService)
	showIconRemote.OnClientEvent:Connect(function(iconId: number)
		local UI = Instance.new("ScreenGui")
		local label = Instance.new("ImageLabel", UI)
		label.Image = `rbxassetid://{iconId}`
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		local sound = Instance.new("Sound", UI) :: Sound
		sound.SoundId = `rbxassetid://90017054299588`
		UI.Enabled = false
		UI.Parent = player:WaitForChild("PlayerGui")
		ContentProvider:PreloadAsync({ UI })
		sound.Volume = 1
		sound:Play()
		task.wait(0.3)
		if UI:IsDescendantOf(player) then
			UI.Enabled = true
		end
		sound.Ended:Once(function()
			task.wait(1)
			if UI:IsDescendantOf(player) then
				UI:Destroy()
			end
		end)
		task.wait(1)
		if label:IsDescendantOf(player) then
			local tween = TweenService:Create(
				label,
				TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
				{ ImageTransparency = 1 }
			)
			tween:Play()
		end
	end)
end

type IconDisplayService = typeof(IconDisplayService)

return IconDisplayService
