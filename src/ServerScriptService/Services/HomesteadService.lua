--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.Types.PlayerData)

local PlayerDataService = require(script.Parent.PlayerDataService)

local HomesteadService = {}

function HomesteadService.init(self: HomesteadService)
	
end

function HomesteadService.onPlayerAdded(self: HomesteadService, player: Player)
	
end 

function HomesteadService.onPlayerDataLoaded(self: HomesteadService, player: Player, playerData: PlayerData.PlayerData)
	print("Checking for player homestead...", playerData.Homestead)
end

type HomesteadService = typeof(HomesteadService)

return HomesteadService
