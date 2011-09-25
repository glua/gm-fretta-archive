
GM.Name 	= "Terminal Velocity"
GM.Author 	= "Rambo_6"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Smashdfsfsg"

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.TeamBased = true	
GM.SelectClass = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 18
GM.RoundLimit = 3					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up

GM.NoPlayerSuicide = true
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = false		// -1 frag on suicide

GM.MaximumDeathLength = 10			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true      // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 5				// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 10				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 5				// The time between you dying and it going into spectator mode, 0 disables

TEAM_RED = 1
TEAM_BLUE = 2

function GM:CreateTeams()

	team.SetUp( TEAM_RED, "Red Barons", Color( 255, 55, 55 ), true )
	team.SetSpawnPoint( TEAM_RED, "info_player_terrorist" )
	team.SetClass( TEAM_RED, { "Wasp", "Falcon", "Osprey", "Flak Trooper" } )
	
	team.SetUp( TEAM_BLUE, "Blue Bombers", Color( 55, 55, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, "info_player_counterterrorist" )
	team.SetClass( TEAM_BLUE, { "Wasp", "Falcon", "Osprey", "Flak Trooper" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist" } )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end


