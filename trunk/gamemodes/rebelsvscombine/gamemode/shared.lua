GM.Name 	= "Rebels vs. Combine"
GM.Author 	= "TotalMark, Rambo_6, Worshipper, dime, Dr. Dare, Svendbenno, Hlfdead"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Kill the other team"
/*

Rambo_6' tutorial was the most essential part of this gamemode, without it, it would be nowhere.
Worshipper's MedKit model and icons.
dime's medkit v_model.
Dr. Dare's Snowball init.lua helped out inmensely.
Svendbenno's playermodel list was crucial to the rebel team.
Hlfdead's medic player models.

*/
GM.Data = {}
 
DeriveGamemode( "fretta" )


IncludePlayerClasses()					// Automatically includes files in "gamemode/player_class"
 
GM.TeamBased = true					// Team based game or a Free For All game?
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 30
GM.GameLength = 25
GM.RoundLimit = 5					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Set to true to prevent players from taking damage from themselves (ie. grenades). 
GM.NoPlayerTeamDamage = true		// Set to true to prevent team damage. 
GM.NoPlayerPlayerDamage = false 	// Set to true to prevent player vs. player damage. 
GM.NoNonPlayerPlayerDamage = false 	// Set to true to prevent players from taking damage from non-players. 
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = true			// -1 frag on suicide
 
GM.MaximumDeathLength = 8			// Player will respawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 2			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true      // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true		// Set to true to use realistic fall damage instead of the fixed 10 damage. 
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)
 
GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 300				// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 5				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false	// CS Style rules
 
GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 3				// The time between you dying and it going into spectator mode, 0 disables
 
GM.SelectModel = false               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)
 
GM.PlayerRingSize = 48              // How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"

GM.SuicideString = "killed themself."
 
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE }
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate
GM.CanOnlySpectateOwnTeam = true // you can only spectate players on your own team

TEAM_REBEL = 1
TEAM_COMBINE = 2

function GM:CreateTeams()
 
	if ( !GAMEMODE.TeamBased ) then return end
 
	team.SetUp( TEAM_REBEL, "Rebels", Color( 127, 0, 0 ), true )
	team.SetSpawnPoint( TEAM_REBEL, { "info_player_counterterrorist", "info_player_rebel" } )
	team.SetClass( TEAM_REBEL, { "R_Rifleman", "R_SMG_Gunner", "R_Medic" } )
	
	team.SetUp( TEAM_COMBINE, "Combine", Color( 0, 0, 127 ), true )
	team.SetSpawnPoint( TEAM_COMBINE, { "info_player_terrorist", "info_player_combine" } )
	team.SetClass( TEAM_COMBINE, { "C_Rifleman", "C_SMG_Gunner", "C_Medic" } )
 
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 0, 127, 0 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist", "info_player_combine", "info_player_rebel" } ) 
 
end
