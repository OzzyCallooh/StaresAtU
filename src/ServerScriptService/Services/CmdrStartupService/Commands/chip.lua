--!strict
return {
	Name = "chip";
	Description = "Displays the specified chip to all players.";
	Group = "Admin";
	Args = {
		{
			Type = "chips"; -- custom type
			Name = "icon";
			Description = "the name of the chip to show";
		};
	};
}