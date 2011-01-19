
local CLASS = {}

CLASS.DisplayName			= "Deaths"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 250
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight     	= true

function CLASS:Loadout( ply )
	ply:Give("weapon_crowbar")
end

function CLASS:OnSpawn( ply )
end

function CLASS:OnDeath( ply )
end

player_class.Register( "Deaths", CLASS )