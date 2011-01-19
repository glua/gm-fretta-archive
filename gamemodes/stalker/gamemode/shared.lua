
GM.Name 	= "The Stalker"
GM.Author 	= "Rambo_6"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help	= "As a soldier, take down the stalker before he kills off your team.\n\nAs the stalker, eliminate every soldier.\n\n\nPress your USE key as the stalker to toggle your ability menu.\nPress your SPRINT key as the stalker to leap and cling to walls."
GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 5
GM.GameLength = 15
GM.RoundLength = 60 * 6
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoPlayerSuicide = true
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = false

GM.EnableFreezeCam = false
GM.DeathLingerTime = 5			
GM.MaximumDeathLength = 10			
GM.MinimumDeathLength = 5			
GM.ForceJoinBalancedTeams = false	

GM.NoAutomaticSpawning = true	
GM.RoundBased = true			
GM.RoundEndsWhenOneTeamAlive = false

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING } 
GM.ValidSpectatorEntities = { "player" }	
GM.CanOnlySpectateOwnTeam = true 

TEAM_HUMAN = 1
TEAM_STALKER = 2

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_HUMAN, "Unit 8", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_counterterrorist", "info_player_combine", "info_player_deathmatch" } )
	team.SetClass( TEAM_HUMAN, { "M3", "SG552", "FAMAS", "P90" } )
	
	team.SetUp( TEAM_STALKER, "The Stalker", Color( 255, 80, 80 ), false )
	team.SetSpawnPoint( TEAM_STALKER, { "info_player_start", "info_player_terrorist", "info_player_rebel" } )
	team.SetClass( TEAM_STALKER, { "Stalker" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_rebel" } ) 

end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( ply:Team() == TEAM_STALKER && teamid != TEAM_SPECTATOR ) then
	
		ply:ChatPrint( "You cannot join that team!" )
		return false
		
	end
	
	return true
	
end
