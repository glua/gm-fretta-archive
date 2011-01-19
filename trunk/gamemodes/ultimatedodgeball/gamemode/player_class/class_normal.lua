local CLASS = {}

CLASS.DisplayName			= "Player"
CLASS.Description           = ""
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 350
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= true

function CLASS:Loadout( pl )

	pl:Give( "weapon_ballgun" )
	
end

player_class.Register( "Player", CLASS )