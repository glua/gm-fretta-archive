INC = { }

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_deathnotice.lua" )
AddCSLuaFile( "maps.lua" )
AddCSLuaFile( "vgui/progressbar.lua" )
resource.AddFile( "content/sound/sam/music/smw_lvl2_loop1.mp3" )

include( "shared.lua" )
include( "maps.lua" )

function GM:AlivePlayers( t )

	local tbl = {}

	for k,v in pairs( team.GetPlayers( t ) ) do
		if v:Alive() then
			table.insert( tbl, v )
		end
	end
	
	return tbl

end

function GM:CanStartRound( num )
     if team.NumPlayers( TEAM_UNASSIGNED ) > 0 then
          return true
     else
          return false
     end
end

function GM:CheckRoundEnd()

	// Do checks here!
	if ( !GAMEMODE:InRound() ) then return end

	if ( #GAMEMODE:AlivePlayers( TEAM_UNASSIGNED ) == 0 ) then
	
		GAMEMODE:RoundEndWithResult( -1, "Everyone died!" )
	
	end

end			
 
function GM:OnRoundWinner( ply, resulttext )

	ply:AddFrags( 1 )

end

function GM:OnPreRoundStart( num )

	game.CleanUpMap()
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()

	self:Spawn3D2DScoreboards()

end

function GM:OnRoundStart( num, ply )

	UTIL_UnFreezeAllPlayers()
	
end

// Called when the round ends
function GM:OnRoundEnd( num )
	
	for _, v2 in pairs( ents.FindByClass( "prop_physics" ) ) do
		v2:Remove()
	end
 
end
 
//
// This is called when the round time ends.
//
function GM:RoundTimerEnd()
 
	if ( !GAMEMODE:InRound() ) then return end

	GAMEMODE:RoundEndWithResult( -1, "Time Up" )
 
end

-----------------------------------------------------
--Original Code Begins
-----------------------------------------------------
INC.PropSpawnTimer = 0
local Delay = INC.Maps[ game.GetMap() ].PropSpawnDelay
local Props = INC.Maps[ game.GetMap() ].FallingProps
hook.Add("Tick", "TickPropSpawn", function()
	if ( #player.GetAll() >= 1 ) then
		if ( INC.PropSpawnTimer < CurTime() ) then
			for k, v in pairs( ents.FindByClass( "inc_prop_spawner" ) ) do
				INC.PropSpawnTimer = CurTime() + Delay
				local Ent = ents.Create( "prop_physics" )
				Ent:SetModel( Props[ math.random( 1, #Props ) ] )
				Ent:SetPos( v:GetPos() )
				Ent:Spawn()
				Ent:GetPhysicsObject():SetMass( 40000 )
			end
		end
	end
end )

function GM:GetFallDamage( ply, flFallSpeed )

	return 0
	
end

local DeathSounds = 
{
	Sound( "vo/npc/male01/no02.wav" ),
	Sound( "vo/npc/Barney/ba_ohshit03.wav" ),
	Sound( "vo/npc/Barney/ba_ohshit03.wav" ),
	Sound( "vo/npc/Barney/ba_no01.wav" ),
	Sound( "vo/npc/Barney/ba_no02.wav" )
}

function GM:PlayerDeath( Victim, Inflictor, Attacker )
	Victim:EmitSound( DeathSounds[ math.random( 1, #DeathSounds ) ] )
	
	Victim.DeathDoll = ents.Create( "prop_ragdoll" )
	Victim.DeathDoll:SetModel( Victim:GetModel() )
	Victim.DeathDoll:SetPos( Victim:GetPos() + Vector( 0, 0, 1 ) )
	Victim.DeathDoll:SetAngles( Victim:GetAngles() )
	Victim.DeathDoll:Spawn()
	Victim:Spectate( OBS_MODE_CHASE )
	Victim:SpectateEntity( Victim.DeathDoll )
	
	for i = 0, Victim.DeathDoll:GetPhysicsObjectCount() do
		local bone = Victim.DeathDoll:GetPhysicsObjectNum( i )
		
		if ( ValidEntity( bone ) ) then
			bone:SetVelocity( Victim:GetVelocity() )
		end
	end

	umsg.Start( "PlayerKilled" )
		umsg.Entity( Victim )
	umsg.End()
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:AddDeaths( 1 )

end

function GM:PlayerDeathSound()
	return true
end

function GM:CanPlayerSuicide( ply )
	if ( !ply:Alive() ) then return false end
	
	return true
end

function IncludeResFolder( dir )

	local files = file.FindInLua( "incoming/content/" .. dir .. "*" )
	local FindFileTypes = 
	{
		".mdl",
		".vmt",
		".vtf",
		".dx90",
		".dx80",
		".phy",
		".sw",
		".vvd",
		".wav",
		".mp3",
		//".xbox"
	}
	
	for k, v in pairs( files ) do
		for k2, v2 in pairs( FindFileTypes ) do
			if ( string.find( v, v2 ) ) then
				resource.AddFile( dir .. v )
			end
		end
	end
end

IncludeResFolder( "materials/models/clannv/nvincoming/hud/" )
IncludeResFolder( "materials/models/clannv/incoming/" )

IncludeResFolder( "models/clannv/incoming/box/" )
IncludeResFolder( "models/clannv/incoming/cone/" )
IncludeResFolder( "models/clannv/incoming/cylinder/" )
IncludeResFolder( "models/clannv/incoming/hexagon/" )
IncludeResFolder( "models/clannv/incoming/pentagon/" )
IncludeResFolder( "models/clannv/incoming/sphere/" )
IncludeResFolder( "models/clannv/incoming/triangle/" )