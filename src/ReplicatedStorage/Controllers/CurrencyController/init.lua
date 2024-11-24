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

function CurrencyController:observeCurrency(currencyName: string, callback: (number) -> ())
	return PlayerDataController:observe({ "Currencies", currencyName }, callback)
end

export type CurrencyController = typeof(CurrencyController)

return CurrencyController
