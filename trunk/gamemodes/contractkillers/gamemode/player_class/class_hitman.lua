
local CLASS1 = {}

CLASS1.DisplayName			= "Hitman"
CLASS1.WalkSpeed 			= 300
CLASS1.CrouchedWalkSpeed 	= 0.2
CLASS1.RunSpeed				= 500
CLASS1.DuckSpeed				= 0.4
CLASS1.JumpPower				= 300
CLASS1.DrawTeamRing			= false
CLASS1.Description          = "Medium Class\
Armed with an SMG and a pistol"
function CLASS1:Loadout( pl )
	pl:Give( "weapon_mp7" )
	pl:Give( "weapon_ppistol" )
	
end

function CLASS1:OnSpawn( pl )



end

player_class.Register( "Hitman", CLASS1 )