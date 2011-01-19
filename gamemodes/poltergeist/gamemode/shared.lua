
GM.Name 	= "Poltergeist"
GM.Author 	= "Rambo_6"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help	= "As a human, stay alive until the round ends.\n\nAs a poltergeist, kill all of the humans."
GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 10
GM.RoundLength = 60 * 3
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoPlayerSuicide = true
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = false

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 0				// The time between you dying and it going into spectator mode, 0 disables

GM.MaximumDeathLength = 10			
GM.MinimumDeathLength = 5			
GM.ForceJoinBalancedTeams = false	

GM.NoAutomaticSpawning = false		
GM.RoundBased = true			
GM.RoundEndsWhenOneTeamAlive = false

TEAM_HUMAN = 1
TEAM_GHOST = 2

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_HUMAN, "Humans", Color( 80, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetClass( TEAM_HUMAN, { "Human" } )
	
	team.SetUp( TEAM_GHOST, "Poltergeists", Color( 255, 80, 80 ), false )
	team.SetSpawnPoint( TEAM_GHOST, { "info_player_start", "info_player_counterterrorist", "info_player_combine" }, true )
	team.SetClass( TEAM_GHOST, { "Explosive", "Boost" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist", "info_player_combine", "info_player_rebel" } ) 

end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( ply:Team() == TEAM_GHOST && teamid != TEAM_SPECTATOR ) then
		ply:ChatPrint( "Wait until the round ends!" )
		return false
	end
	
	return true
	
end
