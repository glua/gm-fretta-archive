
local CLASS = {}

CLASS.DisplayName			= "Default"
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.DuckSpeed				= 0.2
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.WalkSpeed 			= 320
CLASS.RunSpeed				= 320
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = true

function CLASS:Loadout( pl )

	pl:Give( "weapon_platformbreaker" )
	
	pl:SetAngles(Angle(0,0,0))
	
end

player_class.Register( "Default", CLASS )