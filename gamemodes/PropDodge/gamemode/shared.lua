GM.Name 	= "PropDodge"
GM.Author 	= "Redx475 and Jakegadget"
GM.Email 	= "redx475@gameavengers.net"
GM.Website 	= ""
GM.Help		= "Prop kill your way to victory!"
 
GM.Data = {}

DeriveGamemode( "fretta" )
 
GM.TeamBased = true					// Team based game or a Free For All game?
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 20
GM.RoundLimit = 15					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up
 
GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = true			// -1 frag on suicide
 
GM.MaximumDeathLength = 10			// Player will respawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true
GM.AddFragsToTeamScore = true		// Adds player's individual kills to team score (must be team based)
 
GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 3					// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 5				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false	// CS Style rules
 
GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 3				// The time between you dying and it going into spectator mode, 0 disables
 
GM.SelectModel = true               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)
 
GM.PlayerRingSize = 48              // How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"
 
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate
GM.CanOnlySpectateOwnTeam = false // you can only spectate players on your own team

TEAM_RED = 1
TEAM_BLUE = 2
TEAM_GREEN = 3

function GM:CreateTeams()

	team.SetUp( TEAM_RED, "Team Red", Color( 255, 0, 0 ), true )
	team.SetSpawnPoint( TEAM_RED, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_combine", "info_player_rebel" } )
	
	team.SetUp( TEAM_BLUE, "Team Blue", Color( 0, 0, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_combine", "info_player_rebel" } )
	
	team.SetUp( TEAM_GREEN, "Team Green", Color( 0, 255, 0 ), true )
	team.SetSpawnPoint( TEAM_GREEN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_combine", "info_player_rebel" } )

end