
local CLASS = {}

CLASS.DisplayName			= "Runners"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 250
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight     	= true
CLASS.TeammateNoCollide		= true

function CLASS:Loadout( ply )
end

function CLASS:OnSpawn( pl )
end

function CLASS:OnDeath( pl )
end

player_class.Register( "Runners", CLASS )