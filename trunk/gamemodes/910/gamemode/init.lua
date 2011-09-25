
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_scores.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( 'cl_hud.lua' )
AddCSLuaFile( 'meta.lua' )

include( "shared.lua" )
include( "round_controller.lua" )
include( "tables.lua" )

function GM:Initialize()

	if ( GAMEMODE.GameLength > 0 ) then
		timer.Simple( GAMEMODE.GameLength * 60, function() GAMEMODE:EndOfGame( true ) end )
		SetGlobalFloat( "GameEndTime", CurTime() + GAMEMODE.GameLength * 60 )
	end
	
	// If we're round based, wait 5 seconds before the first round starts
	if ( GAMEMODE.RoundBased ) then
		timer.Simple( 10, function() GAMEMODE:StartRoundBasedGame() end )
	end
	
	if ( GAMEMODE.AutomaticTeamBalance ) then
		timer.Create( "CheckTeamBalance", 30, 0, function() GAMEMODE:CheckTeamBalance() end )
	end
	
	-- Make timers
	timer.Create( "SpawnProps", 2, 0, function() GAMEMODE:SpawnProps() end )
	--timer.Create( "SpawnProps2", 5, 0, function() GAMEMODE:SpawnProps() end )
	timer.Create( "CreateSpawns", 5, 0, function() GAMEMODE:CreateSpawns() end )
	
end

function GM:InitPostEntity()

	for k,v in pairs ( ents.FindByClass("prop_physics") ) do
		local pos = v:GetPos()
		pos = pos + Vector( 0, 0, 45 )
		
		local spawn = ents.Create( "info_prop" )
		spawn:SetPos( pos )
		
		v:Remove()
	end

end

-- The flatline is annoying
function GM:PlayerDeathSound()
	return true
end

-- Randomly spawn props
function GM:SpawnProps()

	-- No spawnpoints
	if #ents.FindByClass( "info_prop" ) <= 0 then
		--GAMEMODE:CreateSpawns()
		return
	end
	
	-- Find me a spawnpoint
	local spawn = GAMEMODE:LocateSpawn()
	
	-- Randomly spawn a prop, barrel, and big prop
	local chance = math.random( 1, 10 )
	local object = "prop_physics"
	--if chance == 4 then
	--	object = "item_item_crate"
	--end
	
	-- Spiffy effects
	local boosh = EffectData()
	boosh:SetOrigin( spawn:GetPos() )
	boosh:SetScale( 1 )
	util.Effect( "prop_spawn", boosh )
	
	-- Create it
	local prop = ents.Create( object )
	prop:SetPos( spawn:GetPos() )
	prop:SetModel( table.Random(GAMEMODE.PropModels) )
	if chance == 1 or chance == 2 then
		prop:SetModel( table.Random(GAMEMODE.LargeModels) )
	elseif chance == 3 then
		prop:SetModel( table.Random(GAMEMODE.ExplosiveModels) )
	--elseif chance == 4 then
	--	prop:SetKeyValue( "ItemClass", "item_healthvial" )
	--	prop:SetKeyValue( "ItemCount", math.random( 1, 5 ) )
	end
	prop:Spawn()
	
end

-- Finds a prop spawn point
function GM:LocateSpawn()

	-- Find a spawn that isn't blocked
	local spawn = table.Random( ents.FindByClass( "info_prop" ) )
	for k,v in pairs( ents.FindInSphere( spawn:GetPos(), 64 ) ) do
		local blockers = { "player", "info_base_blue", "info_base_yellow" }
		if table.HasValue( blockers, v:GetClass() ) then
			spawn = GAMEMODE:LocateSpawn()
		end
		
	end
	
	return spawn

end

function GM:CreateSpawns()

	local player = table.Random( player.GetAll() )
	
	local spawn = ents.Create( "info_prop" )
	spawn:SetPos( player:GetShootPos() )
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:CreateRagdoll()
	
	if ( GAMEMODE.EnableFreezeCam && IsValid( attacker ) && attacker != ply ) then
	
		ply:SpectateEntity( attacker )
		ply:Spectate( OBS_MODE_FREEZECAM )
		
	end
	
end

 -- Gravity Gun Trickery
function GM:GravGunPunt( ply, ent )

	ent:SetLastPunter( ply )
	return true

end

function GM:GravGunOnPickedUp( ply, ent )

	ent:SetLastGrabber( ply )
	return true -- Players can pick up pretty much anything

end
