
GM.Name 	= "Cactus"
GM.Author 	= "Grea$eMonkey"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Help		= "Catch as many cacti as you can!\nGrab them with your gravity gun.\n\nSlow Cacti (blue) get you 1 point.\nNormal Cacti (green) get you 2 points.\nFast Cacti (red) get you 3 points.\nPowerup Cacti (pink) will give you 1 point and a random upgrade.\nExplosive Cacti (disguised as any other cactus) will explode after a certain duration.\n\nGolden Cacti (yellow) get you 8 points!"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true		
GM.NoPlayerTeamDamage = false		
GM.NoPlayerPlayerDamage = false	
GM.NoNonPlayerPlayerDamage = false 	

GM.EnableFreezeCam = false				// TF2 Style Freezecam
GM.DeathLingerTime = 0					// The time between you dying and it going into spectator mode, 0 disables
GM.MaximumDeathLength = 0				// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 10				// Player has to be dead for at least this long
GM.AutomaticTeamBalance = false      	// Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false		// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false

GM.NoAutomaticSpawning = false			// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true					// Round based, like CS
GM.RoundLength = 60*3					// Round length, in seconds
GM.RoundEndsWhenOneTeamAlive = false	// CS Style rules

GM.SpectateAllPlayers = false			// When true, when a player is assigned to a team, it allows them to spec any player
GM.EnableFreezeCam = false				// TF2 Style Freezecam
GM.DeathLingerTime = 3					// The time between you dying and it going into spectator mode, 0 disables

GM.ValidSpectatorModes = { OBS_MODE_CHASE }
GM.ValidSpectatorEntities = { "cactus" }	

TEAM_PLAYER = 1

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_PLAYER, "Player", Color( 80, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_PLAYER, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"} )
	team.SetClass( TEAM_PLAYER, { "Default" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start","info_cactus_spawn"} ) 

end
	
	
	
	
	
	
	
	
