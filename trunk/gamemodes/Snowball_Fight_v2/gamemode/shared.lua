
GM.Name 	= "Snowball Fight"
GM.Author 	= "Dr. Dare"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Throw icy snowballs of death to destroy the other team and take over christmas!"

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

GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 3				// The time between you dying and it going into spectator mode, 0 disables
	
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
	
	team.SetUp( TEAM_RED, "Team Santa", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_RED, {"info_player_counterterrorist","info_player_rebel"} )
	team.SetClass( TEAM_RED, { "Scout", "IceThrower", "SnowThrower" } )
	
	team.SetUp( TEAM_BLUE, "Team Frost", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, {"info_player_terrorist","info_player_combine"} )
	team.SetClass( TEAM_BLUE, { "Scout", "IceThrower", "SnowThrower" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_combine" } ) 

end
