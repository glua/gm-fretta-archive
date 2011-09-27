
local CLASS = {}

CLASS.DisplayName			= "Bomberminge"
CLASS.PlayerModel			= "models/player/Kleiner.mdl"
CLASS.WalkSpeed 			= 600
CLASS.RunSpeed				= 800
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 1
CLASS.StartHealth			= 1
CLASS.AvoidPlayers			= false
CLASS.JumpPower				= 200

function CLASS:Loadout(pl)
	pl:Give("bm_weapon_bomber")
end

function CLASS:OnSpawn(pl)
	if not ValidEntity(pl.Hat) then
		if not GAMEMODE.UsedHatSkins then GAMEMODE.UsedHatSkins = {} end
		local s = 1
		while ValidEntity(GAMEMODE.UsedHatSkins[s]) and s<32 do
			s = s + 1
		end
		
		pl.Hat = ents.Create("bm_prop_hat")
		pl.Hat.Owner = pl
		pl.Hat:Spawn()
		pl.Hat:SetSkin(s)
		pl:SetNWInt("HatColor", s)
		GAMEMODE.UsedHatSkins[s] = pl
	end
	
	pl:SetNWInt("Speed", 85)
	pl:SetNWBool("Grabbing", false)
	pl.NumBombs = 0
	pl.NumBombsMax = 1
	if not pl.NumBombs then pl.NumBombs = 0 end
	pl.Power = 1
	pl.BombType = 0
	pl.AbilityType = 0
	pl.BombThrow = false
	pl.BombKick = false
	pl.CrateHide = false
end

function CLASS:OnDeath(pl, attacker, dmginfo)
	pl:EmitSound("k_lab.kl_ahhhh")
	
	local items = {}
	if pl.Power==12 then
		table.insert(items,"item_superfireup")
	else
		for i=2,math.ceil(pl.Power*0.75) do table.insert(items,"item_fireup") end
	end
	for i=2,math.ceil(pl.NumBombsMax*0.75) do table.insert(items,"item_bombup") end
	for i=85,pl:GetNWInt("Speed"),15 do table.insert(items,"item_speedup") end
	if BombTypeIDs[pl.BombType] then table.insert(items,BombTypeIDs[pl.BombType]) end
	if AbilityTypeIDs[pl.AbilityType] then table.insert(items,AbilityTypeIDs[pl.AbilityType]) end
	if pl.BombThrow then table.insert(items,"item_bombthrow") end
	if pl.BombKick then table.insert(items,"item_bombkick") end
	if pl.CrateHide then table.insert(items,"item_cratehide") end
	if ValidEntity(pl.Skull) then table.insert(items,"item_skull") end
	
	local validPositions = {}
	for x=1,GAMEMODE.Map.W do
		for y=1,GAMEMODE.Map.H do
			if GAMEMODE:IsFreeCell(x, y, nil, nil, true) then
				table.insert(validPositions, {x,y})
			end
		end
	end
	
	for _,v in ipairs(items) do
		if #validPositions==0 then return end
		
		local c = table.remove(validPositions, math.random(1,#validPositions))
		local e = ents.Create("bm_prop_item")
		e:SetPos(GAMEMODE:CellToPosition(c[1], c[2], 24))
		e.ItemType = v
		e:Spawn()
	end
end

function CLASS:Think(pl)
end

function CLASS:Move(pl, mv)
end

function CLASS:OnKeyPress(pl, key)
end

function CLASS:OnKeyRelease(pl, key)
end

function CLASS:ShouldDrawLocalPlayer(pl)
	return not pl:GetNWBool("FPSMode")
end

function CLASS:CalcView(ply, origin, angles, fov)
end

player_class.Register("Bomberminge", CLASS)

CLASS = {}
CLASS.DisplayName			= "Spectator Class"
CLASS.DrawTeamRing			= false
CLASS.PlayerModel			= "models/player.mdl"

function CLASS:OnSpawn(pl)
	print("spectator", pl)
	if ValidEntity(pl.Hat) then
		GAMEMODE.UsedHatSkins[pl.Hat:GetSkin()] = nil
		pl.Hat:Remove()
	end
	pl:SetPos(pl:GetPos() + Vector(0,0,50))
end

player_class.Register("Spectator", CLASS)