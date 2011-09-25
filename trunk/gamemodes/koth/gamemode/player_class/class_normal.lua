local CLASS = {}

CLASS.DisplayName			= "Player"
CLASS.Description           = ""
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true

function CLASS:Loadout( pl )

	pl:Give( "kh_pistola" )
	
end

function CLASS:Think( pl )

	pl:CallPowerupFunction( "Think" )
	pl:CallPowerupFunction( "EndThink" )

end

player_class.Register( "Player", CLASS )