
local CLASS1 = {}

CLASS1.DisplayName			= "Thug"
CLASS1.WalkSpeed 			= 400
CLASS1.CrouchedWalkSpeed 	= 0.5
CLASS1.RunSpeed				= 700
CLASS1.DuckSpeed				= 0.4
CLASS1.JumpPower				= 350
CLASS1.DrawTeamRing			= false
CLASS1.Description          = "Fast, close-range, Pain-inflictor\
Armed with a sawn-off shotgun and crowbar"
function CLASS1:Loadout( pl )

	pl:Give( "weapon_sawnoff" )
	pl:Give( "weapon_crowbar" )
	
end

function CLASS1:OnSpawn( pl )
pl:SetHealth(75)


end

player_class.Register( "Thug", CLASS1 )