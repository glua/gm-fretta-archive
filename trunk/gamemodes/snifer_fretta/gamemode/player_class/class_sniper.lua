
local CLASS = {}

CLASS.DisplayName			= "Sniper"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 200
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 160
CLASS.DrawTeamRing			= false

function CLASS:Loadout( pl )

	pl:Give( "weapon_sniper_rifle" )
	
end

function CLASS:OnSpawn( pl )

end

player_class.Register( "Sniper", CLASS )