
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "admin.lua" )
AddCSLuaFile( "cl_postprocess.lua" )
AddCSLuaFile( "cl_notice.lua" )
AddCSLuaFile( "cl_splashscreen.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_endgamesplash.lua" )

include( "shared.lua" )
include( "admin.lua" )
include( "tables.lua" )
include( "ply_extension.lua" )
include( "waves.lua" )
include( "anims.lua" )
include( "enums.lua" )

resource.AddFile("materials/blood/Blood1.vmt")
resource.AddFile("materials/blood/Blood2.vmt")
resource.AddFile("materials/blood/Blood3.vmt")
resource.AddFile("materials/blood/Blood4.vmt")
resource.AddFile("materials/blood/Blood5.vmt")
resource.AddFile("materials/blood/Blood6.vmt")
resource.AddFile("materials/blood/Blood7.vmt")
resource.AddFile("materials/blood/Blood8.vmt")

resource.AddFile("resource/fonts/typenoksidi.ttf")
resource.AddFile("resource/fonts/28 days later.ttf")

// In case they aren't using svn
resource.AddFile("models/Zed/weapons/v_undead.vvd")
resource.AddFile("models/Zed/weapons/v_undead.mdl")
resource.AddFile("models/Zed/weapons/v_undead.sw.vtx")
resource.AddFile("models/Zed/weapons/v_undead.dx80.vtx")
resource.AddFile("models/Zed/weapons/v_undead.dx90.vtx")
resource.AddFile("models/Zed/weapons/v_wretch.vvd")
resource.AddFile("models/Zed/weapons/v_wretch.mdl")
resource.AddFile("models/Zed/weapons/v_wretch.sw.vtx")
resource.AddFile("models/Zed/weapons/v_wretch.dx80.vtx")
resource.AddFile("models/Zed/weapons/v_wretch.dx90.vtx")
resource.AddFile("models/Zed/weapons/v_banshee.vvd")
resource.AddFile("models/Zed/weapons/v_banshee.mdl")
resource.AddFile("models/Zed/weapons/v_banshee.sw.vtx")
resource.AddFile("models/Zed/weapons/v_banshee.dx80.vtx")
resource.AddFile("models/Zed/weapons/v_banshee.dx90.vtx")
resource.AddFile("models/Zed/weapons/v_disease.vvd")
resource.AddFile("models/Zed/weapons/v_disease.mdl")
resource.AddFile("models/Zed/weapons/v_disease.sw.vtx")
resource.AddFile("models/Zed/weapons/v_disease.dx80.vtx")
resource.AddFile("models/Zed/weapons/v_disease.dx90.vtx")
resource.AddFile("models/Zed/weapons/v_ghoul.vvd")
resource.AddFile("models/Zed/weapons/v_ghoul.mdl")
resource.AddFile("models/Zed/weapons/v_ghoul.sw.vtx")
resource.AddFile("models/Zed/weapons/v_ghoul.dx80.vtx")
resource.AddFile("models/Zed/weapons/v_ghoul.dx90.vtx")

GM.ZombiePlayers = {}

function GM:OnPreRoundStart( num )
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()

end

function GM:OnRoundResult( t )

	for k,v in pairs( player.GetAll() ) do 
	
		v:GodEnable()
		//v:SendLua( "GAMEMODE:ShowEndGameSplash( "..t.." )" )
	
		if v:Team() != t then
			v:SendLua( "surface.PlaySound( \"" .. table.Random( GAMEMODE.LoseMusic ) .. "\" )" ) 
			if v:Team() == TEAM_DEAD then
				v:Notice( "The humans have survived", 10, 255, 255, 255 )
			else
				v:Notice( "The survivors have died", 10, 255, 255, 255 )
			end
		else
			if v:Team() == TEAM_DEAD then
				v:SendLua( "surface.PlaySound( \"" .. table.Random( GAMEMODE.LoseMusic ) .. "\" )" ) 
				v:Notice( "The survivors have died", 10, 255, 255, 255 )
			else
				v:SendLua( "surface.PlaySound( \"" .. table.Random( GAMEMODE.WinMusic ) .. "\" )" ) 
				v:Notice( "The humans have survived", 10, 255, 255, 255 )
			end
		end
	end

	timer.Simple( 35, function() GAMEMODE:EndOfGame(true) end )

end

function GM:CheckRoundEnd()

	if GAMEMODE:AlivePlayers() < 1 and team.NumPlayers( TEAM_DEAD ) > 0 then
		GAMEMODE:RoundEndWithResult( TEAM_DEAD )
	end

end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	if GAMEMODE:AlivePlayers() > 0 then
		GAMEMODE:RoundEndWithResult( TEAM_ALIVE )
	else
		GAMEMODE:RoundEndWithResult( TEAM_DEAD )
	end

end

function GM:AlivePlayers()

	for k,v in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
		if v:Alive() or not v.m_bJoinSpawn then
			return 1
		end
	end
	return 0

end

function GM:PlayerInitialSpawn( ply )

	self.BaseClass:PlayerInitialSpawn( ply )
	
	ply:SetCustomAmmo( "Pistol", 250 )
	ply:SetCustomAmmo( "SMG", 100 )
	ply:SetCustomAmmo( "Buckshot", 0 )
	ply:SetCustomAmmo( "Rifle", 0 )
	
end

