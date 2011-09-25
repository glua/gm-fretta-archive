include( "partlist.lua" )

GM.Name 	= "Gamemaster"
GM.Author 	= "Dlaor"
GM.Email 	= ""
GM.Website 	= "http://www.facepunch.com/member.php?u=103210"
GM.SecondsBetweenTeamSwitches = 5

GM.TeamBased = true
GM.AllowSpectating = false
GM.GameLength = 20
GM.RoundLimit = 10
GM.RoundLength = 60 * 2.5
GM.RoundBased = true
GM.RoundPreStartTime = 0.1
GM.NoAutomaticSpawning = true
GM.ForceJoinBalancedTeams = false
GM.SelectModel = false
GM.Help	= "Gamemaster is a platform game, with a twist - the level is controlled by a human, trying to prevent the players from completing the level. As a runner, you have to survive the level and get to the end. As the Gamemaster, you must kill all the runners."

DeriveGamemode( "fretta" )
IncludePlayerClasses()

POWERUP_RADIUS = 60
TEAM_RUNNER = 1
TEAM_GAMEMASTER = 2

place_delay = 0.7

function TooClose( pos )

	local tooclose = false
	
	for _, v in pairs( team.GetPlayers( TEAM_RUNNER ) ) do
		if ( !v:Alive() ) then return end
		if ( ( ( v:GetPos() + Vector( 0, 0, 36 ) ) - pos ):Length() < 800 ) then tooclose = true break end
	end
	
	/*for _, v in pairs( ents.FindByClass( "npc_*" ) ) do
		if ( ( v:LocalToWorld( v:OBBCenter() ) - pos ):Length() < 1 ) then tooclose = true break end
	end*/
	
	return tooclose
	
end

function CanPlace( ply, trace, part )
	if ( CLIENT ) then
		return vgui.IsHoveringWorld() and !trace.HitSky and !too_fast and has_part and trace.HitNormal == Vector( 0, -1, 0 ) and ply:Team() == TEAM_GAMEMASTER
	else
		return trace.HitNormal == Vector( 0, -1, 0 ) and !trace.HitSky and ply:Team() == TEAM_GAMEMASTER
	end
end

function col2vec( col ) //Best function ever
	return Vector( col.r, col.g, col.b )
end

function GM:CreateTeams()
	
	team.SetUp( TEAM_RUNNER, "Team Runners", Color( 54, 169, 207 ) )
	team.SetSpawnPoint( TEAM_RUNNER, "info_player_start" )
	team.SetClass( TEAM_RUNNER, { "Runner" } )
	
	team.SetUp( TEAM_GAMEMASTER, "The Gamemaster", Color( 207, 54, 54 ), false )
	team.SetSpawnPoint( TEAM_GAMEMASTER, "info_player_start" )
	team.SetClass( TEAM_GAMEMASTER, { "Gamemaster" } )

end

function GM:PlayerBindPress( ply, bind, down )
	
	if ( ply:Alive() and ply:Team() == TEAM_RUNNER ) then
		if ( bind == "+forward" or bind == "+back"  ) then return true end
	end
	
	if ( ply:Team() == TEAM_GAMEMASTER ) then
		if ( bind == "+duck" or bind == "+jump" ) then return true end
	end
	
	return false
	
end

function GM:ShouldCollide( ent1, ent2 )

	if ( ent1:IsPlayer() and ent2:IsPlayer() ) then return false end //Players don't collide with eachother
	if ( ent1:IsNPC() and ent2:IsNPC() ) then return false end //NPCs don't collide with eachother
	return true
	
end