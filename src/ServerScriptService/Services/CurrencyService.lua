--[[
	CurrencyService is responsible for tracking the player's currencies, which are just arbitrary
	named numbers in the player data. Yippee.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Enums = require(ReplicatedStorage.Enums)

local CurrencyService = {}

function CurrencyService.init(self: CurrencyService)
	
end

export type CurrencyService = typeof(CurrencyService)

return CurrencyService
