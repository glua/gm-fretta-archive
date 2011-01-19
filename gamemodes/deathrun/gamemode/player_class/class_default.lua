
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 350
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 275
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.StartArmor			= 100
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight     	= true

function CLASS:Loadout( pl )
end

function CLASS:OnSpawn( pl )
end

function CLASS:OnDeath( pl )
end

player_class.Register( "Default", CLASS )