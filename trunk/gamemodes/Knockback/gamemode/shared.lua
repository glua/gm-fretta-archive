
GM.Name 	= "Knockback"
GM.Author 	= "Hideous and Don Andy"
GM.Email 	= "iamnotemployed@gmail.com"
GM.Website 	= "http://hideou.se/"

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Help		= "Shoot other players to increase their damage,\nthen knock them off the map with the knockback cannon!\n\nJust like Smash Bros!"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 10
GM.NoPlayerSuicide = true
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true
GM.NoPlayerTeamDamage = false
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = true

GM.MaximumDeathLength = 0			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 15			// Player has to be dead for at least this long
GM.ForceJoinBalancedTeams = false	// Players won't be allowed to join a team if it has more players than another team

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 4 * 60				// Round length, in seconds 
GM.RoundEndsWhenOneTeamAlive = false

TEAM_ALIVE = 1
TEAM_DEAD = 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_ALIVE, "Fighters", Color( 80, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_ALIVE, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"} )
	team.SetClass( TEAM_ALIVE, { "Default" } )
	
	team.SetUp( TEAM_DEAD, "Dead People", Color( 255, 80, 80 ), false )
	team.SetSpawnPoint( TEAM_DEAD, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"} )
	team.SetClass( TEAM_DEAD, { "Dead" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"} ) 

end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( ply:Team() == TEAM_DEAD ) then
		ply:ChatPrint( "Wait until the round ends!" )
		return false
	end
	
	return true
	
end