function GM:PlayerSpawn( ply )

	self.BaseClass:PlayerSpawn( ply )
	
	if not ply.m_bJoinSpawn then
		ply.m_bJoinSpawn = true
	end
	
	if ply:Team() == TEAM_DEAD and ValidEntity( ply:GetActiveWeapon() ) and not string.find( ply:GetActiveWeapon():GetClass(), "claw" ) then
	
		ply:SetRandomClass()
		ply:Kill()
		return
	
	end
	
	if ply.m_bRedeemed then
	
		ply.m_bRedeemed = false
		
		ply:EmitSound( GAMEMODE.ResSound, 100, 120 )
		ply:Notice( "You have been resurrected", 8, 50, 255, 50 )
		
	end
	
	if ply:Team() == TEAM_ALIVE and ( table.HasValue( GAMEMODE.ZombiePlayers, ply:UniqueID() ) or GAMEMODE:NoPlayerZombie() ) then
	
		ply:SetTeam( TEAM_DEAD )
		ply:SetPlayerClass( "Ghoul" )
	
		if GAMEMODE:NoPlayerZombie() then
		
			ply:Notice( "You have been chosen to be the zombie leader", 5, 255, 50, 0 )
			ply:Notice( "Kill 2 humans and you will be redeemed", 8, 0, 100, 255 )
			ply:Notice( "Press F1 to change your class", 8, 0, 100, 255 )
			ply:SendLua( "surface.PlaySound( \"" .. table.Random( GAMEMODE.AmbientScream ) .. "\" )" )
			ply:SetFirstZombie( true )
			ply:SetBrains( 0 )
			ply:SetPlayerClass( "Soldier" )
			
		end
		
		ply:Spawn()
		
	end
end

function GM:InitPostEntity()

	self.BaseClass:InitPostEntity()
	
	for k,v in pairs( GAMEMODE:GetZombieSpawns() ) do
	
		local canspawn = true
	
		for c,d in pairs( ents.FindByClass( "sent_radiation" ) ) do
			if d:GetPos():Distance( v:GetPos() ) < 500 then
				canspawn = false
			end
		end
		
		if canspawn then
			local rad = ents.Create( "sent_radiation" )
			rad:SetPos( v:GetPos() )
			rad:Spawn()
		end	
	end
end

function GM:Think()

	self.BaseClass:Think()
	GAMEMODE:WaveThink()
	
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )

	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 3.00 ) 
    elseif hitgroup == HITGROUP_CHEST then
		dmginfo:ScaleDamage( 1.50 ) 
	elseif hitgroup == HITGROUP_STOMACH then
		dmginfo:ScaleDamage( 1.00 ) 
	else
		dmginfo:ScaleDamage( 0.25 )
	end
	
	return dmginfo

end 

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if ply:Team() == TEAM_ALIVE then return dmginfo end

	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 1.50 ) 
    elseif hitgroup == HITGROUP_CHEST then
		dmginfo:ScaleDamage( 1.25 ) 
	elseif hitgroup == HITGROUP_STOMACH then
		dmginfo:ScaleDamage( 1.00 ) 
	else
		dmginfo:ScaleDamage( 0.25 )
	end
	
	return dmginfo

end 

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not ent:IsPlayer() then return end
	if not ent:Alive() then return end
	
	if ent:Team() == TEAM_ALIVE then
	
		ent:AddDmgTaken( dmginfo:GetDamage() )
		
		if attacker:IsPlayer() and attacker:Team() == TEAM_DEAD then
		
			attacker:AddBrains( dmginfo:GetDamage() )
		
		end
		
	end
	
	if string.find( attacker:GetClass(), "frag" ) then
	
		dmginfo:SetAttacker( attacker:GetOwner() )
		dmginfo:SetInflictor( attacker )
		
	end
	
	if string.find( attacker:GetClass(), "prop_phys" ) then
	
		if not attacker:GetPhysicsAttacker() or not attacker:GetPhysicsAttacker():IsValid() then
		
			dmginfo:SetDamage( 0 ) 
			
		end
		
	end
	
end

function GM:PlayerDeathSound()
	return true // disable the BEEP BEEP sound
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
	ply:Flashlight( false )
	
	// Undead player dies
	if ply:Team() == TEAM_DEAD then 
		if attacker and attacker:IsValid() and attacker:IsPlayer() and attacker != ply then
			attacker:AddBones(1)
		end
		return 
	end
	
	// Human player dies, give zombie points
	if attacker and attacker:IsValid() and attacker:IsPlayer() and attacker != ply and attacker:Team() == TEAM_DEAD then
		attacker:AddBrains( 50 )
		if attacker:IsFirstZombie() and attacker:Brains() >= 2 then
			attacker:Redeem()
		end
	end
	
	ply:DropItem()
	
	if not ply:IsFirstZombie() then
		GAMEMODE:AddToDeadList( ply )
	end
	
	if team.NumPlayers( TEAM_ALIVE ) > 0 and not ply:IsFirstZombie() then
		ply:SendLua("surface.PlaySound( \"" .. table.Random( GAMEMODE.DeathMusic ) .. "\" )") 
	end
	
end

function GM:GetFallDamage( ply, flFallSpeed )
	
	if ply:Team() == TEAM_DEAD then
		return 0
	end
	
	return flFallSpeed / 10
	
end

function GM:NoPlayerZombie()

	if team.NumPlayers( TEAM_ALIVE ) >= 8 and team.NumPlayers( TEAM_DEAD ) < 1 then
		return true
	end	
	
	return false

end

function GM:AddToDeadList( ply )

	table.insert( GAMEMODE.ZombiePlayers, ply:UniqueID() )

end

