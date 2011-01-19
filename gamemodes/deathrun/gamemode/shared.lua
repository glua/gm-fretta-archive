GM.Name 	= "Deathrun"
GM.Author 	= "samm5506"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Go through the series of traps and kill the deaths!"

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 5
GM.SelectClass = true
GM.GameLength = 30

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		
GM.NoPlayerTeamDamage = true		
GM.NoPlayerPlayerDamage = false 	
GM.NoNonPlayerPlayerDamage = false 	

GM.EnableFreezeCam = false				// TF2 Style Freezecam
GM.DeathLingerTime = 3					// The time between you dying and it going into spectator mode, 0 disables

GM.MaximumDeathLength = 20				// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 10				// Player has to be dead for at least this long
GM.AutomaticTeamBalance = false     	// Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true		// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true			// Break their fucking legs

GM.NoAutomaticSpawning = true			// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true					// Round based, like CS
GM.RoundLength = 300					// Round length, in seconds
GM.RoundEndsWhenOneTeamAlive = true		// CS Style rules

GM.SpectateAllPlayers = false			// When true, when a player is assigned to a team, it allows them to spec any player

GM.SelectModel = false               	// Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false					// Can players modify the colour of their name? (ie.. no teams)
 
GM.PlayerRingSize = 48              	// How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"
 
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate
GM.CanOnlySpectateOwnTeam = false 			// you can only spectate players on your own team


TEAM_RUNNER = 3
TEAM_DEATH = 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_RUNNER, "Runners", Color( 0, 162, 232 ), true )
	team.SetSpawnPoint( TEAM_RUNNER, { "info_player_counterterrorist" } )
	team.SetClass( TEAM_RUNNER, { "Runners" } )
	
	team.SetUp( TEAM_DEATH, "Deaths", Color( 237, 28, 36 ), false )
	team.SetSpawnPoint( TEAM_DEATH, {"info_player_terrorist"} )
	team.SetClass( TEAM_DEATH, { "Deaths" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 70, 70, 70 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start" } )

end

/*---------------------------------------------------------
	NearSpawn
---------------------------------------------------------*/
local EntMeta = FindMetaTable("Entity")

local Spawns = {
	"info_player_start",
	"info_player_terrorist",
	"info_player_counterterrorist"
}

function EntMeta:IsNearSpawn()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 75)) do
		if(table.HasValue(Spawns, v:GetClass())) then
			return true
		end
	end
	return false
end

if(SERVER) then
	return
end