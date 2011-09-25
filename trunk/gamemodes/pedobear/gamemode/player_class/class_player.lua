
local CLASS = {}

CLASS.DisplayName			= "Player"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 200
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 50
CLASS.StartHealth			= 50

function CLASS:Loadout( pl )
	
end

function CLASS:OnDeath( pl, dmginfo )

end

player_class.Register( "player", CLASS )