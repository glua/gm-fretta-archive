
local CLASS = {}

CLASS.DisplayName			= "Human Class"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 500
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= false

function CLASS:Loadout( pl )
	
end

function CLASS:OnSpawn( pl )

end

player_class.Register( "Default", CLASS )