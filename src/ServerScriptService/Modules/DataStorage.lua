--!strict
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = ReplicatedStorage.Types
local Result = require(types.Result)

local dataStoreName = "PlayerData_Alpha1"

local dataStore = DataStoreService:GetDataStore(dataStoreName)

local DataStorage = {}

function DataStorage.store(self: DataStorage, player: Player, playerData: {})
	dataStore:SetAsync(self:getDataKey(player), playerData, { player.UserId })
end

function DataStorage.load(self: DataStorage, player: Player): Result.Result<{ [string]: any }>
	-- TODO error handling
	local playerData = dataStore:GetAsync(self:getDataKey(player))
	return {
		success = true,
		result = playerData,
	}
end

function DataStorage.getDataKey(self: DataStorage, player: Player)
	return `PlayerData_{player.UserId}`
end

type DataStorage = typeof(DataStorage)

return DataStorage
