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
end

export type CurrencyController = typeof(CurrencyController)

return CurrencyController
