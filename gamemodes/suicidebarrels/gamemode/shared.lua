
GM.Name 	= "Suicide Barrels"
GM.Author 	= "Otoris"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Humans: Watch out for moving barrels!\nBarrels: Destroy all humans! Watch out though, they have guns now!"
GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 10
GM.RoundLength = 120
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoPlayerSuicide = true
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = false

GM.MaximumDeathLength = 0			
GM.MinimumDeathLength = 3			
GM.ForceJoinBalancedTeams = false	

GM.NoAutomaticSpawning = false		
GM.RoundBased = true			
GM.RoundEndsWhenOneTeamAlive = false

TEAM_HUMAN = 1
TEAM_BARREL = 2

TAUNTS = {

	"vo/npc/male01/behindyou01.wav",
	"vo/npc/male01/behindyou02.wav",
	"vo/npc/male01/zombies01.wav",
	"vo/npc/male01/watchout.wav",
	"vo/npc/male01/upthere01.wav",
	"vo/npc/male01/upthere02.wav",
	"vo/npc/male01/thehacks01.wav",
	"vo/npc/male01/strider_run.wav",
	"vo/npc/male01/runforyourlife01.wav",
	"vo/npc/male01/runforyourlife02.wav",
	"vo/npc/male01/runforyourlife03.wav"
	
}

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_HUMAN, "Humans", Color( 255, 200, 50 ), true )
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetClass( TEAM_HUMAN, { "Human" } )
	
	team.SetUp( TEAM_BARREL, "Barrels", Color( 255, 0, 0 ), false )
	team.SetSpawnPoint( TEAM_BARREL, { "info_player_start", "info_player_counterterrorist", "info_player_combine" }, true )
	team.SetClass( TEAM_BARREL, { "Barrel" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist", "info_player_combine", "info_player_rebel" } ) 

end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( ply:Team() == TEAM_BARREL ) then
		ply:ChatPrint( "You can not leave us!" )
		return false
	end
	
	return true
	
end
