AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_shop.lua" )
include( "shared.lua" )
include( "round_controller.lua" )
include( "shop.lua" )
resource.AddFile("sound/music/hns/ololol.mp3")
InvisActive = {}

timer.Simple(60, function() GameLock = true end)

function GameLockCheck(ply)
	if GameLock then
		ply.Found = true
	else
		ply.Found = false
	end
end
hook.Add("PlayerInitialSpawn", "hns_gamelock", GameLockCheck)
hook.Add("OnPlayerChangedTeam", "hns_gamelock2", GameLockCheck)

function GM:OnEndOfGame( bGamemodeVote )
	for k,v in pairs(player.GetAll()) do
		if not v.Found then
			print("Calling fuckin hook")
			hook.Call("UhnsHidden", nil, v)
		end
	end
end

function InvisKey(ply, key)
	if !ply:Alive() then return end
	local InvisTime = ply:GetNWInt("InvisTime")
	if ply:GetNWBool("HasInvis") then
		if key == IN_ATTACK2 then
			if InvisActive[ply] then
				InvisActive[ply] = false
				ply:SetNWBool("Invis", false)
				playhev(ply, "hl1/fvox/deactivated.wav")
				ply:SetNWInt("InvisTime", InvisTime - 1)
				ply:SetColor(255,255,255,255)
				if IsValid(ply:GetActiveWeapon()) then
					ply:GetActiveWeapon():SetColor(255,255,255,255)
				end
			else
				if InvisTime <= 0 then
					playhev(ply, "hl1/fvox/hev_general_fail.wav")
				else
					playhev(ply, "hl1/fvox/activated.wav")
					InvisActive[ply] = true
					ply:SetNWBool("Invis", true)
					ply:SetColor(255,255,255,30)
					if IsValid(ply:GetActiveWeapon()) then
						ply:GetActiveWeapon():SetColor(255,255,255,30)
					end
				end
			end
		end
	end
end
hook.Add( "KeyPress", "hns_inviskey", InvisKey )

function InvisParse()
	for k,v in pairs(player.GetAll()) do 
		if InvisActive[v] then
			local InvisTime = v:GetNWInt("InvisTime")
			InvisTime = InvisTime - 1
			v:SetNWInt("InvisTime", InvisTime)
			if InvisTime <= 0 then
				InvisActive[v] = false
				v:SetNWBool("Invis", false)
				v:SetColor(255,255,255,255)
				InvisDepleted(v)
			end
		end
	end
end
timer.Create("InvisParse", 1, 0, InvisParse)

function CheckRound()
	local hiders = team.GetPlayers(TEAM_HIDERS)
	local seekers = team.GetPlayers(TEAM_SEEKERS)
	if #hiders > 1 and #seekers == 0 then
		GAMEMODE:RoundEnd()
	end
end
timer.Create("Checkround", 10, 0, CheckRound)

function InvisDepleted(ply)
	playhev(ply, "hl1/fvox/hev_shutdown.wav")
	local timername = "InvisRestore"..ply:EntIndex()
	timer.Create(timername, 40, 1, InvisRestore, ply)
end

function InvisRestore(ply)
	ply:SetNWInt("InvisTime", 20)
	playhev(ply, "hl1/fvox/power_restored.wav")
end

function GM:GetFallDamage( ply, fspeed )
 	return 0
end

function playerDies( victim, weapon, killer )
	if victim:Team() == TEAM_HIDERS then
		if IsValid(killer) and killer:IsPlayer() and killer:Team() == TEAM_SEEKERS then
			victim:AddFrags(#team.GetPlayers(TEAM_SEEKERS) - 1)
		end		
		victim:SetTeam(TEAM_SEEKERS)
		victim:SetNWInt("InvisTime", 20)
		LastVictim = victim
		if InvisActive[victim] and InvisActive[victim] == true and IsValid(killer) and killer:IsPlayer() then
			hook.Call("UHNSKilledInvis", nil, killer)
		end
		InvisActive[victim] = false
		victim:SetNWBool("Invis", false)
//		playhev(victim, "hl1/fvox/deactivated.wav")
		victim:SetColor(255,255,255,255)
		if IsValid(victim:GetActiveWeapon()) then
			victim:GetActiveWeapon():SetColor(255,255,255,255)
		end
		victim.Found = true
		if weapon:GetClass() == "throwing_crowbar" then
			hook.Call("UHNSThrowingCrowbarKill", nil, killer.Owner)
		end
		if weapon:GetClass() == "npc_grenade_frag" then
			hook.Call("UHNSNadeKill", nil, killer)
		end
	end
	local hiders = team.GetPlayers(TEAM_HIDERS)
	local plys = player.GetAll()
	if #plys >= 5 and #hiders == 1 and !BennyHill then
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		umsg.Start("BennyHill", rp)
		umsg.Bool(true)
		umsg.End()
		hook.Call("UHNSBennyHill", nil, hiders[1])
		BennyHill = true
	end
end
hook.Add( "PlayerDeath", "HNS_PlayerDeath", playerDies );

function PlayerDisconnected(ply)
	local seekers = team.GetPlayers(TEAM_SEEKERS)
	if seekers[1] == ply then
		local players = player.GetAll()
		local victim = table.Random(players)
		victim:SetTeam(TEAM_SEEKERS)
	end
end

hook.Add("PlayerDisconnected", "hns_plydisconnected", PlayerDisconnected)

function playhev(ply,sound)
	if !IsValid(ply) or !ply:IsPlayer() then return end
	umsg.Start("cl_playhev", ply)
	umsg.String(sound)
	umsg.End()
end 

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
     return false
end
 