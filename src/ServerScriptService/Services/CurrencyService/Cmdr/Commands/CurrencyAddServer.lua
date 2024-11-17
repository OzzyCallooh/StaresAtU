local CurrencyService = require(script.Parent.Parent.Parent)

return function(_context, players: { Player }, currency: string, amount: number)
	for _, player in ipairs(players) do
		CurrencyService:addCurrency(player, currency, amount)
	end
end
