
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" ) 
AddCSLuaFile( "cl_postprocess.lua" )
AddCSLuaFile( "cl_selectscreen.lua" )

include( "shared.lua" )
include( "ply_extension.lua" )
include( "tables.lua" )
include( "enums.lua" )

resource.AddFile( "materials/stalker/regen.vtf" )
resource.AddFile( "materials/stalker/regen.vmt" )
resource.AddFile( "materials/stalker/psycho.vtf" )
resource.AddFile( "materials/stalker/psycho.vmt" )
resource.AddFile( "materials/stalker/flay.vtf" )
resource.AddFile( "materials/stalker/flay.vmt" )
resource.AddFile( "materials/stalker/scream.vtf" )
resource.AddFile( "materials/stalker/scream.vmt" )
resource.AddFile( "materials/stalker/radar_back.vtf" )
resource.AddFile( "materials/stalker/radar.vmt" )
resource.AddFile( "materials/stalker/radar_arm.vtf" )
resource.AddFile( "materials/stalker/radar_arm.vmt" )
resource.AddFile( "materials/stalker/radar_fuzz.vtf" )
resource.AddFile( "materials/stalker/radar_fuzz.vmt" )
resource.AddFile( "materials/stalker/battery.vtf" )
resource.AddFile( "materials/stalker/battery.vmt" )
resource.AddFile( "materials/stalker/heart.vtf" )
resource.AddFile( "materials/stalker/heart.vmt" )
resource.AddFile( "materials/stalker/brain.vtf" )
resource.AddFile( "materials/stalker/brain.vmt" )

function GM:AlivePlayers( t )

	local num = 0

	for k,v in pairs( team.GetPlayers( t ) ) do
	
		if v:Alive() then
		
			num = num + 1
			
		end
		
	end
	
	return num

end

function GM:GetWinner( t )

	local frags = 9000
	local ply

	for k,v in pairs( team.GetPlayers( t ) ) do
	
		if v:IsWinner() then
		
			v:SetWinner( false )
			return v
			
		elseif v:Frags() < frags then
		
			frags = v:Frags()
			ply = v
			
		end
		
	end
	
	return ply

end

function GM:SetCommander()

	local score = 9999
	local ply

	for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
	
		v:SetCommander( false )
	
		if v:Frags() < score then
		
			score = v:Frags()
			ply = v
		
		elseif v:Frags() == score and math.random(1,3) == 1 then
		
			ply = v
		
		end
	
	end
	
	if ply then
	
		ply:SetCommander( true )
	
	end

end

function GM:ActivePlayers()

	local amt = team.NumPlayers( TEAM_STALKER )
	amt = amt + team.NumPlayers( TEAM_HUMAN ) 
	
	return amt

end

function GM:OnRoundStart()

	UTIL_UnFreezeAllPlayers()
	
	for k,v in pairs( team.GetPlayers( TEAM_STALKER ) ) do
	
		v:StripWeapons()
		v:SetTeam( TEAM_HUMAN )
		v:SetPlayerClass( v:GetLastClass() )
		v:Spawn()
		
	end
	
	if team.NumPlayers( TEAM_HUMAN ) > 1 then
	
		local randomguy = GAMEMODE:GetWinner( TEAM_HUMAN )
		randomguy:SetLastClass()
		randomguy:StripWeapons()
		randomguy:SetTeam( TEAM_STALKER )
		randomguy:Spawn()
		
	end
	
	GAMEMODE.PauseChecks = false
	
	if team.NumPlayers( TEAM_HUMAN ) < 1 then return end
	
	local pl = table.Random( team.GetPlayers( TEAM_HUMAN ) )
	
	if ValidEntity( pl ) then
		pl:SetRadioInfo( CurTime() + 1, RADIO_CALM )
	end

end

function GM:OnRoundResult( result, resulttext )
	
	GAMEMODE:SetCommander()
	
	GAMEMODE.PauseChecks = true

end

function GM:CheckRoundEnd()

	if ( !GAMEMODE:InRound() or GAMEMODE.PauseChecks ) then return end

	if ( GAMEMODE:AlivePlayers( TEAM_HUMAN ) < 1 and GAMEMODE:AlivePlayers( TEAM_STALKER ) > 0 and GAMEMODE:ActivePlayers() > 1 ) then
	
		GAMEMODE:RoundEndWithResult( TEAM_STALKER )
		
	elseif ( GAMEMODE:AlivePlayers( TEAM_STALKER ) < 1 and GAMEMODE:AlivePlayers( TEAM_HUMAN ) > 0 and GAMEMODE:ActivePlayers() > 1 ) then
	
		GAMEMODE:RoundEndWithResult( TEAM_HUMAN )
		
	elseif ( GAMEMODE:AlivePlayers( TEAM_HUMAN ) < 1 and GAMEMODE:ActivePlayers() > 0 ) then
	
		GAMEMODE:RoundEndWithResult( -1, "Starting new round..." )
		
	end

