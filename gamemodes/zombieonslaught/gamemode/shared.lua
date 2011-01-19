
GM.Name 	= "Zombie Onslaught"
GM.Author 	= "Rambo_6"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Help		= "Survive the zombie apocalypse.\n\nUpgrade your weapons by getting kills and helping teammates."
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 20
GM.NoPlayerSuicide = true
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false

GM.MaximumDeathLength = 20			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.ForceJoinBalancedTeams = false	// Players won't be allowed to join a team if it has more players than another team

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 15			// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 90				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false// CS Style rules

GM.SelectModel = false				// Players cannot pick a playermodel

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 0				// The time between you dying and it going into spectator mode, 0 disables

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player", "npc_zombie_normal" }	// Entities we can spectate

TEAM_ALIVE = 1
TEAM_DEAD = 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_ALIVE, "Survivors", Color( 80, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_ALIVE, { "info_player_counterterrorist", "info_player_rebel", "info_player_survivor" } )
	team.SetClass( TEAM_ALIVE, { "Engineer", "Medic", "Support", "Militant" } )
	
	team.SetUp( TEAM_DEAD, "Zombies", Color( 255, 80, 80 ), false )
	team.SetSpawnPoint( TEAM_DEAD, { "info_player_terrorist", "info_player_combine", "info_player_zombie"} )
	team.SetClass( TEAM_DEAD, { "Undead", "Ghoul", "Crawler", "Wretch", "Contagion", "Biohazard", "Soldier" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_terrorist","info_player_zombie","info_player_rebel","info_player_start"} ) 

end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( ply:Team() == TEAM_DEAD && teamid != TEAM_SPECTATOR ) then
		ply:ChatPrint( "Wait until the game ends!" )
		return false
	end
	
	return true
	
end


function GM:ShouldCollide( ent1, ent2 )

	/*if string.find( ent1:GetModel(), "wood_chunk" ) or string.find( ent2:GetModel(), "wood_chunk" ) then
		if ( ent1:IsPlayer() and ent1:Team() == TEAM_ALIVE ) or ( ent2:IsPlayer() and ent2:Team() == TEAM_ALIVE ) then
			return false
		end
	end*/
	
	if string.find( ent1:GetClass(), "npc" ) or string.find( ent2:GetClass(), "npc" ) then
		if ( ent1:IsPlayer() and ent1:Team() == TEAM_DEAD ) or ( ent2:IsPlayer() and ent2:Team() == TEAM_DEAD ) then
			return false
		end
	end
	
	return true

end
