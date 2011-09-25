
local CLASS = {}

CLASS.DisplayName			= "Jumper Class"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 750
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 400
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.JumpDelay				= 1.5
CLASS.DashDelay				= 1.0

function CLASS:Loadout( ply )
	ply:Give("weapon_vac")
end

function CLASS:OnSpawn( ply )
end

player_class.Register( "Jumper", CLASS )