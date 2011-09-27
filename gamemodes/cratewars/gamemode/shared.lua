DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Name 	= "Crate Wars"
GM.Author 	= "Douglas Huck and Paul Sweeney of Match Head Studios"
GM.Email 	= "matchheadstudios@gmail.com"
GM.Website 	= "http://MatchHeadStudios.com"
GM.Help		= "Build Round: Build a base out of your starting crates to protect your your self and your flag. Fight Round: Get more points then the enemy by killing players (1 point) or caping flags (5 points). Highest points at the end wins."

GM.TeamBased = true	
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15
GM.RoundLimit = 10					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 10					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = false		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = false		// -1 frag on suicide

GM.MaximumDeathLength = 2			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 1			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false
GM.AddFragsToTeamScore = true		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = true		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 600				// Round length, in seconds
GM.RoundPreStartTime = 120			// Preperation time before a round starts
GM.RoundPostLength = 15				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 1				// The time between you dying and it going into spectator mode, 0 disables

GM.SelectModel = false               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)

TEAM_RED = 1
TEAM_BLUE = 2

GM.ValidSpectatorModes = { OBS_MODE_IN_EYE }

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()
	
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 0, 0, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, {"info_player_counterterrorist","info_player_combine","info_player_start"} )
	team.SetClass( TEAM_BLUE, { "blue" } )
	
	team.SetUp( TEAM_RED, "Red Team", Color( 255, 0, 0 ), true )
	team.SetSpawnPoint( TEAM_RED, {"info_player_terrorist","info_player_rebel","info_player_start"} )
	team.SetClass( TEAM_RED, { "red" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"} ) 

end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( ply:Team() == TEAM_DEAD && teamid != TEAM_SPECTATOR ) then
		ply:ChatPrint( "Wait until the round ends!" )
		return false
	end
	
	return true
	
end