--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)

local Client = require(ReplicatedStorage.Client)

local remotes = ReplicatedStorage.Remotes
local getPlayerData = remotes.getPlayerData
local playerDataLoaded = remotes.playerDataLoaded
local playerDataChanged = remotes.playerDataChanged

local types = ReplicatedStorage.Types
local PlayerData = require(types.PlayerData)

export type Cursor = { string }

local PlayerDataController = {}
PlayerDataController.playerData = nil :: PlayerData.PlayerData?
PlayerDataController.playerDataChanged = Signal.new()

function PlayerDataController.init(self: PlayerDataController)
	task.spawn(self.pullPlayerData, self)
	playerDataChanged.OnClientEvent:Connect(function(newPlayerData)
		self:processData(newPlayerData)
	end)
end

function PlayerDataController:pullPlayerData()
	self:processData(getPlayerData:InvokeServer())
end

function PlayerDataController:processData(newPlayerData)
	self.playerData = getPlayerData:InvokeServer()
	self.playerDataChanged:Fire(self.playerData)
	Client:callEachService("onPlayerDataUpdated", self.playerData)
end

function PlayerDataController.getPlayerData(self: PlayerDataController): PlayerData.PlayerData?
	return self.playerData
end

local function getCursorValue(tbl: { [any]: any }, cursor: Cursor): any
	local value: any = tbl
	for i, key in cursor do
		assert( --
			typeof(value) == "table",
			("Invalid cursor %s: %s is not a table, it is %s"):format( --
				table.concat(cursor, "."),
				table.concat(cursor, ".", 1, i),
				typeof(value)
			)
		)
		value = value[key]
	end
	return value
end

local function areSimilar(lhs: any, rhs: any): boolean
	if typeof(lhs) ~= typeof(rhs) then
		return false
	elseif typeof(lhs) == "table" and typeof(rhs) == "table" then
		for key, value in pairs(lhs) do
			if not areSimilar(value, rhs[key]) then
				return false
			end
		end
		for key, value in pairs(rhs) do
			if not areSimilar(value, lhs[key]) then
				return false
			end
		end
		return true
	else
		return lhs == rhs
	end
end

function PlayerDataController.observe(self: PlayerDataController, cursor: Cursor, callback: (any) -> ())
	local playerData = self:getPlayerData()
	local currentValue = playerData and getCursorValue(playerData, cursor)
	task.spawn(callback, currentValue)
	return self.playerDataChanged:Connect(function(newPlayerData)
		local newValue = newPlayerData and getCursorValue(newPlayerData, cursor)
		if not areSimilar(newValue, currentValue) then
			currentValue = newValue
			task.spawn(callback, newValue)
		end
	end)
end

export type PlayerDataController = typeof(PlayerDataController)

return PlayerDataController
