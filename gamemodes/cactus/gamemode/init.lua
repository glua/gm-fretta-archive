
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "admin.lua" )

include( "shared.lua" )
include( "admin.lua" )
include( "tables.lua" )
include( "ply_extension.lua" )
include( "cactus.lua" )
include( "cactus_util.lua" )

function GM:Initialize()

	self.BaseClass:Initialize()
	
	local k,v
	for k,v in pairs(types) do
		if v != "golden" then
			SetGlobalInt("max"..v, GetConVar("c_max"..v):GetInt()-(10*GetGlobalInt("RoundNumber")))
		else
			SetGlobalInt("maxgolden", GetConVar("c_maxgolden"):GetInt())
		end
	end
	timer.Create("updatevars", 10, 0, function() SetGlobalInt("difficulty", GetConVar("c_difficulty"):GetInt()+(1*GetGlobalInt("RoundNumber"))) SetGlobalInt("maxcacti", GetConVar("c_maxcacti"):GetInt()-(10*GetGlobalInt("RoundNumber"))) end )
	timer.Create("infotimer", 45, 0, function() for k,v in pairs(player.GetAll()) do if ValidEntity(v) then v:ChatPrint("Hello "..v:Name()..". Welcome to Cactus Gamemode! Press F1 for help and tips on getting started.") end end end)

end

function GM:PlayerInitialSpawn( ply )
	
	self.BaseClass:PlayerInitialSpawn(ply)
	
	ply:SetTeam(TEAM_SPECTATOR)
	ply:SetLevel(1)
	ply:SetTotalScore(0)
	ply:SetCactiCaught(0)
	ply:SetNWEntity("grabber", NULL)
	ply:SetNWEntity("caughtcactus", NULL)
	ply:SetCanAutoGrab(false)
	
	ply.Upgrades = {}
	local a,b
	for a,b in pairs(types) do
		ply:SetCactiTypeCaught(b, 0)
	end
	local k,v
	for k,v in pairs(CactusSounds) do
		util.PrecacheSound(v)
	end
	
	timer.Simple(10, function() for k,v in pairs(types) do print(v..": "..UTIL_GetTotalType(v)) end if ValidEntity(ply) then ply:ChatPrint("Hello "..ply:Name()..". Welcome to Cactus Gamemode! Press F1 for help and tips on getting started.") end  end)

end

function GM:OnPreRoundStart( num )

	SetGlobalInt("difficulty", GetConVar("c_difficulty"):GetInt()+(1*GetGlobalInt("RoundNumber")))
	SetGlobalInt("maxcacti", GetConVar("c_maxcacti"):GetInt()-(10*GetGlobalInt("RoundNumber")))
	game.CleanUpMap()
	gamemode.Call("SpawnCacti")
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	local k,v
	for k,v in pairs(player.GetAll()) do
		v:SetFrags(0)
		v:SetCactiCaught(0)
		v.Upgrades = {}
		local a,b
		for a,b in pairs(types) do
			v:SetCactiTypeCaught(b, 0)
		end
	end
end

function GM:RoundStart( ply )
	
	self.BaseClass:RoundStart()
	
	UTIL_UnFreezeAllPlayers()
	
	for a,b in pairs(player.GetAll()) do
		b:ConCommand("-score")
	end
	
	local cspawns = ents.FindByClass("info_cactus_spawn")
	for k,v in pairs(cspawns) do
		local cduration = 18-GetGlobalInt("RoundNumber")-(GetGlobalInt("difficulty")/2)
		timer.Adjust("cspawntimer_"..v:EntIndex(), cduration, 0, gamemode.Call, gamemode, "SpawnCacti")
		timer.Start("cspawntimer_"..v:EntIndex())
	end
	
end

function GM:RoundTimerEnd()

	self.BaseClass:RoundTimerEnd()
	
	local cspawns = ents.FindByClass("info_cactus_spawn")
	for k,v in pairs(cspawns) do
		timer.Stop("cspawntimer_"..v:EntIndex())
	end
	
end

function GM:GetTopDawg()

	local High 
	local Value = 0

	for k,v in pairs(team.GetPlayers(TEAM_PLAYER)) do
		if v:Frags() >= Value then
			Value = v:Frags()
			High = v
		end
	end
	return High
	
end
function GM:GetTopTopDawg()

	local Highest
	local Value = 0

	for k,v in pairs(team.GetPlayers(TEAM_PLAYER)) do
		if v:GetTotalScore() >= Value then
			Value = v:SetTotalScore()
			Highest = v
		end
	end
	return Highest
	
end

function GM:RoundEnd( ply )

	self.BaseClass:RoundEnd()
	
	UTIL_StripAllPlayers()
	UTIL_FreezeAllPlayers()
	
	if not ply then 
		ply = GAMEMODE:GetTopDawg()
		if not ply then return end
	end
	if not ply2 then 
		ply2 = GAMEMODE:GetTopTopDawg()
		if not ply2 then return end
	end
	ply:SetTotalScore(ply:GetTotalScore()+1)
	
	local k,v
	for k,v in pairs(player.GetAll()) do
		if v != ply then
			v:SendLua("surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )") 
		else
			v:SendLua("surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )") 
		end
		if GAMEMODE:EndOfGame() == true then
			v:ChatPrint(ply2:Name().." won the game!")
		else
			v:ChatPrint(ply:Name().." won the round!")
			if ValidEntity(ply2) then
				v:ChatPrint(ply2:Name().." has won the most rounds so far!")
			end
		end
	end
	
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	
	self.BaseClass:EntityTakeDamage()
	
	dmginfo:ScaleDamage( 2 )
	
	if dmginfo:IsFallDamage() then
		dmginfo:SetDamage(0)
	end
	
end

function playershouldtakedamage(victim, attacker)
	if victim:GetInvincible() == true then
		return false
	else
		return true
	end
end
hook.Add( "PlayerShouldTakeDamage", "playershouldtakedamage", playershouldtakedamage )

function GM:PlayerDeathSound()

	return true // disable the BEEP BEEP sound
	
end

function GM:Think()

	self.BaseClass:Think()
	/*for k,v in pairs(player.GetAll()) do
		if v:GetMoveType() == MOVETYPE_FLY then
			if v:OnGround() then
				v:SetMoveType(MOVETYPE_WALK)
			else
				v:SetMoveType(MOVETYPE_FLY)
			end
		end
	end*/
	
end

function GM:ShouldCollide(Ent1, Ent2)

	if Ent1:IsPlayer() and Ent2:GetClass() == "grabber" then
		return false
	elseif Ent1:GetClass() == "worldspawn" and Ent2:GetClass() == "grabber" then
		return false
	elseif Ent1:GetClass() == "worldspawn" and Ent2:GetClass() == "cactus" then
		return true
	elseif Ent1:GetClass() == "chainlink_ghost" and Ent2:GetClass() == "cactus" then
		return false
	else
		return true
	end
	return true
end










