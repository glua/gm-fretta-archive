
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "tables.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_selectscreen.lua" )
AddCSLuaFile( "cl_postprocess.lua" )
AddCSLuaFile( "powerups.lua" )

include( "shared.lua" )
include( "ply_extension.lua" )
include( "tables.lua" )  
include( "powerups.lua" )  

resource.AddFile( "resource/fonts/Graffiare.ttf" )
resource.AddFile( "materials/jumpjet/splash001a.vmt" )
resource.AddFile( "materials/jumpjet/splash001b.vmt" )
resource.AddFile( "materials/jumpjet/splash002a.vmt" )
resource.AddFile( "materials/jumpjet/splash002b.vmt" )
resource.AddFile( "materials/jumpjet/powerup_plasma.vmt" )
resource.AddFile( "materials/jumpjet/powerup_stealth.vmt" )
resource.AddFile( "materials/jumpjet/powerup_blood.vmt" )
resource.AddFile( "materials/jumpjet/powerup_plasma.vtf" )
resource.AddFile( "materials/jumpjet/powerup_stealth.vtf" )
resource.AddFile( "materials/jumpjet/powerup_blood.vtf" )
resource.AddFile( "sound/jumpjet/blood01.wav" )
resource.AddFile( "sound/jumpjet/blood02.wav" )
resource.AddFile( "sound/jumpjet/blood03.wav" )

for i=1,5 do

	resource.AddFile( "sound/jumpjet/carnage0"..i..".wav" )
	resource.AddFile( "sound/jumpjet/die0"..i..".wav" )
	resource.AddFile( "sound/jumpjet/pain0"..i..".wav" )

end

function GM:SetupPlayerVisibility( ply, ent )

	AddOriginToPVS( ply:GetPos() + Vector( 700, 0, 0 ) )

end

function GM:GetFallDamage( ply, speed )
	
	return 0
	
end

function GM:PlayerDeathSound()

	return true 
	
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 1.50 ) 
    elseif hitgroup == HITGROUP_CHEST then
		dmginfo:ScaleDamage( 1.25 ) 
	elseif hitgroup == HITGROUP_STOMACH then
		dmginfo:ScaleDamage( 1.00 ) 
	else
		dmginfo:ScaleDamage( 0.50 )
	end
	
	if pl:GetArmorTime() > CurTime() then
		dmginfo:ScaleDamage( 0.10 )
	end
	
	return dmginfo

end 

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not ent:IsPlayer() then return end
	if not ent:Alive() then return end
	
	if ( string.find( attacker:GetClass(), "m79" ) or string.find( attacker:GetClass(), "rpg" ) ) and not dmginfo:IsExplosionDamage() then
	
		dmginfo:ScaleDamage( 0 )
		dmginfo:SetAttacker( attacker:GetOwner() )
		dmginfo:SetInflictor( attacker )
	
	end
	
	if string.find( attacker:GetClass(), "knife" ) and dmginfo:GetDamage() != 250 then
	
		dmginfo:ScaleDamage( 0 )
	
	end
	
	if ent:IsPlayer() and attacker:IsPlayer() then
	
		attacker:CallPowerupFunction( "DamageTaken", ent, dmginfo )
		
	end
	
end

function GM:Think()

	self.BaseClass:Think()
	
	if ( GAMEMODE.NextWave or 0 ) > CurTime() then return end
	
	GAMEMODE.NextWave = CurTime() + 8

end

function GM:PlayerDeathThink( pl )

	if pl:Team() != TEAM_RED and pl:Team() != TEAM_BLUE then return end

	// The gamemode is holding the player from respawning - they have to pick class or something
	if not pl:CanRespawn() then return end
	
	if not pl.DeathWait then
	
		pl.DeathWait = CurTime() + math.Clamp( GAMEMODE.NextWave - CurTime(), 3, 8 )
		
	end
	
	pl:SetNWFloat( "RespawnTime", pl.DeathWait )

	// Force respawn
	if pl.DeathWait < CurTime() then
	
		pl.DeathWait = nil
		pl:Spawn()
		
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:AddDeaths( 1 )
	
	if attacker:GetPowerupName() != "null" and ply != attacker then
	
		attacker:CallPowerupFunction( "Killed", ply, dmginfo )
		
	elseif dmginfo:IsExplosionDamage() then
	
		local ed = EffectData()
		ed:SetOrigin( ply:GetPos() + Vector(0,0,50) )
		util.Effect( "gore_explosion", ed, true, true )
	
	else
	
		ply:CreateRagdoll()
	
	end
	
end

function GM:ChangeObserverMode( pl, mode )

	if not pl:Alive() then return end

	if ( pl:GetInfoNum( "cl_spec_mode" ) != mode ) then
		pl:ConCommand( "cl_spec_mode "..mode )
	end

	if ( mode == OBS_MODE_IN_EYE || mode == OBS_MODE_CHASE ) then
		GAMEMODE:StartEntitySpectate( pl, mode )
	end
	
	pl:SpectateEntity( NULL )
	pl:Spectate( mode )

end

function ChoosePrimary( ply, cmd, args )

	local wep = tostring( args[1] )
	local class = tostring( args[2] )
	
	class = player_class.Get( class )
	
	if not class then return end
	if not table.HasValue( class.Primaries, wep ) then return end

	ply:SetPrimary( wep )
	
end
concommand.Add( "changeprimary", ChoosePrimary )

function ChooseSecondary( ply, cmd, args )

	local wep = tostring( args[1] )
	local class = tostring( args[2] )

	class = player_class.Get( class )
	
	if not class then return end
	if not table.HasValue( class.Secondaries, wep ) then return end

	ply:SetSecondary( wep )
	
end
concommand.Add( "changesecondary", ChooseSecondary )

function IncludePowerups()

	local Folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.FindInLua( Folder.."/gamemode/powerups/*.lua" ) ) do
	
		include( Folder.."/gamemode/powerups/"..d )
		AddCSLuaFile( Folder.."/gamemode/powerups/"..d )
		
	end

end

IncludePowerups()
