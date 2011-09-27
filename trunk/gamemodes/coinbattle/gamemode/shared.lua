
include("sh_meta.lua")
include("sh_tables.lua")

/*
	TODO:
		-Lots of weapons.
			-Medigun (or health station? Both?)
				-Effects
			-Tesla (primary)
			-sentry gun (secondary)

		-Make crosshair way better and dynamic

		-Add killers steam avatar to the snapshot message.
*/

GM.Name		= "Coin Battle"
GM.Author	= "CowThing"
GM.Email	= ""
GM.Website	= ""
GM.Help		= "Gather coins by attacking the enemy, the team with the most coins wins! Press F3 at the beginning of a round to buy new weapons with the coins you've earned in the past rounds!\n\nGold Coins = 10 points\nSilver Coins = 5 points\nCopper Coins = 1 point"

GM.TeamBased = true					// Team based game or a Free For All game?
GM.AllowAutoTeam = true				// Allow auto-assign?
GM.AllowSpectating = true			// Allow people to spectate during the game?
GM.SecondsBetweenTeamSwitches = 10	// The minimum time between each team change?
GM.GameLength = 24					// The overall length of the game
GM.RoundLimit = 6					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up

GM.NoPlayerSuicide = true			// Set to true if players should not be allowed to commit suicide.
GM.NoPlayerDamage = false			// Set to true if players should not be able to damage each other.
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = false		// -1 frag on suicide

GM.MaximumDeathLength = 0			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 7			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = false     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false		// Set to true if you want realistic fall damage instead of the fix 10 damage.
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 180				// Round length, in seconds
GM.RoundPreStartTime = 30			// Preperation time before a round starts
GM.RoundPostLength = 10				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false// CS Style rules

GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 3				// The time between you dying and it going into spectator mode, 0 disables

GM.SelectModel = true               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)

GM.PlayerRingSize = 48              // How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"			// The Derma skin to use for the HUD components
GM.SuicideString = "died"			// The string to append to the player's name when they commit suicide.
GM.DeathNoticeDefaultColor = Color( 255, 255, 0 ) // Default colour for entity kills
GM.DeathNoticeTextColor = color_white // colour for text ie. "died", "killed"

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING } // The spectator modes that are allowed
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate, players being the obvious default choice.
GM.CanOnlySpectateOwnTeam = true	// you can only spectate players on your own team

GM.Debug = CreateConVar("cb_debug","0",FCVAR_SERVER_CAN_EXECUTE)

DeriveGamemode("fretta")
IncludePlayerClasses()

TEAM_CYAN = 1
TEAM_ORANGE = 2

function GM:CreateTeams()
	
	team.SetUp(TEAM_CYAN, "Cyan Team", Color(0,156,215), true)
	team.SetSpawnPoint(TEAM_CYAN, {"info_player_counterterrorist", "info_player_combine", "info_player_allies"})
	team.SetClass(TEAM_CYAN, "Default")
	
	team.SetUp(TEAM_ORANGE, "Orange Team", Color(245,130,32), true)
	team.SetSpawnPoint(TEAM_ORANGE, {"info_player_terrorist", "info_player_rebel", "info_player_axis"})
	team.SetClass(TEAM_ORANGE, "Default")
	
end
