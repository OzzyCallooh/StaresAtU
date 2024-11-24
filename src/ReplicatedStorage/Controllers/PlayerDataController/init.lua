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
PlayerDataController._processCount = 0
PlayerDataController.playerData = nil :: PlayerData.PlayerData?
PlayerDataController.onPlayerDataChangedSignal = Signal.new()
Client:addAliasForSignal("onPlayerDataChanged", PlayerDataController.onPlayerDataChangedSignal)

function PlayerDataController.init(self: PlayerDataController)
	task.spawn(self.pullPlayerData, self)
	playerDataChanged.OnClientEvent:Connect(function(newPlayerData)
		self:processData(newPlayerData)
	end)
end

function PlayerDataController.pullPlayerData(self: PlayerDataController)
	self:processData(getPlayerData:InvokeServer())
end

function PlayerDataController.processData(self: PlayerDataController, newPlayerData)
	self._processCount += 1
	self.playerData = newPlayerData
	self.onPlayerDataChangedSignal:Fire(self.playerData)
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

function PlayerDataController.get(self: PlayerDataController, cursor: Cursor): any
	local playerData = self:getPlayerData()
	return playerData and getCursorValue(playerData, cursor)
end

function PlayerDataController.observe(self: PlayerDataController, cursor: Cursor, callback: (any) -> ())
	-- The initial invokation of the callback can only happen if player data has processed
	-- at least once. Otherwise, it'll wait for the first player data change.
	local currentValue
	if self._processCount > 0 then
		local playerData = self:getPlayerData()
		currentValue = playerData and getCursorValue(playerData, cursor)
		callback(currentValue)
	end

	return self.onPlayerDataChangedSignal:Connect(function(newPlayerData)
		local newValue = newPlayerData and getCursorValue(newPlayerData, cursor)
		if not areSimilar(newValue, currentValue) then
			currentValue = newValue
			callback(newValue)
		end
	end)
end

export type WrappedCursor = {
	get: (self: WrappedCursor) -> any,
	observe: (self: WrappedCursor, (any) -> ()) -> RBXScriptConnection,
	extend: (self: WrappedCursor, cursor: string) -> WrappedCursor,
}

function PlayerDataController.wrapCursor(self: PlayerDataController, cursor: Cursor): WrappedCursor
	return {
		get = function(_self)
			return self:get(cursor)
		end,
		observe = function(_self, callback)
			return self:observe(cursor, callback)
		end,
		extend = function(_self, key)
			local newCursor = { table.unpack(cursor) }
			table.insert(newCursor, key)
			return self:wrapCursor(newCursor)
		end,
	}
end

export type PlayerDataController = typeof(PlayerDataController)

return PlayerDataController
