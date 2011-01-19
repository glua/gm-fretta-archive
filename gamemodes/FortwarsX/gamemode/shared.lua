
include( "prop_list.lua" ) //We need the prop list, otherwise we can't spawn shit!

GM.Name 	= "FortwarsX" //Not the most original name, but whatever
GM.Author 	= "Dlaor" //It's me, bitches!
GM.Email 	= ""
GM.Website 	= "http://www.facepunch.com/member.php?u=103210"

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Build bases in the Build Phase to protect yourself, then battle it out in the Fight Phase and try to hold onto the flag for as long as possible!\n\nPress R in the build phase to remove props."
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.RoundBased = true
GM.RoundLimit = 2
GM.RoundLength = 60 * 7.5
GM.GameLength = GM.RoundLength * 2
GM.MinimumDeathLength = 4
GM.MaximumDeathLength = 15

GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 10

GM.NoPlayerSuicide = true
GM.TakeFragOnSuicide = true
GM.AddFragsToTeamScore = false
GM.RealisticFallDamage = true

GM.RoundEndsWhenOneTeamAlive = false
GM.SelectModel = false

GM.DeathNoticeDefaultColor = Color( 255, 255, 100 )

TEAM_RED = 1
TEAM_BLUE = 2

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_RED, "Team Red", Color( 207, 25, 0 ) )
	team.SetSpawnPoint( TEAM_RED, { "info_player_terrorist" }, true )
	team.SetClass( TEAM_RED, { "Demolition Guy", "Veteran", "Scout" } )
	
	team.SetUp( TEAM_BLUE, "Team Blue", Color( 0, 115, 207 ) )
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_counterterrorist" }, true )
	team.SetClass( TEAM_BLUE, { "Demolition Guy", "Veteran", "Scout" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 157, 157, 157 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_*" ) 

end

function OnPickup( ply, ent ) //The reason this is shared is that if the client doesn't know you can't move certain stuff, the different beam effect will appear and make you think you can move stuff around
	
	if ( ent:GetClass() == "fw_prop" ) then //Only pick up fw_prop's!
		local Owner = ent:GetNWEntity( "Owner" )
		if ( ply != Owner ) then return false end //Only pick up your own stuff!
	else
		return false
	end
	
end
 
hook.Add( "PhysgunPickup", "Disabl0r", OnPickup )

function GM:GravGunPunt( ply, ent )
	if ( !ValidEntity( ent ) ) then return end
	if ( ent:GetClass() != "fw_flag" and ent:GetClass() != "fw_c4" ) then return false end //Can only punt the flag and bombs!
	return true
end

PropLimit = 30 //This might be too much, if there are 20 players in the server and they all spawn 30 props, you'll have 600 props, which means extreme server load!
//However, these props are frozen, which means they'll not send physics data to the server and back, so it might be reasonable... THE TENSION!

PropList = GeneratePropList() //This function is defined in prop_list.lua
