AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "partlist.lua" )
include( "shared.lua" )
require( "datastream" )

local files = {}

function AddFile( file )
	table.insert( files, file )
end

AddFile( "materials/gmaster/grid_finish.vmt" )
AddFile( "materials/gmaster/grid_green.vmt" )
AddFile( "materials/gmaster/grid_normal.vtf" )
AddFile( "materials/gmaster/grid_orange.vmt" )
AddFile( "materials/gmaster/grid_red.vmt" )
AddFile( "materials/gmaster/grid_yellow.vmt" )
AddFile( "materials/sprites/gmaster/powerup_glow.vmt" )
AddFile( "materials/hud/gmaster/health.vmt" )
AddFile( "materials/hud/gmaster/health_base.vmt" )
AddFile( "materials/models/gmaster/grid_selected.vmt" )
AddFile( "materials/models/gmaster/grid_selected_error.vmt" )
AddFile( "materials/models/gmaster/powerup_medic_red.vmt" )

AddFile( "models/gmaster/pw_medic.mdl" )
AddFile( "models/gmaster/select.mdl" )

AddFile( "sound/gmaster/change_part.wav" )
AddFile( "sound/gmaster/launch.wav" )
AddFile( "sound/gmaster/message.wav" )
AddFile( "sound/gmaster/place_part.wav" )

AddFile( "sound/gmaster/end.mp3" )
AddFile( "sound/gmaster/finish.mp3" )
AddFile( "sound/gmaster/win.mp3" )

for k, v in pairs( files ) do
	resource.AddFile( v )
	MsgN( "Added file[" .. k .. "] = " .. v )
end

files = nil

local dist = 1024 //Camera distance, REMEMBER TO SELF: IF CHANGING, CHANGE IT IN CLIENT TOO!

placetime = {}

function GM_EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
 
	if ( ent:IsPlayer() and ent:Team() == TEAM_RUNNER ) then
 
		umsg.Start( "Shake", ent )
			umsg.Float( math.Clamp( dmginfo:GetDamage() * 2, 0, 100 ) )
		umsg.End()
 
	end
 
end

hook.Add( "EntityTakeDamage", "GM_EntityTakeDamage", GM_EntityTakeDamage )

function GM:OnPreRoundStart( num )

	game.CleanUpMap()
	
	for _, v in pairs( player.GetAll() ) do
		v:SetTeam( TEAM_RUNNER )
	end
	
	local players = team.GetPlayers( TEAM_RUNNER )
	local the_chosen_one = table.Random( players ) //Select random gamemaster
	the_chosen_one:SetTeam( TEAM_GAMEMASTER )
	SendUserMessage( "Help", the_chosen_one, "_gamemaster_" )
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	for _, v in pairs( player.GetAll() ) do
		v:SetNWBool( "Finished", false )
	end

end

function GM:OnDamagedByExplosion( ply, dmginfo )
 
        //ply:SetDSP( 35, false )   No BEEEEP when blown up!
 
end

function GM:OnPlayerHitGround( ply )
		
	tr = { }  
	tr.start = ply:GetPos() + Vector( 0, 0, 1 )
	tr.endpos = tr.start - Vector( 0, 0, 32 )
	tr.filter = ply
		
	local trace = util.TraceLine( tr )
		
	if ( !trace.Hit ) then return end
	if ( trace.HitSky ) then ply:Kill() end
	
end

function GM:PlayerDeathSound()
	return true --BEEEEEEEEEEEEEEEP disabled
end

function GM:CanPlayerSuicide( ply )
	return ( ply:Team() == TEAM_RUNNER ) //Gamemasters can't die!
end

function GM:PlayerCanJoinTeam( ply, teamid )
	
	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1;
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", (TimeBetweenSwitches - (RealTime()-ply.LastTeamSwitch)) + 1 ) )
		return false
	end
	
	// Already on this team!
	if ( ply:Team() == teamid ) then 
		ply:ChatPrint( "You're already on that team" )
		return false
	end
	
	if ( teamid == TEAM_RUNNER and ply:Team() == TEAM_GAMEMASTER ) then
		ply:ChatPrint( "Cannot become runner while being the Gamemaster!" )
		return false
	end                                 // PARADOX!!!!
	
	if ( ply:Team() == TEAM_RUNNER and teamid == TEAM_GAMEMASTER ) then
		ply:ChatPrint( "Cannot become the Gamemaster while being a runner!" )
		return false
	end
	
	return true
	
