AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )

include( "shared.lua" )
include( "propreg.lua" )
include( "props.lua" )
include( "propdamage.lua" )
include( "powerups.lua" )
include( "powerupreg.lua" )

function GM:OnRoundEnd( num )
	
	propreg:DeleteAllEnts()
	powerup:DeleteAll()
	
end

function CleanupTeams()

	for k,v in pairs( team.GetAllTeams() ) do
	
		team.SetScore( k, 0 )
		
	end

end
hook.Add( "OnRoundStart", "CleanupTeams", CleanupTeams )

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	GAMEMODE:RoundEndWithResult( -1, "Time Up" )
	
end

function GM:CheckRoundEnd()
 
	if ( !GAMEMODE:InRound() ) then return end 
 
	for k,v in pairs( team.GetAllTeams() ) do
	
		if( v.Score >= 5*#player.GetAll() ) then return true end
	
	end
 
end

function GM:PlayerSetModel(ply)
	local cl_playermodel = ply:GetInfo( "cl_playermodel" )
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	util.PrecacheModel( modelname )
	ply:SetModel(modelname)
end

function WeaponSetup( ply )

	ply:Give( "weapon_physcannon" )
	
	return true
	
end
hook.Add( "PlayerLoadout", "mainLoadout", WeaponSetup )

function SpawnProp( ply, propid )
	if( propreg.propcount >= propreg.MAX_PROPS ) then return end
	propid = propid or propreg:GetRandomProp()

	if( GAMEMODE:InRound() && (ply:Team() == TEAM_RED || ply:Team() == TEAM_BLUE || ply:Team() == TEAM_GREEN) ) then
	print( "SpawnProp( " .. ply:GetName() .. " )" )
	
	--local propid = propreg:GetRandomProp()
	
	local trace = {}
	trace.start = ply:GetShootPos()
	local yaw = ply:EyeAngles().y + math.random(-45,45)
	trace.endpos = ply:GetShootPos() + (Angle(20, yaw, 0):Forward() * 400)
	trace.filter = ply
	
	local ent = propreg:CreateProp( propid, Vector(0,0,0), Angle(0,0,0) )
	
	local tr = util.TraceLine( trace )
	--sandbox--
	local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )
		vFlushPoint = ent:NearestPoint( vFlushPoint )
		vFlushPoint = ent:GetPos() - vFlushPoint
		vFlushPoint = tr.HitPos + vFlushPoint	
	--end sandbox--
	
	--sandbox--
	local ang = ply:EyeAngles()
	ang.yaw = ang.yaw + 180
	ang.roll = 0
	ang.pitch = 0
	--end sandbox--
	
	ent:SetPos( vFlushPoint )
	ent:SetAngles( ang )
	
	local phys = ent:GetPhysicsObject()
		phys:EnableMotion(false)
	ent:SetNotSolid(true)
	ent:SetMaterial("models/wireframe")
	
	timer.Simple(3, function()
		local phys = ent:GetPhysicsObject()
			phys:EnableMotion(true)
		ent:SetNotSolid(false)
		ent:SetMaterial()
		phys:Wake()
	end)
	
	end

end

function SpawnPowerup( ply )

	if( GAMEMODE:InRound() && (ply:Team() == TEAM_RED || ply:Team() == TEAM_BLUE || ply:Team() == TEAM_GREEN) && #ents.FindByClass( "pdo_powerup" ) < #player.GetAll() ) then
	print( "SpawnPowerup( " .. ply:GetName() .. " )" )
	
	local propid = powerup:GetRandom()
	
	local trace = {}
	trace.start = ply:GetShootPos()
	local yaw = ply:EyeAngles().y + math.random(-45,45)
	trace.endpos = ply:GetShootPos() + (Angle(20, yaw, 0):Forward() * 400)
	trace.filter = ply
	
	local ent = powerup:Create( propid, Vector(0,0,0), Angle(0,0,0) )
	
	local tr = util.TraceLine( trace )
	--sandbox--
	local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )
		vFlushPoint = ent:NearestPoint( vFlushPoint )
		vFlushPoint = ent:GetPos() - vFlushPoint
		vFlushPoint = tr.HitPos + vFlushPoint	
	--end sandbox--
	
	--sandbox--
	local ang = ply:EyeAngles()
	ang.yaw = ang.yaw + 180
	ang.roll = 0
	ang.pitch = 0
	--end sandbox--
	
	ent:SetPos( vFlushPoint )
	ent:SetAngles( ang )
	
	local effd = EffectData()
	effd:SetStart( vFlushPoint )
	effd:SetOrigin( vFlushPoint )
	effd:SetScale( 1 )
	
	util.Effect( "TeslaZap", effd )
	
	timer.Simple( 20, function() if( ent != NULL ) then ent:Remove() end end )
	
	end

end

function InitTimer( ply )

	print( "InitTimer()" )
	
	if( timer.IsTimer( "PSpawn_" .. ply:UniqueID() ) ) then timer.Destroy( "PSpawn_" .. ply:UniqueID() ) end
	
	timer.Create( "PSpawn_" .. ply:UniqueID(), math.random( 15, 30 ), 0, SpawnProp, ply )
	
	if( timer.IsTimer( "Powerup_" .. ply:UniqueID() ) ) then timer.Destroy( "Powerup_" .. ply:UniqueID() ) end
	
	timer.Create( "Powerup_" .. ply:UniqueID(), math.random( 20, 60 ), 0, SpawnPowerup, ply )
	
	SpawnProp( ply )
	
end
hook.Add( "PlayerSpawn", "StartTimer", InitTimer )

function StopTimer( ply )

	print( "StopTimer()" )
	if( timer.IsTimer( "PSpawn_" .. ply:UniqueID() ) ) then timer.Destroy( "PSpawn_" .. ply:UniqueID() ) end
	if( timer.IsTimer( "Powerup_" .. ply:UniqueID() ) ) then timer.Destroy( "Powerup_" .. ply:UniqueID() ) end

end
hook.Add( "PlayerDeath", "StopTimer", StopTimer )

function WeaponStop( ply, wep )
	
	if( wep:GetClass() == "weapon_physcannon" ) then return true end
	return false
		
end
hook.Add( "PlayerCanPickupWeapon", "StopWeps", WeaponStop )