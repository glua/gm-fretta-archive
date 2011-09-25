GM.Name 	= "OddBall"
GM.Author 	= "BlackOps7799"
GM.Email 	= "blackops7799@gmail.com"
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Help		= "Help your team capture the OddBall for the longest amount of time!"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 5
GM.SelectClass = true
GM.GameLength = 30

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		
GM.NoPlayerTeamDamage = true		
GM.NoPlayerPlayerDamage = false 	
GM.NoNonPlayerPlayerDamage = false 	

GM.EnableFreezeCam = false				// TF2 Style Freezecam
GM.DeathLingerTime = 5					// The time between you dying and it going into spectator mode, 0 disables

GM.MaximumDeathLength = 20				// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 10				// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true     		// Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true		// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true			// Break their fucking legs

GM.NoAutomaticSpawning = false			// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true					// Round based, like CS
GM.RoundLength = 360					// Round length, in seconds
GM.RoundEndsWhenOneTeamAlive = false	// CS Style rules

GM.SpectateAllPlayers = true			// When true, when a player is assigned to a team, it allows them to spec any player

TEAM_RED = 1
TEAM_BLUE = 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_RED, "Red Team", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_RED, {"info_player_terrorist", } )
	team.SetClass( TEAM_RED, { "HL2", "Assault", "Rifleman", "Scout", "Shotgunner" } )
	
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_counterterrorist", } )
	team.SetClass( TEAM_BLUE, { "HL2", "Assault", "Rifleman", "Scout", "Shotgunner" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start" } )

end
