

//Define Cactus table shared
Cactus = {}

include( "cactus_shd.lua" )
include( "cactus_meta.lua" )
include( "ply_extension.lua" )
include( "ent_extension.lua" )

//Shared

GM.Name 	= "Cactus"
GM.Author 	= "Grea$eMonkey"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Humans try to catch cacti (plural for cactus).\n\nCacti try to evade humans and kill them.\n\nHave fun!"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 2
GM.GameLength = 9

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true		
GM.NoPlayerTeamDamage = true		
GM.NoPlayerPlayerDamage = false	
GM.NoNonPlayerPlayerDamage = false 	

GM.EnableFreezeCam = true				// TF2 Style Freezecam
GM.DeathLingerTime = 3					// The time between you dying and it going into spectator mode, 0 disables
GM.MaximumDeathLength = 0				// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5				// Player has to be dead for at least this long
GM.AutomaticTeamBalance = false      	// Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false		// Players won't be allowed to join a team if it has more players than another team
GM.NoAutomaticSpawning = true			// Players don't spawn automatically when they die, some other system spawns them
GM.RealisticFallDamage = false

GM.RoundBased = true					// Round based, like CS
GM.RoundLength = 60*3					// Round length, in seconds
GM.RoundPreStartTime = 6				// Preperation time before a round starts
GM.RoundPostLength = 11					// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundLimit = 3						// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 6						// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up
GM.RoundEndsWhenOneTeamAlive = false	// CS Style rules
 
GM.SelectModel = true	              	// Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false					// Can players modify the colour of their name? (ie.. no teams)
 
GM.PlayerRingSize = 48              	// How big are the colored rings under the player's feet (if they are enabled) ?
 
GM.SpectateAllPlayers = false			// When true, when a player is assigned to a team, it allows them to spec any player
GM.EnableFreezeCam = true				// TF2 Style Freezecam
GM.DeathLingerTime = 3					// The time between you dying and it going into spectator mode, 0 disables

GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = true

GM.ValidSpectatorModes = { OBS_MODE_CHASE }
GM.ValidSpectatorEntities = { "player", "sent_cactus", "info_cactus_spawn" }
GM.CanOnlySpectateOwnTeam = true 		// you can only spectate players on your own team

TEAM_HUMAN = 1
TEAM_CACTUS = 2

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_HUMAN, "Team Catcher", Color( 70, 70, 230 ), true )
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_counterterrorist" } )
	team.SetClass( TEAM_HUMAN, { "Grabber" } ) // This team will be able to choose their class
	
	team.SetUp( TEAM_CACTUS, "Team Cactus", Color( 70, 230, 70 ), true )
	team.SetSpawnPoint( TEAM_CACTUS, { "info_cactus_spawn", "info_player_terrorist" } )
	team.SetClass( TEAM_CACTUS, { "Cactus" } ) // This team will be able to choose their class
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_cactus_spawn", "info_player_terrorist", "info_player_counterterrorist" } ) 

end





