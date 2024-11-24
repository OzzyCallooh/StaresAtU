--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.Types.PlayerData)

local Server = require(script.Parent.Parent.Server)

local PlayerSpawnService = require(script.Parent.PlayerSpawnService)

local Plot = require(script.Plot)
local Homestead = require(script.Homestead)

--[[
	Manages an instance which is cloned during the player's presence in the game.
]]
local HomesteadService = {}

HomesteadService._homesteads = {}
HomesteadService._homesteadPrefab = ReplicatedStorage.Assets.Homestead.Prototype :: Model

HomesteadService._plotsContainer = workspace.Plots
HomesteadService._plots = Plot.loadAll(HomesteadService._plotsContainer)
HomesteadService._plotsContainer.Parent = nil

function HomesteadService.init(self: HomesteadService) end

function HomesteadService._getFirstAvailablePlot(self: HomesteadService): Plot.Plot?
	for _plotName: Plot.PlotName, plot: Plot.Plot in self._plots do
		if not plot:IsOccupied() then
			return plot
		end
	end
	return nil
end

function HomesteadService._loadHomestead(self: HomesteadService, player: Player, _playerData: PlayerData.PlayerData)
	assert(not self._homesteads[player], "Player homestead already exists")
	local plot: Plot.Plot = self:_getFirstAvailablePlot()
	assert(plot, "No available plots")
	local homestead: Homestead.Homestead = Homestead.new(plot, self._homesteadPrefab, player)
	self._homesteads[player] = homestead
	Server:callEachService("onHomesteadLoaded", player, homestead)
	PlayerSpawnService:setPlayerSpawn(player, plot:GetCFrame())
end

function HomesteadService._unloadHomestead(self: HomesteadService, player: Player)
	local homestead: Homestead.Homestead = self._homesteads[player]
	if not homestead then
		return
	end
	Server:callEachService("onHomesteadUnloading", player, homestead)
	self._homesteads[player] = nil
	homestead:Destroy()
end

function HomesteadService.onPlayerAdded(self: HomesteadService, player: Player) end

function HomesteadService.onPlayerDataLoaded(self: HomesteadService, player: Player, playerData: PlayerData.PlayerData)
	--print("Checking for player homestead...", playerData.Homestead)
	self:_loadHomestead(player, playerData)
end
function HomesteadService.onPlayerRemoving(self: HomesteadService, player: Player)
	self:_unloadHomestead(player)
end

type HomesteadService = typeof(HomesteadService)

return HomesteadService
