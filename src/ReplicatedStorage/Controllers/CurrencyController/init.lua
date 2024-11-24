--!strict

local PlayerDataController = require(script.Parent.PlayerDataController)

--[[
	Client-side currency controller
]]
local CurrencyController = {}
CurrencyController._currenciesCursor = PlayerDataController:wrapCursor({ "Currencies" })

function CurrencyController.init(self: CurrencyController)
	CurrencyController._currenciesCursor:observe(function(newCurrencies)
		print("Currencies changed", newCurrencies)
	end)

	-- Components
	require(script.CurrencyDisplay)
end

function CurrencyController:_getCurrencyCursor(currencyName: string)
	return self._currenciesCursor:extend(currencyName)
end

function CurrencyController:getCurrency(currencyName: string): number
	return self:_getCurrencyCursor(currencyName):get() or 0
end

function CurrencyController:observeCurrency(currencyName: string, callback: (number) -> ())
	return self:_getCurrencyCursor(currencyName):observe(callback)
end

export type CurrencyController = typeof(CurrencyController)

return CurrencyController
