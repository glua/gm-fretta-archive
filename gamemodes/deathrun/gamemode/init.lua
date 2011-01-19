AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )
include( "laserfix.lua" )
include( "mapmods.lua" )

GM.MaxRounds = CreateConVar( "dr_maxrounds", "10", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )
GM.deathsRatio = CreateConVar( "dr_deaths_ratio", "0.15", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )

function GM:GetFallDamage( ply, speed )
	return speed / 8
end

function GM:CanPlayerSuicide ( ply )   
	if ply:Team() == TEAM_DEATH then
		ply:SendToChat( "Suicide is disabled as a Death." )
		return false
	else
		return true
	end
end


function GM:OnPreRoundStart( num )

	self:InitPostEntity()

	for k,v in pairs(player.GetAll()) do
		if v:Team() != TEAM_SPECTATOR and v:Team() != TEAM_UNASSIGNED then
			if v.NextTeam then
				v:SetTeam(v.NextTeam)
			end
		end
	end

	local EvenRatio = math.Round(team.NumPlayers( TEAM_RUNNER )*GetConVar("dr_deaths_ratio"):GetFloat())

	if EvenRatio < 1 then
		EvenRatio = 1
	end
	
	local numdeathspawns = #team.GetSpawnPoints( TEAM_DEATH )
	
	if EvenRatio > numdeathspawns then
		EvenRatio = numdeathspawns
	end
	
	if team.NumPlayers( TEAM_DEATH ) < numdeathspawns then
		//print("(OK)There are " ..numdeathspawns.. " total.")
	else
		print("(ERROR) There aren't enough death spawns! " ..numdeathspawns.. " total.")
	end
	
	if team.NumPlayers( TEAM_RUNNER ) > 1 and team.NumPlayers( TEAM_DEATH ) <= EvenRatio-team.NumPlayers( TEAM_DEATH ) and team.NumPlayers( TEAM_DEATH ) < numdeathspawns then --Need a hidden? Make someone it.
		for i=1,EvenRatio-team.NumPlayers( TEAM_DEATH ) do
			local randomguy = table.Random( team.GetPlayers( TEAM_RUNNER ) )
			randomguy:SetTeam( TEAM_DEATH )
		end
	end
	
	// Testing
	for k,v in pairs(self.RestartRemoves) do
		for k2,v2 in pairs(ents.FindByClass(v)) do
			v2:Remove()
		end
	end

	timer.Create("GM:NearSpawn", 30, 1, self.NearSpawn, self)
	
	self.BaseClass:OnPreRoundStart()
	
	self:RemoveMapStuff()
	self:RemoveAllWeapons()
	self:SpawnWeapons()
	self:SpawnTouchEvents()
	self:CorrectLasers()
	//self:Spawn3D2DScoreboards()
	
end

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	timer.Remove("GM:NearSpawn")
/*	self:RemoveMapStuff()
	self:RemoveAllWeapons()
	self:SpawnWeapons()
	self:SpawnTouchEvents()
	self:CorrectLasers()
	self:Spawn3D2DScoreboards()*/
end

function GM:RoundEnd()
	self.BaseClass:RoundEnd()
end

function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
end 

function GM:NearSpawn()
	for k,v in pairs(team.GetPlayers(TEAM_RUN)) do
		if(v:IsNearSpawn()) then
			if(!self:IsMoving(v)) then
				v:Kill()
			end
		end
	end
end

function GM:IsMoving(ply)
	if(ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT)) then
		return true
	end
	return false
end

function GM:PlayerSpawn( ply )
	self.BaseClass:PlayerSpawn( ply )
end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	self.BaseClass:OnPlayerChangedTeam( ply, oldteam, newteam )

end

function GM:Resetdeaths( )
	for k, v in pairs( team.GetPlayers( TEAM_DEATH ) ) do
		v.NextTeam = TEAM_RUNNER
	end
end

function GM:OnRoundResult( t )

	self:Resetdeaths()

	if t == TEAM_DEATH then
		team.AddScore( TEAM_DEATH, 1 )
		for k, v in pairs( team.GetPlayers( TEAM_DEATH ) ) do
			if v:Alive() then
				v:GiveWin()
			end
		end
	elseif t== TEAM_RUNNER then
		team.AddScore( TEAM_RUNNER, 1 )
	end

	local maxrounds = GetConVar("dr_maxrounds"):GetInt()
	
	if GetGlobalInt( "RoundNumber" ) >= maxrounds then
		timer.Simple( 5, function() GAMEMODE:EndOfGame( true ) end )
	end
end

function GM:PlayerUse( ply, entity )
	if ply:Alive() and ( ply:Team() == TEAM_DEATH or ply:Team() == TEAM_RUNNER )then
		return true
	else
		return false
	end
end

function GM:PlayerDeath(ply, inflictor, attacker)

	self.BaseClass:PlayerDeath(ply, inflictor, attacker)
	
/*	timer.Simple(2, function()
		if ply and attacker and ply:IsValid() and attacker:IsValid() and ply:IsPlayer() and attacker:IsPlayer() and ply != attacker then
			ply:ConCommand("play misc/freeze_cam.wav")
			ply:SpectateEntity(attacker)
			ply:Spectate(OBS_MODE_FREEZECAM)
		end
	end)*/
	
/*	for k, v in pairs(ply:GetWeapons()) do  
		local newweap = ents.Create(v:GetClass())  
		newweap:SetPos(ply:GetPos() + ply:GetUp()*45)  
		newweap:Spawn()
		newweap:SetOwner()
		local phys = newweap:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetVelocity(ply:GetVelocity()) --Make it fly forward with the player
		end
	end*/
	
	if ply:Team() == TEAM_DEATH then
		ply:EmitSound("npc/stalker/breathing3.wav", 100, 100)

		if attacker:GetClass() != "worldspawn" then
			attacker.NextTeam = TEAM_DEATH
			ply.NextTeam = TEAM_RUNNER
		else
			ply.NextTeam = TEAM_RUNNER --Fuckin moron killed himself, how? no idea..
		end
		
	elseif ply:Team() == TEAM_RUNNER then
		ply:EmitSound("player/death"..math.random(1,6)..".wav", 100, 100)
	end
end

function GM:PlayerDeathSound()
	return true
end

local MapLua = "maps/"..game.GetMap()..".lua"
if(file.Exists("../"..GM.Folder.."/gamemode/"..MapLua)) then
	include(MapLua)
	print("Including "..MapLua)
end

concommand.Add( "ss_printweapons", function( ply )
	print(table.ToString( GAMEMODE.Weapons, "Weapons", true ))
end )

concommand.Add( "ss_printremoveweapons", function( ply )
	print(table.ToString( GAMEMODE.RemoveWeapons, "RemoveWeapons", true ))
end )

concommand.Add( "ss_printtouchevents", function( ply )
	print(table.ToString( GAMEMODE.TouchEvents, "TouchEvents", true ))
end )

concommand.Add( "ss_printrestartremoves", function( ply )
	print(table.ToString( GAMEMODE.RestartRemoves, "RestartRemoves", true ))
end )