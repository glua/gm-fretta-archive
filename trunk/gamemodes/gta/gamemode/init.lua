
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "tables.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_statscreen.lua" )
AddCSLuaFile( "cl_postprocess.lua" )

include( "shared.lua" )
include( "ply_extension.lua" )
include( "tables.lua" )
include( "enums.lua" )

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	local result, text = GAMEMODE:GetWinningTeam()
	
	GAMEMODE:RoundEndWithResult( result, text )

end

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	
	for k,v in pairs( player.GetAll() ) do
		
		v:SetCash( 0 )
		v:SetFrags( 0 )
		
		if v:Team() == TEAM_GANG then
			v:Notice( table.Random( GAMEMODE.GangStartNotices ), 5, 255, 255, 255 )
		elseif v:Team() == TEAM_POLICE then
			v:Notice( table.Random( GAMEMODE.CopStartNotices ), 5, 255, 255, 255 )
		end
		
	end

end

function GM:GetWinningTeam()

	local gang, cops = 0, 0

	for k,v in pairs( team.GetPlayers( TEAM_GANG ) ) do
		gang = gang + v:GetCash()
	end
	
	for k,v in pairs( team.GetPlayers( TEAM_POLICE ) ) do
		cops = cops + ( v:Frags() * 300 )
	end
	
	if gang > cops then
		return TEAM_GANG, "TIME UP"
	elseif cops > gang then
		return TEAM_POLICE, "TIME UP"
	end
	
	return -1, "NOBODY WINS"

end

function GM:PlayerSwitchFlashlight( ply, on ) 

	if ( ply:Team() == TEAM_SPECTATOR || ply:Team() == TEAM_UNASSIGNED || ply:Team() == TEAM_CONNECTING ) then
		return not on
	end

	if ValidEntity( ply:GetCar() ) then return not on end
	
	return true
	
end

function GM:Think()

	self.BaseClass:Think()
	GAMEMODE:CivilianThink()
	GAMEMODE:CarSpawnThink()
	
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )

	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 2.00 ) 
    elseif hitgroup == HITGROUP_CHEST then
		dmginfo:ScaleDamage( 1.50 ) 
	elseif hitgroup == HITGROUP_STOMACH then
		dmginfo:ScaleDamage( 1.25 ) 
	else
		dmginfo:ScaleDamage( 0.75 )
	end
	
	return dmginfo

end 

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if ply:Team() == TEAM_ALIVE then return dmginfo end

	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 1.75 ) 
    elseif hitgroup == HITGROUP_CHEST then
		dmginfo:ScaleDamage( 1.00 ) 
	elseif hitgroup == HITGROUP_STOMACH then
		dmginfo:ScaleDamage( 0.75 ) 
	else
		dmginfo:ScaleDamage( 0.50 )
	end
	
	return dmginfo

end 

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not ent:IsPlayer() then return end
	if not ent:Alive() then return end
	
	if not GAMEMODE:InRound() then 
		dmginfo:ScaleDamage( 0 ) 
	end
	
	if string.find( dmginfo:GetAttacker():GetClass(), "vehicle" ) and ValidEntity( dmginfo:GetAttacker():GetOwner() ) then
		dmginfo:SetAttacker( dmginfo:GetAttacker():GetOwner() )
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if dmginfo:IsExplosionDamage() then
		ply:SetModel( table.Random( GAMEMODE.Corpses ) )
	end
	
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
	
	if dmginfo:GetAttacker():IsPlayer() then
		dmginfo:GetAttacker():AddFrags( 1 )
		if ValidEntity( dmginfo:GetAttacker():GetCar() ) and dmginfo:GetAttacker() != ply then
			dmginfo:GetAttacker():Roadkill()
		end
	end

end

function GM:PlayerDeathSound()

	return true 
	
end

function GM:SellCar( car )

	if not ValidEntity( car ) then return end

	local fraction = car:GetVehicleHealth() / car.StartHealth
	local cash = math.Round( ( fraction * car:GetPrice() ) / 50 ) * 50
	
	local ply = car:GetOwner()
	
	if not ValidEntity( ply ) then car:Remove() return end
	
	ply:StripWeapons()
	ply:UnSpectate()
	ply:Spawn()
	ply:AddCash( cash )
	ply:SetCar()
	ply:Notice( table.Random( GAMEMODE.StealNotices ), 5, 0, 255, 0 )
	ply:EmitSound( table.Random( GAMEMODE.CashTake ) )
	
	car:SetVehicleHealth( 100 )
	car:Remove()

end

function GM:CarSpawnThink()

	if ( GAMEMODE.CarTimer or 0 ) > CurTime() then return end
	
	GAMEMODE.CarTimer = CurTime() + 10
	
	if #ents.FindByClass( "vehicle*" ) >= math.Max( #ents.FindByClass( "info_carspawn" ) / 2, #player.GetAll() ) then return end
	
	local num = math.Max( #ents.FindByClass( "info_carspawn" ) / 2, #player.GetAll() ) - #ents.FindByClass( "vehicle*" )
	
	for i=1, num do
	
		local pos, ang = GAMEMODE:GetCarSpawn()
	
		local car = ents.Create( table.Random( GAMEMODE.SpawnableVehicles ) )
		car:SetPos( pos )
		car:SetAngles( ang )
		car:Spawn()
	
	end

end

function GM:CivilianThink()

	if ( GAMEMODE.NpcTimer or 0 ) > CurTime() then return end
	
	GAMEMODE.NpcTimer = CurTime() + 5
	
	if #ents.FindByClass( "npc*" ) >= #player.GetAll() then return end
	
	local num = #player.GetAll() - #ents.FindByClass( "npc*" ) 
	
	for i=1, num do

		local civilian = ents.Create( table.Random{ "npc_civilian_male", "npc_civilian_female" } )
		civilian:SetPos( GAMEMODE:GetNode() )
		civilian:Spawn()
	
	end

end

function GM:GetCarSpawn()

	local canuse

	while !canuse do

		local spawn = table.Random( ents.FindByClass( "info_carspawn" ) )
		canuse = true
		
		for k,v in pairs( ents.FindByClass( "vehicle*" ) ) do
			
			if spawn:GetPos():Distance( v:GetPos() ) < 200 then
				canuse = false
			end
			
		end
			
		if canuse then
			return spawn:GetPos(), spawn:GetSpawnAngles()
		end
		
	end

end

function GM:GetNode()

	for i=1, 20 do
	
		local pos = table.Random( GAMEMODE:GetSpawnPositions() )
		local usable = true
	
		for k,v in pairs( player.GetAll() ) do
			if v:GetPos():Distance( pos ) < 1000 then
				usable = false
			end
		end
	
		if usable then
			return pos
		end
	
	end
	
	return table.Random( ents.FindByClass( "info_player_counterterrorist" ) ):GetPos()

end

function GM:AddSpawnPosition( pos )

	if not GAMEMODE.SpawnSpots then
		GAMEMODE.SpawnSpots = { pos }
		return
	end

	if not table.HasValue( GAMEMODE.SpawnSpots, pos ) then
		table.insert( GAMEMODE.SpawnSpots, pos )
	end
	
end

function GM:GetSpawnPositions()

	if not GAMEMODE.SpawnSpots then
		GAMEMODE.SpawnSpots = { table.Random( ents.FindByClass( "info_player_counterterrorist" ) ):GetPos() }
	end
	
	return GAMEMODE.SpawnSpots

end