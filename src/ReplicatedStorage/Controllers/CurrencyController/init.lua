--!strict

local PlayerDataController = require(script.Parent.PlayerDataController)

--[[
	Client-side currency controller
]]
local CurrencyController = {}

function CurrencyController.init(self: CurrencyController)
	PlayerDataController:observe({ "Currencies" }, function(newCurrencies)
		print("Currencies changed", newCurrencies)
	end)
	-- Components
	require(script.CurrencyDisplay)
end

function CurrencyController:_getCurrencyCursor(currencyName: string): { string }
	return { "Currencies", currencyName }
end

function CurrencyController:getCurrency(currencyName: string): number
	local cursor = self:_getCurrencyCursor(currencyName)
	return PlayerDataController:get(cursor) or 0
end

function CurrencyController:observeCurrency(currencyName: string, callback: (number) -> ())
	local cursor = self:_getCurrencyCursor(currencyName)
	return PlayerDataController:observe(cursor, callback)
end

export type CurrencyController = typeof(CurrencyController)

return CurrencyController
