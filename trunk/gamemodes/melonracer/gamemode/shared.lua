
DeriveGamemode( "fretta" );

GM.Name 		= "MelonRacer"
GM.Author 		= "N/A"
GM.Email 		= "N/A"
GM.Website 		= "N/A"
GM.TeamBased 	= false
GM.SelectColor 	= true

GM.MaximumDeathLength = 3			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 0			// Player has to be dead for at least this long

function GM:Initialize()

	self.BaseClass.Initialize( self )
	
	self.State = "waiting"
	
end

function GM:Think()

	if ( CLIENT ) then self:HUDThink() end
	
end

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	team.SetUp( TEAM_UNASSIGNED, "Racers", Color( 70, 230, 70 ) )
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )

end


function GM:GetNumLaps()
	return 3
end
