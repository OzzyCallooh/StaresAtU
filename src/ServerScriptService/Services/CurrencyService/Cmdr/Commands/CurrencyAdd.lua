return {
	Name = "currency-add",
	Aliases = { "add-currency" },
	Description = "Gives players some currency",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "Who",
		},
		{
			Type = "enumCurrency",
			Name = "Currency",
		},
		{
			Type = "number",
			Name = "Amount",
		},
	},
}
