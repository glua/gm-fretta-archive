
GM.Name 	= "Contract Killers"
GM.Author 	= "st0rmforce"
GM.Email 	= "st0rmforce.firest0rm@googlemail.com"
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Hunt down your target. But be careful, because somebody is hunting you at the same time. \
You can only kill your target or your hunter"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 5
GM.GameLength = 15
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = false
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = false
GM.NoAutomaticSpawning = true		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 5					// Round length, in seconds
GM.RoundPreStartTime = 3			// Preperation time before a round starts
GM.RoundPostLength = 5				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

TEAM_PLAYERS = 1

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_PLAYERS, "Contract Killers", Color( 10, 200, 50 ), true )
	team.SetSpawnPoint( TEAM_PLAYERS, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } )
	team.SetClass( TEAM_PLAYERS, { "Hitman","Sniper","Thug" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } ) 

end
