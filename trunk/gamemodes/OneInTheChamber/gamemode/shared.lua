
GM.Name 	= "One In The Chamber"
GM.Author 	= "Adobe Ninja"
GM.Email 	= "admin@adobeninja.net"
GM.Website 	= "adobeninja.net"

function GM:Initialize()

	self.BaseClass.Initialize( self )

	
end

GM.Data = {}
 
DeriveGamemode( "fretta" )
IncludePlayerClasses()					// Automatically includes files in "gamemode/player_class"
 
GM.TeamBased = true					// Team based game or a Free For All game?
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15
GM.RoundLimit = 10					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up
 
GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true	// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = false			// -1 frag on suicide
 
GM.MaximumDeathLength = 0			// Player will respawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 0			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)
 
GM.NoAutomaticSpawning = true		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 2					// Round length, in seconds
GM.RoundPreStartTime = 10			// Preperation time before a round starts
GM.RoundPostLength = 17			// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = true	// CS Style rules
 
GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 5				// The time between you dying and it going into spectator mode, 0 disables
 
GM.SelectModel = false               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)
 
GM.PlayerRingSize = 48              // How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"
 
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate
GM.CanOnlySpectateOwnTeam = false // you can only spectate players on your own team



TEAM_SPETSNAZ = 1
TEAM_RANGERS = 2
 
function GM:CreateTeams()

 
 
	if ( !GAMEMODE.TeamBased ) then return end
	-- Spetsnaz
	team.SetUp( TEAM_SPETSNAZ, "Spetsnaz", Color( 200, 0, 50 ), true )
	team.SetSpawnPoint( TEAM_SPETSNAZ, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetClass( TEAM_SPETSNAZ, { "Spetsnaz" } ) // "Spetsnaz" is the class we want Red players to use
	-- Rangers
	team.SetUp( TEAM_RANGERS, "Rangers", Color( 50, 50, 200 ), true )
	team.SetSpawnPoint( TEAM_RANGERS, { "info_player_start", "info_player_counterterrorist", "info_player_combine", "info_player_deathmatch" } )
	team.SetClass( TEAM_RANGERS, { "Rangers" } ) // "Rangers" is the class we want Blue players to use
	
	--Spectators
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist", "info_player_combine", "info_player_rebel" } ) 
 
end

