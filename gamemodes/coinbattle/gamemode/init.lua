AddCSLuaFile("cl_buymenu.lua")
AddCSLuaFile("cl_help.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_scores.lua")
AddCSLuaFile("cl_selectscreen.lua")
AddCSLuaFile("cl_splashscreen.lua")
AddCSLuaFile("cl_targetid")
AddCSLuaFile("sh_meta.lua")
AddCSLuaFile("sh_tables.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("player_class/default.lua")
AddCSLuaFile("vgui/vgui_ammo.lua")
AddCSLuaFile("vgui/vgui_health.lua")
AddCSLuaFile("vgui/vgui_weapon_button.lua")

include("shared.lua")
include("sv_round_controller.lua")
include("sv_coin_controller.lua")

resource.AddFile("sound/coinbattle/smb_coin.wav")
resource.AddFile("materials/coinbattle/cent.vtf")
resource.AddFile("materials/coinbattle/HUD/ammo.vtf")
resource.AddFile("materials/coinbattle/HUD/ammo_inner.vtf")
resource.AddFile("materials/coinbattle/HUD/health.vtf")
resource.AddFile("materials/coinbattle/HUD/health_inner.vtf")
resource.AddFile("materials/coinbattle/HUD/back_main.vtf")
resource.AddFile("materials/coinbattle/HUD/back_s.vtf")
resource.AddFile("materials/coinbattle/coin_battle_title.vtf")

function GM:GetTeamScore(Team)
	
	local total = 0
	for _,ply in pairs(team.GetPlayers(Team)) do
		total = total + ply:GetCoins()
	end
	return total
	
end

function GM:UpdateScores()
	
	team.SetScore(TEAM_CYAN, GAMEMODE:GetTeamScore(TEAM_CYAN))
	team.SetScore(TEAM_ORANGE, GAMEMODE:GetTeamScore(TEAM_ORANGE))
	
end

function GM:PlayerInitialSpawn(ply)
	
	self.BaseClass:PlayerInitialSpawn(ply)
	
	ply:AddBankCoins(40)
	ply:SetLOWeapon(1,1) --give SMG by default
	ply:SetLOWeapon(2,1) --give Pistol by default

	ply.NextGrenadeFire = 0
	
end

function GM:PlayerDeathThink( pl )

	pl.DeathTime = pl.DeathTime or CurTime()
	local timeDead = CurTime() - pl.DeathTime
	
	// If we're in deathcam mode, promote to a generic spectator mode
	if ( GAMEMODE.DeathLingerTime > 0 && timeDead > GAMEMODE.DeathLingerTime && ( pl:GetObserverMode() == OBS_MODE_FREEZECAM || pl:GetObserverMode() == OBS_MODE_DEATHCAM ) ) then
		GAMEMODE:BecomeObserver( pl )
	end
	
	// If we're in a round based game, player NEVER spawns in death think
	if ( GAMEMODE.NoAutomaticSpawning ) then return end
	
	// The gamemode is holding the player from respawning.
	// Probably because they have to choose a class..
	if ( !pl:CanRespawn() ) then return end

	// Don't respawn yet - wait for minimum time...
	if ( GAMEMODE.MinimumDeathLength ) then 
	
		pl:SetNWFloat( "RespawnTime", pl.DeathTime + GAMEMODE.MinimumDeathLength )
		
		if ( timeDead < pl:GetRespawnTime() ) then
			return
		end
		
	end
	
	if ( !GAMEMODE:InRound() ) then return end
	
	// Force respawn
	if ( pl:GetRespawnTime() != 0 && GAMEMODE.MaximumDeathLength != 0 && timeDead > GAMEMODE.MaximumDeathLength ) then
		pl:Spawn()
		return
	end

	// We're between min and max death length, player can press a key to spawn.
	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
		pl:Spawn()
	end
	
end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	// Here's an immediate respawn thing by default. If you want to 
	// re-create something more like CS or some shit you could probably
	// change to a spectator or something while dead.
	if ( newteam == TEAM_SPECTATOR ) then
	
		// If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )
		
	elseif ( oldteam == TEAM_SPECTATOR ) then
	
		// If we're changing from spectator, join the game
		if ( !GAMEMODE.NoAutomaticSpawning ) then
			ply:Spawn()
		end
	
	else
	
		
		
	end
	
	GAMEMODE:UpdateScores()
	
	// Send umsg for team change
    local rf = RecipientFilter();
    rf:AddAllPlayers();
 
    umsg.Start( "fretta_teamchange", rf );
		umsg.Entity( ply );
		umsg.Short( oldteam );
		umsg.Short( newteam );
    umsg.End();
	
end

function GM:FindLeastCommittedPlayerOnTeam( teamid )

	local worst = nil

	for k,v in pairs( team.GetPlayers( teamid ) ) do
		
		if ( !worst || v:GetCoins() < worst:GetCoins() ) then
			worst = v
		end
		
	end
	
	return worst
	
end

function GM:OnEntityCreated(ent)
	
	if not ent:IsValid() then return end
	
	if string.find(ent:GetClass(),"item_healthkit") ~= nil then
		--print(ent:GetClass().." is a healthkit.")
		
		timer.Simple(1,function(ent)
			if ent:IsValid() then
				--print(ent:GetClass().." has spawned a medkit")
				local med = ents.Create("cb_medkit")
				med:SetPos(ent:GetPos()+Vector(0,0,8))
				med:Spawn()
				ent:Remove()
			end
		end,ent)
		
	end
	
end

function GM:EntityKeyValue(ent, key, value)
	
	if ent:GetClass() == "info_player_teamspawn" then //Add support for TF2 spawn entity.
		
		if key == "TeamNum" then
			
			if value == "3" then //3 is BLU
				local Cspawn = ents.Create("info_player_combine")
				Cspawn:SetPos(ent:GetPos())
				Cspawn:SetAngles(ent:GetAngles())
				Cspawn:Spawn()
			elseif value == "2" then //2 is RED
				local Ospawn = ents.Create("info_player_rebel")
				Ospawn:SetPos(ent:GetPos())
				Ospawn:SetAngles(ent:GetAngles())
				Ospawn:Spawn()
			end
			
		end
		
	end
	
	if string.find(ent:GetClass(),"healthkit") == nil and (string.find(ent:GetClass(),"weapon_") ~= nil or string.find(ent:GetClass(),"item_") ~= nil) then
		
		--print(ent:GetClass().." Removed")
		ent:Remove()
		
	end
	
end

concommand.Add("cb_buy_weapon", function(ply, cmd, args)
	
	if !GAMEMODE:InPreRound() then return end
	
	local slot = tonumber(args[1]) or "none"
	local weapon = tonumber(args[2]) or "none"
	
	if weapon == "none" then return end
	
	if not WeaponTable[slot] then print("[CoinBattle]Slot "..slot.." does not exist.") return end
	if not WeaponTable[slot][weapon] then print("[CoinBattle]Weapon s"..slot..", w"..weapon.." does not exist.") return end
	
	ply:SetLOWeapon(slot, weapon)
	
end)

function GM:ShowSpare1(ply)
	
	if !ply:Alive() or !GAMEMODE:InPreRound() then return end
	ply:ConCommand("cb_buy_menu")
	
end