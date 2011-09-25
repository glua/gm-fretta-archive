
GM.Name 	= "GMOD GunGame"
GM.Author 	= "Dylan Winn"
GM.Email 	= ""
GM.Website 	= "http://www.dylanwinn.com/"

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Shoot the other team! \nGet a better gun for every kill, and race to the highest level. \nSteal levels with knife kills. /nOn nade level, get more nades by gibbing people."
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.ForceJoinBalancedTeams = true
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = true

TEAM_T = 1
TEAM_CT = 2


function GM:CreateTeams()
	
	team.SetUp( TEAM_T, "Terrorists", Color( 255, 80, 80 ) )
	team.SetSpawnPoint( TEAM_T, { "info_player_terrorist" }, true )
	
	team.SetUp( TEAM_CT, "Counter-Terrorists", Color( 80, 150, 255 ) )
	team.SetSpawnPoint( TEAM_CT, { "info_player_counterterrorist" }, true )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } ) 
end
