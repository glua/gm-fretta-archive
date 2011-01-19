
GM.Name 	= "Sniper Wars"
GM.Author 	= "Rambo_6"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Snipe the enemy team!\n\nEarn bonus points for long distance kills!"

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.SelectClass = true
GM.GameLength = 20
GM.RoundLimit = 5					// Maximum amount of rounds to be played in round based games

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		
GM.NoPlayerTeamDamage = true		
GM.NoPlayerPlayerDamage = false 	
GM.NoNonPlayerPlayerDamage = false 	

GM.MaximumDeathLength = 15			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 8			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true      // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true
GM.TakeFragOnSuicide = false		// -1 frag on suicide

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 5				
GM.RoundEndsWhenOneTeamAlive = false

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 0				// The time between you dying and it going into spectator mode, 0 disables
	
GM.ValidSpectatorModes = { OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player" }	
GM.CanOnlySpectateOwnTeam = false

TEAM_RED = 1
TEAM_BLUE = 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_RED, "Red Team", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_RED, {"info_player_counterterrorist","info_player_rebel"} )
	team.SetClass( TEAM_RED, { "NormalSniper", "StealthSniper", "AutoSniper", "RailgunSniper", "LaserSniper" } )
	
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, {"info_player_terrorist","info_player_combine"} )
	team.SetClass( TEAM_BLUE, { "NormalSniper", "StealthSniper", "AutoSniper", "RailgunSniper", "LaserSniper" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_combine" } ) 

end
