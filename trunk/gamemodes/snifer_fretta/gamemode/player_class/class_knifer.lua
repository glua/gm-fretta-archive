
local CLASS = {}

CLASS.DisplayName			= "Knifer"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 320
CLASS.DrawTeamRing			= false

function CLASS:Loadout( pl )
	pl:Give( "weapon_knife" )
end

function CLASS:OnSpawn( pl )
	
end

player_class.Register( "Knifer", CLASS )