
local CLASS = {}

CLASS.DisplayName			= "Soldier"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 350
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 250
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= true

function CLASS:Loadout( pl )

	pl:Give( "ft_icesmg" )
	pl:Give( "ft_icerevolver" )
	pl:Give( "ft_snowballgun" )
	
end

player_class.Register( "Soldier", CLASS )