end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	GAMEMODE:RoundEndWithResult( -1, "The Stalker has failed..." )

end

function GM:OnRoundWinner( ply, resulttext )

end

function GM:PlayerSpawn( ply )
	
	self.BaseClass:PlayerSpawn( ply )
	
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if ply:Team() == TEAM_HUMAN then return dmginfo end

	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 1.25 ) 
    elseif hitgroup == HITGROUP_CHEST then
		dmginfo:ScaleDamage( 1.0 ) 
	elseif hitgroup == HITGROUP_STOMACH then
		dmginfo:ScaleDamage( 0.75 ) 
	else
		dmginfo:ScaleDamage( 0.25 )
	end
	
	return dmginfo

end 

function GM:GetFallDamage( ply, speed )

	if ply:Team() == TEAM_STALKER then return 0 end

	return speed / 10
	
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not GAMEMODE:InRound() then 
	
		dmginfo:ScaleDamage( 0 ) 
		return 
		
	end
	
	if not ent:IsPlayer() then return end
	
	if string.find( attacker:GetClass(), "prop" ) then
	
		if not ValidEntity( attacker:GetPhysicsAttacker() ) then
		
			dmginfo:ScaleDamage( 0 )
			
		end
		
	end
	
	if not attacker:IsPlayer() then return end
	
	if ent:Team() == TEAM_STALKER then
	
		if dmginfo:IsExplosionDamage() or dmginfo:GetAttacker():IsWorld() then 
		
			dmginfo:ScaleDamage( 0 )
			
		end
	
		if attacker:GetNWBool( "Tracker", false ) then
		
			if not attacker:GetNWBool( "IsTracking", false ) then
			
				attacker:SetNWBool( "IsTracking", true )
				attacker:SetRadioInfo( CurTime() + 1, RADIO_ENGAGING )
				attacker:EmitSound( "NPC_RollerMine.ExplodeChirp", 150, 150 )
			
			end
			
		end
		
		if dmginfo:GetDamage() < ent:Health() and ( ent.LastPain or 0 ) < CurTime() then
		
			ent:EmitSound( table.Random( GAMEMODE.StalkerPain ) )
			ent.LastPain = CurTime() + 3
			
		end
		
	elseif attacker:Team() == TEAM_STALKER then
	
		if dmginfo:GetDamage() < ent:Health() and ( ent.LastPain or 0 ) < CurTime() then
		
			ent:EmitSound( table.Random( GAMEMODE.SoldierPain ) )
			ent.LastPain = CurTime() + 0.5
			
		end
		
		if dmginfo:IsExplosionDamage() then return end
		
		local time = 1
		
		for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
		
			if v != ent and v:GetPos():Distance( ent:GetPos() ) < 500 then
			
				v:SetRadioInfo( CurTime() + time, RADIO_HURT )
				time = time + math.Rand(1,2)
				
			end
			
		end
		
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:AddDeaths( 1 )
	ply:CreateRagdoll()
	
	if ply:Team() == TEAM_STALKER and attacker:IsPlayer() then
	
		attacker:SetRadioInfo( CurTime() + 1, RADIO_WIN )
		attacker:AddFrags( 2 ) 
		attacker:SetWinner( true )
		
	elseif ply:Team() == TEAM_HUMAN and attacker:IsPlayer() then
	
		attacker:AddFrags( 1 ) 
		attacker:GainHealth()
		
	end
	
end

function GM:PlayerDeathSound()
	return true // disable the BEEP BEEP sound
end

function StalkerEsp( ply, cmd, args )

	if ply:Team() != TEAM_STALKER then return end
	ply:SetNWBool( "StalkerEsp", !ply:GetNWBool( "StalkerEsp", false ) )

end
concommand.Add( "ts_toggle_esp", StalkerEsp )

function ChooseUtil( ply, cmd, args )

	local wep = tostring( args[1] )
	local class = player_class.Get( "BaseSoldier" )
	
	if not class then return end
	if not class.Utilities then return end
	if not table.HasValue( class.Utilities, wep ) then return end

	ply:SetUtility( wep )
	
end
concommand.Add( "changeutility", ChooseUtil )