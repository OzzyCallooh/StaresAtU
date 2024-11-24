--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Signal = require(ReplicatedStorage.Packages.Signal)

local modules = ServerScriptService.Modules
local DataStorage = require(modules.DataStorage)

local types = ReplicatedStorage.Types
local Result = require(types.Result)
local PlayerData = require(types.PlayerData)

local remotes = ReplicatedStorage.Remotes
local getPlayerData = remotes.getPlayerData
local playerDataLoaded = remotes.playerDataLoaded
local playerDataChanged = remotes.playerDataChanged

local Server = require(script.Parent.Parent.Server)

local PlayerDataService = {}

PlayerDataService.playerLoaded = Signal.new()

PlayerDataService._playerData = {} :: { [Player]: PlayerData.PlayerData }

function PlayerDataService.init(self: PlayerDataService)
	getPlayerData.OnServerInvoke = function(player: Player): PlayerData.PlayerData?
		return self._playerData[player]
	end
	Players.PlayerAdded:Connect(function(player: Player)
		self:_loadPlayer(player)
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		self:_unloadPlayer(player)
	end)
	for _index, player in Players:GetPlayers() do
		task.spawn(function()
			self:_loadPlayer(player)
		end)
	end
end

function PlayerDataService._loadPlayer(self: PlayerDataService, player: Player)
	local playerData = DataStorage:load(player)
	if not playerData.success then
		player:Kick(
			`Failed to load player data: {playerData.message} - if this issue persists, please contact support!`
		)
		return
	end
	local reconciledData = self:reconcilePlayerData(player, playerData.result or {})
	if not reconciledData.success then
		player:Kick(
			`Failed to reconcile player data: {reconciledData.message} - if this issue persists, please contact support!`
		)
		return
	end
	if not player:IsDescendantOf(Players) then
		return -- player left during loading
	end
	self._playerData[player] = reconciledData.result

	print(("Player data loaded for %s (%d)"):format(player.Name, player.UserId))

	-- Notify other services
	Server:callEachService("onPlayerDataLoaded", player, reconciledData)

	self.playerLoaded:Fire(player)
	playerDataLoaded:FireClient(player, reconciledData)
end

function PlayerDataService._unloadPlayer(self: PlayerDataService, player: Player)
	if self._playerData[player] then
		local data = self._playerData[player]
		DataStorage:store(player, data)
		self._playerData[player] = nil
	end
end

function PlayerDataService.getPlayerData(self: PlayerDataService, player: Player): PlayerData.PlayerData
	assert(self._playerData[player], `{player}'s data has not loaded yet! Use waitForDataReady() instead!`)
	return self._playerData[player]
end

type UpdateCallback = (PlayerData.PlayerData) -> ()

function PlayerDataService.updatePlayerData(
	self: PlayerDataService,
	player: Player,
	updateCallback: UpdateCallback
): PlayerData.PlayerData
	local data = self:getPlayerData(player)
	updateCallback(data)
	playerDataChanged:FireClient(player, data)
	Server:callEachService("onPlayerDataChanged", player, data)
	return data
end

function PlayerDataService.waitForDataReady(self: PlayerDataService, player: Player): PlayerData.PlayerData
	while not self:getPlayerData(player) do
		task.wait()
	end
	return self:getPlayerData(player)
end

function PlayerDataService.reconcilePlayerData(
	self: PlayerDataService,
	player: Player,
	data: { [string]: any }
): Result.Result<PlayerData.PlayerData>
	if not data.cash then
		data.cash = 0
	end

	if not data.reputation then
		data.reputation = 0
	end

	return {
		success = true,
		result = data,
	}
end

type PlayerDataService = typeof(PlayerDataService)

return PlayerDataService
