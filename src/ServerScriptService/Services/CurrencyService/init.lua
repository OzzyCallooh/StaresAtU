--[[
	CurrencyService is responsible for tracking the player's currencies, which are just arbitrary
	named numbers in the player data. Yippee.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage.Types.PlayerData)
local Enums = require(ReplicatedStorage.Enums)
local Currency = Enums.Currency

local CmdrService = require(script.Parent.CmdrService)
local PlayerDataService = require(script.Parent.PlayerDataService)

local CurrencyService = {}

function CurrencyService.init(self: CurrencyService)
	CmdrService:AddCmdrContent(script.Cmdr)
end

function CurrencyService.getCurrency(self: CurrencyService, player: Player, currency: string): number
	local playerData = PlayerDataService:getPlayerData(player)
	return playerData and playerData.Currencies[currency]
end

function CurrencyService.setCurrency(self: CurrencyService, player: Player, currency: string, newValue: number)
	PlayerDataService:updatePlayerData(player, function(playerData)
		playerData.Currencies[currency] = newValue
	end)
	print(("Set currency %s to %d for player %s"):format(currency, newValue, player.Name))
end

function CurrencyService.addCurrency(self: CurrencyService, player: Player, currency: string, amount: number)
	self:setCurrency(player, currency, self:getCurrency(player, currency) + amount)
end

function CurrencyService.reconcilePlayerData(self: CurrencyService, player: Player, playerData: PlayerData.PlayerData)
	local currencies = playerData.Currencies
	if not currencies then
		currencies = {}
		playerData.Currencies = currencies
	end

	for _, currency in Currency do
		if currencies[currency] == nil then
			currencies[currency] = 0
		end
	end

	if playerData.ReceivedFirstTimeBonus == nil then
		playerData.ReceivedFirstTimeBonus = false
	end
end

function CurrencyService.onPlayerDataLoaded(self: CurrencyService, player: Player, playerData: PlayerData.PlayerData)
	if not playerData.ReceivedFirstTimeBonus then
		print("Giving player first-time bonus")
		self:addCurrency(player, Currency.Gold, 100)
		playerData.ReceivedFirstTimeBonus = true
	end
end

export type CurrencyService = typeof(CurrencyService)

return CurrencyService
