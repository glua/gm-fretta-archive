
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "admin.lua" )
AddCSLuaFile( "cl_postprocess.lua" )

include( "shared.lua" )
include( "admin.lua" )
include("tables.lua")
include( "ply_extension.lua" )

function GM:RoundEnd( ply )
	timer.Stop("CrateSpawner");
	self.BaseClass:RoundEnd()
	
	if not ply then 
		if team.NumPlayers(TEAM_ALIVE) > 0 then
			ply = table.Random( team.GetPlayers(TEAM_ALIVE) )
		else
			ply = table.Random( team.GetPlayers(TEAM_DEAD) )
		end
		
		if not ply then return end
	end
	
	ply:AddFrags(1)
	ply:StripWeapons()
	
	local maxscore = GetConVar("kb_maxscore"):GetInt()
	
	for k,v in pairs(player.GetAll()) do 
		
		if v:Team() == TEAM_DEAD then
			v:UnSpectate()
			v:SetTeam( TEAM_ALIVE )
		end
	
		if v != ply then
			v:SendLua("surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )") 
		else
			v:SendLua("surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )") 
		end
		if ply:GetScore() == maxscore - 1 then
			v:ChatPrint(ply:Name().." only needs to win one more game!")
		elseif ply:GetScore() >= maxscore then
			v:ChatPrint(ply:Name().." won the game!")
		else 
			v:ChatPrint(ply:Name().." won the round!")
		end
	end

	if ply:Frags() >= maxscore then
		timer.Simple( 5, function() GAMEMODE:EndOfGame(true) end )
	end
	
	
	
end

function GM:PlayerDeathSound()
	return true // disable the BEEP BEEP sound
end

/*function GM:PlayerDisconnected( ply )
	if team.NumPlayers(TEAM_ALIVE) < 2 then
		//GAMEMODE:PickNewPlayer()
	end
end*/

//Spawn a crate, durr :D
function SpawnCrate()
	local maxCrates = GetConVar("kb_maxcrates"):GetInt()
	local numberOfCrates = ents.FindByClass("stuffcrate");
	
	local thespawn = table.Random(ents.FindByClass("info_cratespawn"))
	spawnpos = thespawn:GetPos()
	local crate = ents.Create("stuffcrate")
	crate:SetPos(spawnpos)
	crate:Spawn()
	crate:EmitSound("Weapon_MegaPhysCannon.Launch")
	
	local expEffect = EffectData()
	expEffect:SetStart(spawnpos)
	expEffect:SetOrigin(spawnpos)
	expEffect:SetScale(3)
	util.Effect("ManhackSparks", expEffect)
	Msg("I spawned a crate!\n")
	
	if table.Count(numberOfCrates) >= maxCrates then
		table.Random(numberOfCrates):Remove()
	end
end

function GM:Think()

	self.BaseClass:Think()
	
	if team.NumPlayers(TEAM_ALIVE) == 1 and team.NumPlayers(TEAM_DEAD) > 0 and GAMEMODE:InRound() then
		local ply = team.GetPlayers(TEAM_ALIVE)[1]
		GAMEMODE:RoundEnd(ply)
	elseif team.NumPlayers(TEAM_ALIVE) == 0 and team.NumPlayers(TEAM_DEAD) > 0 and GAMEMODE:InRound() then
		GAMEMODE:RoundEnd()
	end
	
end

function GM:GetFallDamage( ply, flFallSpeed )
	return 0
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	if not ent:IsPlayer() then return end
	if inflictor:GetClass() == "trigger_hurt" then
		local expEffect = EffectData()
		expEffect:SetStart(ent:GetPos())
		expEffect:SetOrigin(ent:GetPos())
		expEffect:SetScale(5)
		util.Effect("HelicopterMegaBomb", expEffect)
		ent:Kill()
		return
	end
	
	local newamount = amount * 0.052
	ent:SetHealth(ent:Health() + newamount)
	dmginfo:SetDamage(0)
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:CreateRagdoll()
	ply:AddDeaths(1)
	ply:Flashlight(false)
	ply:SetTeam(TEAM_DEAD)
	
end

//Removes all the props
function GM:RoundStart()
	self.BaseClass:RoundStart()
	
	local cratespawntime = GetConVar("kb_cratespawntime"):GetInt()

	if (timer.IsTimer("CrateSpawner")) then
		timer.Start("CrateSpawner")
	else
		timer.Create("CrateSpawner", cratespawntime, 0, SpawnCrate)
	end

	for k, v in pairs(ents.FindByClass("prop_physics")) do
		v:Remove()
	end
	
end