end

function GM:GetFallDamage( ply, flFallSpeed )
	return 0 //Arcade FTW?
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	if ( ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_RUNNER ) then
		PainSound( ent ) //OW
		ent:SetNWInt( "Stamina", math.Clamp( ent:GetNWInt( "Stamina", 0 ) - dmginfo:GetDamage()*20, 0, 1000 ) )
	end
end

function GM:PlayerShouldTakeDamage( ply, attacker ) 
	return ( ply:Team() == TEAM_RUNNER ) //Gamemasters don't take damage!
end

local soundtable = { "npc_citizen.myarm01",
		"npc_citizen.mygut02",
		"npc_citizen.myleg01",
		"npc_citizen.ow01",
		"npc_citizen.ow02",
		"npc_citizen.pain01",
		"npc_citizen.pain02",
		"npc_citizen.pain03",
		"npc_citizen.pain04",
		"npc_citizen.pain05",
		"npc_citizen.pain06",
		"npc_citizen.pain07",
		"npc_citizen.pain08",
		"npc_citizen.pain09" } 

function PainSound( ply )
	ply:EmitSound( table.Random( soundtable ) )
end

function Cancel( str, ply ) //Debug function
	print( "[Player: " .. ply:Nick() .. "] Error: " .. str )
end

function PlacePart( ply, handler, id, encoded, decoded )
	
	//print( "Received part place message!" )
	
	local part = decoded[1]
	local aimvec = decoded[2] //Can't be calculated on the server, sadly. Enable scriptenforcer to stop most of the people trying to change this on the client.
	
	if ( placetime[ ply:UniqueID() ] ) then Cancel( "Placing parts too fast!", ply ) return end
	if ( !ply:Alive() ) then Cancel( "Player wasn't alive!", ply ) return end
	if ( ply:GetNWInt( part + 1 .. "Part", 0 ) < 1 ) then Cancel( "Ran out of parts!", ply ) return end
	
	local tracedata = {}
	tracedata.start = ply:GetPos() + Vector( 0, -dist, 128 )
	tracedata.endpos = tracedata.start + ( aimvec * 5000 ) //Should be enough
	tracedata.filter = player.GetAll()
	local trace = util.TraceLine( tracedata )
	
	if ( !CanPlace( ply, trace, part ) ) then Cancel( "Can't place part according to the CanPlace function!", ply ) return end
	
	local placepos = trace.HitPos + trace.HitNormal
	placepos.x = math.Round( placepos.x / 128 ) * 128 //Snap to grid
	placepos.z = math.Round( placepos.z / 128 ) * 128 //Snap to grid
	
	if ( TooClose( placepos ) ) then Cancel( "Can't place part according to the TooClose function!", ply ) return end
	
	local ent = partlist[part + 1].func( placepos - Vector( 0, 32, 0 ) ) //Execute function from the partlist
	if ( ent:GetClass() != "npc_rollermine" and ent:GetClass() != "npc_manhack" and ent:GetClass() != "prop_physics" ) then ent:SetPos( ent:GetPos() - vector_up * 64 ) end
	ent:SetAngles( Angle( 0, 180, 0 ) )
	ent:Spawn()
	ent:Activate()
	
	if ( ent:IsNPC() ) then ent:AddRelationship( "npc_* D_NU 99" ) end
	
	ply:SetNWInt( part + 1 .. "Part", ply:GetNWInt( part + 1 .. "Part", 0 ) - 1 ) //Reduce their parts
	ply:EmitSound( "gmaster/place_part.wav", 0.27, 100 )
	
	placetime[ ply:UniqueID() ] = true
	
	timer.Create( "PartPlaced" .. ply:UniqueID(), place_delay, 1, function( t, p ) t[ p:UniqueID() ] = false end, placetime, ply ) //Can't place too many parts!

