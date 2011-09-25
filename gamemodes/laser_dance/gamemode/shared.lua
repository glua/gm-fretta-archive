
GM.Name 	= "Laser Dance"
GM.Author 	= "garry"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Shoot the other team!\n\nShoot downwards to launch yourself into the sky."
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 10
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = true

TEAM_ORANGE = 1
TEAM_GREEN = 2
TEAM_RED = 3
TEAM_BLUE = 4


function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_ORANGE, "Team Orange", Color( 255, 200, 50 ), true )
	team.SetSpawnPoint( TEAM_ORANGE, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } )
	
	team.SetUp( TEAM_GREEN, "Team Green", Color( 70, 230, 70 ) )
	team.SetSpawnPoint( TEAM_GREEN, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" }, true )
	
	team.SetUp( TEAM_RED, "Team Red", Color( 255, 80, 80 ) )
	team.SetSpawnPoint( TEAM_RED, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" }, true )
	
	team.SetUp( TEAM_BLUE, "Team Blue", Color( 80, 150, 255 ) )
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" }, true )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } ) 

end
