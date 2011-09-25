
local CLASS1 = {}

CLASS1.DisplayName			= "Sniper"
CLASS1.WalkSpeed 			= 250
CLASS1.CrouchedWalkSpeed 	= 0.2
CLASS1.RunSpeed				= 450
CLASS1.DuckSpeed				= 0.4
CLASS1.JumpPower				= 300
CLASS1.DrawTeamRing			= false
CLASS1.Description          = "Long-range Class\
Armed with a railgun and a small accurate pistol"

function CLASS1:Loadout( pl )
	pl:Give( "weapon_sniper" )
	pl:Give( "weapon_peashooter" )
	
end

function CLASS1:OnSpawn( pl )



end

player_class.Register( "Sniper", CLASS1 )