GM.Name 	= "Ultimate Hide And Seek 2.0"
GM.Author 	= "Hardy"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "As seeker - try to find other players. \n As hider - try to stay hidden"

DeriveGamemode("fretta")

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15
GM.RoundLimit = 13					// Maximum amount of rounds to be played in round based games

GM.NoPlayerSuicide = true
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats

GM.MaximumDeathLength = 10			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = false     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 180				// Round length, in seconds
GM.RoundPreStartTime = 15			// Preperation time before a round starts
GM.RoundPostLength = 5				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = true // CS Style rules

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 4				// The time between you dying and it going into spectator mode, 0 disables

GM.SelectModel = false               // Can players use the playermodel picker in the F1 menu?
GM.SelectClass = false 				//111

IncludePlayerClasses()

TEAM_HIDERS = 10
TEAM_SEEKERS = 11


function GM:CreateTeams() //Creating some teams...
team.SetUp( TEAM_HIDERS, "Hiders", Color(0, 0, 255), true)
team.SetSpawnPoint(TEAM_HIDERS, { "info_player_terrorist", "info_player_start" })
team.SetClass(TEAM_HIDERS, {"hider"})

team.SetUp(TEAM_SEEKERS, "Seekers", Color(255, 0, 0), false )
team.SetSpawnPoint(TEAM_SEEKERS, { "info_player_terrorist", "info_player_start" })
team.SetClass(TEAM_SEEKERS, {"seeker"})

team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_terrorist", "info_player_rebels", "point_viewcontrol", "info_player_start" } )
team.SetClass(TEAM_SPECTATOR, {"Spectator"})
end

--Name, description, weapon (if required), model for icon, price, for both teams?, use function?, function (if required, will override weapon)
ShopTable = {
{"Projectile crowbar", "Gives you one crowbar each round which you can throw", "hns_crowbar", "models/Weapons/w_crowbar.mdl", 5},
{"Pistol", "Gives you a pistol each round", "weapon_pistol", "models/Weapons/W_pistol.mdl", 8},
{"Magnum", "Gives you a magnum revolver each round", "weapon_357", "models/Weapons/W_357.mdl", 10},
{"SMG", "Gives you a sub machine gun each round", "weapon_smg1", "models/Weapons/w_smg1.mdl", 15},
{"Shotgun", "Gives you a shotgun each round", "weapon_shotgun", "models/Weapons/w_shotgun.mdl", 20},
{"Grenade", "Gives you a grenade each round", "weapon_frag", "models/Weapons/w_grenade.mdl", 30},
{"Restore invisibility", "Restores invisibility right after you buy this", nil, "models/props_junk/glassjug01.mdl", 20, true, true, "invis"}
}
