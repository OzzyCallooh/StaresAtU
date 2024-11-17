--[[
	CurrencyService is responsible for tracking the player's currencies, which are just arbitrary
	named numbers in the player data. Yippee.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage.Types.PlayerData)
local Enums = require(ReplicatedStorage.Enums)
local Currency = Enums.Currency

local PlayerDataService = require(script.Parent.PlayerDataService)

local CurrencyService = {}

function CurrencyService.init(self: CurrencyService) end

function CurrencyService.getCurrency(self: CurrencyService, player: Player, currency: string): number
	local playerData = PlayerDataService:getPlayerData(player)
	return playerData and playerData.Currencies and playerData.Currencies[currency] or 0
end

function CurrencyService.setCurrency(self: CurrencyService, player: Player, currency: string, newValue: number)
	local playerData = PlayerDataService:getPlayerData(player)
	if not playerData.Currencies then
		playerData.Currencies = {}
	end
	playerData.Currencies[currency] = newValue
	print(("Set currency %s to %d for player %s"):format(currency, newValue, player.Name))
end

function CurrencyService.addCurrency(self: CurrencyService, player: Player, currency: string, amount: number)
	self:setCurrency(player, currency, self:getCurrency(player, currency) + amount)
end

function CurrencyService.onPlayerDataLoaded(self: CurrencyService, player: Player, playerData: PlayerData.PlayerData)
	print(("Player data loaded for %s (%d)"):format(player.Name, player.UserId))
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

	self:addCurrency(player, Currency.Gold, 100)
end

export type CurrencyService = typeof(CurrencyService)

return CurrencyService
