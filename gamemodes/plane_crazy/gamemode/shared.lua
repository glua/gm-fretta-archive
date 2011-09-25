
GM.Name 	= "Plane Crazy"
GM.Author 	= "garry"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Fly your plane!"
GM.TeamBased = false
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 5
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = false
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.SelectColor = true

function GM:CreateTeams()

	team.SetUp( TEAM_UNASSIGNED, "Players", Color( 255, 255, 100 ), true )
	team.SetSpawnPoint( TEAM_UNASSIGNED, "info_player_start" )
	team.SetClass( TEAM_UNASSIGNED, { "Default" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_start" )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end