end

datastream.Hook( "PlacePart", PlacePart )

/*---------------------------------------------------------
   Name: gamemode:PlayerSelectTeamSpawn( player )
   Desc: Find a spawn point entity for this player's team
---------------------------------------------------------*/
function GM:PlayerSelectTeamSpawn( TeamID, pl )
	
	local allspawnp = ents.FindByClass( "info_player_start" )
	local round = GetGlobalInt( "RoundNumber" ) //Round we're in
	if ( round > 5 ) then round = round - 5 end
	
	if ( round == 0 ) then return allspawnp[1] end //If we're in the "waiting for players" status, spawn in the first level
	
	local SpawnPoints = {}
	
	for _, v in pairs( allspawnp ) do //For all player start points...
		if ( tonumber( v:GetNWInt( "Round", 1 ) ) == tonumber( round ) ) then //If they equal the round we're currently in...
			table.insert( SpawnPoints, v ) //Insert them in the spawnpoint table
		end
	end
	
	//print( "Successful spawnpoints:", #SpawnPoints )
	if ( #SpawnPoints < 1 ) then return table.Random( allspawnp ) end //If no spawnpoints, spawn at (0,0,0)
	
	return table.Random( SpawnPoints ) //Return random spawnpoint

end

function GM:EntityKeyValue( ent, key, value ) 

	if ( ent:GetClass() == "info_player_start" and key == "round" ) then
		ent:SetNWInt( "Round", value )//See GM:PlayerSelectTeamSpawn
	end
	
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	GAMEMODE:RoundEndWithResult( TEAM_GAMEMASTER, "time" )

end

//hook.Add( "OnRoundStart", "GM_OnRoundStart", GM_OnRoundStart )

function GM:ProcessResultText( result, resulttext )

	if ( resulttext == nil ) then resulttext = "" end
	
	if ( result == TEAM_GAMEMASTER ) then
		if ( resulttext == "time" ) then
			resulttext = "The Runners didn't get to the end in time!"
		else
			resulttext = "The Runners have been defeated!"
		end
	elseif ( result == TEAM_RUNNER ) then
		if ( resulttext == "finish" ) then
			resulttext = "The Runners made it to the end!"
		end
	end
	
	//the result could either be a number or a player!
	// for a free for all you could do... if type(result) == "Player" and ValidEntity( result ) then return result:Name().." is the winner" or whatever
	
	return resulttext

end

function GM:OnRoundResult( result, resulttext )

	// The fact that result might not be a team 
	// shouldn't matter when calling this..
	team.AddScore( result, 1 )
	
	if ( result != TEAM_RUNNER and result != TEAM_GAMEMASTER ) then return end
	
	for _, v in pairs( player.GetAll() ) do
	
		if ( v:Team() == TEAM_GAMEMASTER ) then
			if ( result == TEAM_GAMEMASTER ) then
				v:SendLua( "surface.PlaySound( 'gmaster/win.mp3' )" )
			elseif ( result == TEAM_RUNNER ) then
				v:SendLua( "surface.PlaySound( 'gmaster/lose.mp3' )" )
			end
		elseif ( v:Team() == TEAM_RUNNER ) then
			if ( result == TEAM_GAMEMASTER ) then
				v:SendLua( "surface.PlaySound( 'gmaster/lose.mp3' )" )
			elseif ( result == TEAM_RUNNER ) then
				v:SendLua( "surface.PlaySound( 'gmaster/win.mp3' )" )
			end
		end
		
	end

end

function GM:OnEndOfGame()

	for _, v in pairs( player.GetAll() ) do

		v:Freeze(true)
		v:ConCommand( "+showscores" )
		v:SendLua( "surface.PlaySound( 'gmaster/end.mp3' )" )
		
	end
	
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )
 
	local runnernum = #team.GetPlayers( TEAM_RUNNER ) or 1
	dmginfo:ScaleDamage( 1 / math.Max( runnernum / 2 + 1, 1 ) ) //Tough!
 
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
 
	dmginfo:ScaleDamage( 1 )
 
end