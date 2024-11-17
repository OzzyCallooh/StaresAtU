local CurrencyService = require(script.Parent.Parent.Parent)

return function(_context, player: Player, currency: string, amount: number)
	return CurrencyService:getCurrency(player, currency)
end
