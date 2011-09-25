local CLASS = {}

CLASS.Base 				= "default"
CLASS.DisplayName		= "Snow Thrower"
CLASS.Description       = "Pros: none \n cons: none"

function CLASS:Loadout( pl )

	pl:Give( "real_snowball_swep" )

end

player_class.Register( "SnowThrower", CLASS )

local CLASS ={}
CLASS.Base 				= "rock"
CLASS.DisplayName		= "Ice thrower"
CLASS.Description       = "Pros: High damage \n cons: Slow"

function CLASS:Loadout( pl )

	pl:Give( "real_snowball_rock" )

end

player_class.Register( "IceThrower", CLASS )

local CLASS ={}
CLASS.Base 				= "scout"
CLASS.DisplayName		= "Scout"
CLASS.Description       = "Pros: fast \n cons: low damage"

function CLASS:Loadout( pl )

	pl:Give( "real_snowball_soft" )

end

player_class.Register( "Scout", CLASS )