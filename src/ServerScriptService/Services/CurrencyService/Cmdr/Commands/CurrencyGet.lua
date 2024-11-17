return {
	Name = "currency-get",
	Aliases = { "get-currency" },
	Description = "Gets a player's currency",
	Group = "Admin",
	Args = {
		{
			Type = "player",
			Name = "Who",
		},
		{
			Type = "enumCurrency",
			Name = "Currency",
		},
	},
}
