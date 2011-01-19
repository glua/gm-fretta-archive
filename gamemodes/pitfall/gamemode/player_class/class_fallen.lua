
local CLASS = {}

CLASS.DisplayName			= "Fallen"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 350
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = false

function CLASS:Loadout( pl )
	
	pl:StripWeapons()
	pl:Spectate( OBS_MODE_ROAMING )
end

function CLASS:OnSpawn( pl )

	pl:StripWeapons()
	pl:Spectate( OBS_MODE_ROAMING )

end

player_class.Register( "Fallen", CLASS )