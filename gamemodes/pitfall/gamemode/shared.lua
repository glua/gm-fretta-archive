
GM.Name 	= "Pitfall"
GM.Author 	= "BlackOps"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= [[Shoot the platforms out below your enemies!

Use your man puncher to prevent people from getting too close.]]

GM.TeamBased = true						// Team based game or a Free For All game?
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15
GM.RoundLimit = 10						// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5						// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up
 
GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true			// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true			// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = true 			// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 		// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false			// When true, all players have silent footsteps
GM.PlayerCanNoClip = false				// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = true				// -1 frag on suicide
 
GM.AutomaticTeamBalance = false     	// Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false		// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true
GM.AddFragsToTeamScore = false			// Adds player's individual kills to team score (must be team based)
 
GM.NoAutomaticSpawning = true			// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true					// Round based, like CS
GM.RoundLength = 60 * 1.75				// Round length, in seconds
GM.RoundPreStartTime = 5				// Preperation time before a round starts
GM.RoundPostLength = 5					// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false	// CS Style rules
 
GM.EnableFreezeCam = false				// TF2 Style Freezecam
GM.DeathLingerTime = 6					// The time between you dying and it going into spectator mode, 0 disables
 
GM.SelectModel = true              	 	// Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false					// Can players modify the colour of their name? (ie.. no teams)
 
GM.PlayerRingSize = 48              	// How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"
 
GM.ValidSpectatorModes = { OBS_MODE_IN_EYE, OBS_MODE_CHASE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate
GM.CanOnlySpectateOwnTeam = false // you can only spectate players on your own team
 

TEAM_SURVIVORS = 1
TEAM_FALLEN = 2


function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_SURVIVORS, "Survivors", Color( 80, 255, 80 ), false )
	team.SetSpawnPoint( TEAM_SURVIVORS, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist", "gmod_player_start" } )
	
	team.SetUp( TEAM_FALLEN, "Fallen", Color( 255, 80, 80 ), true)
	team.SetSpawnPoint( TEAM_FALLEN, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist", "gmod_player_start" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist", "gmod_player_start" } ) 

end

local function DaNoBlocks(ent1,ent2)
	if ent1:IsPlayer() and ent2:IsPlayer() then
		return false --no player collisions
	end
	return true
end
hook.Add( "ShouldCollide", "NoBlockThatAss2", DaNoBlocks)
