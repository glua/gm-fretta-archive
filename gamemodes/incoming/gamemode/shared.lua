GM.Name 	= "INCOMING!!!"
GM.Author 	= "sammm5506, Chewgum"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Dodge incoming props to get to the top of the map and win.\n\nGamemode originally created by Chewgum."
 
GM.Data = {}
 
DeriveGamemode( "fretta" )
IncludePlayerClasses()					// Automatically includes files in "gamemode/player_class"
 
GM.TeamBased = false	
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15
GM.RoundLimit = 15					// Maximum amount of rounds to be played in round based games
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

GM.MaximumDeathLength = 0			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = false     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = true		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 3				// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 10				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 5				// The time between you dying and it going into spectator mode, 0 disables

GM.SelectModel = true
GM.SelectColor = true

//TEAM_UNASSIGNED = 1
 
function GM:CreateTeams()
	
	team.SetUp( TEAM_UNASSIGNED, "Players", Color( 80, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_UNASSIGNED, "info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start" )
	team.SetClass( TEAM_UNASSIGNED, { "Default" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"} ) 

end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	/*if ( teamid != TEAM_SPECTATOR ) then
		ply:ChatPrint( "Wait until the round ends!" )
		return false
	end*/
	
	return true
	
end