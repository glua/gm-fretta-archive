AddCSLuaFile("shared.lua")
AddCSLuaFile("player_extension.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("skin.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("vgui/vgui_ammoclip.lua")

include("shared.lua")

--resource.AddFile("materials/effects/mut-screen-refract.vmt")
resource.AddFile("materials/effects/mut-screen-fire.vmt")
resource.AddFile("materials/effects/mut-screen-fire.vtf")
resource.AddFile("materials/effects/mut-screen-fire-mask.vtf")

resource.AddFile("materials/hud/health.vmt")
resource.AddFile("materials/hud/health.vtf")
resource.AddFile("materials/hud/ammo.vmt")
resource.AddFile("materials/hud/ammo.vtf")
resource.AddFile("materials/hud/ammo-inner.vmt")
resource.AddFile("materials/hud/ammo-inner.vtf")

GM.LastMutant = nil

local MutateSound = Sound("ambient/machines/teleport1.wav")

function GM:Initialize()
	SetGlobalBool("mutantExists",false)
end

function GM:DoPlayerDeath(pl, attacker, dmg)
	self.BaseClass:DoPlayerDeath(pl,attacker,dmg)

	if attacker:IsPlayer() and  pl ~= attacker and (not GetGlobalBool("mutantExists") or pl:IsMutant()) then

		pl:SetPlayerClass("Default")
	
		SetGlobalBool("mutantExists",true)
		attacker:SetPlayerClass("Mutant")
		if attacker:Alive() then
			attacker:GetActiveWeapon():SetNetworkedInt("ammo",30,false)
		end
		attacker:Spawn()
		attacker:EmitSound(MutateSound,150,100)
		self.LastMutant = attacker
		
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		rf:RemovePlayer(attacker)
		umsg.Start("Mutant_BigMessage",rf)
			umsg.String(attacker:Nick() .. " has become the Mutant!")
			umsg.Short(255)
			umsg.Short(160)
			umsg.Short(50)
			umsg.Float(3)
		umsg.End()
		
		umsg.Start("Mutant_BigMessage",attacker)
			umsg.String("You are now the Mutant!")
			umsg.Short(100)
			umsg.Short(200)
			umsg.Short(30)
			umsg.Float(2)
		umsg.End()
	end
end

function GM:OnPlayerChangedTeam(pl,newTeam)
	if pl == self.LastMutant then
		self:PickNewMutant()
	end
	self.BaseClass:PlayerChangedTeam(pl,newTeam)
end

function GM:PlayerDisconnected(pl)
	if pl == self.LastMutant then
		self:PickNewMutant()
	end
	self.BaseClass:PlayerDisconnected(pl)
end

function GM:PickNewMutant()
	SetGlobalBool("mutantExists",false)
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	umsg.Start("Mutant_BigMessage",rf)
		umsg.String("Next kill becomes the Mutant!")
		umsg.Short(255)
		umsg.Short(160)
		umsg.Short(50)
		umsg.Float(3)
	umsg.End()
	self.LastMutant = nil
end

function GM:PlayerShouldTakeDamage(pl,attacker)
	if not attacker:IsPlayer() then return true end

	if pl:IsMutant() or attacker:IsMutant() or not GetGlobalBool("mutantExists") then return true end
	
	-- bottom feeder
	local bottom = true
	for _,op in pairs(player.GetAll()) do
		if op ~= attacker and op:Frags() <= attacker:Frags() then
			bottom = false
			break
		end
	end
	if bottom then return true end

	return false
end

function GM:PlayerInitialSpawn(pl)
	self.BaseClass:PlayerInitialSpawn(pl)
	pl:SetPlayerClass("Default")
end

function GM:PlayerSpawn(pl)
	self.BaseClass:PlayerSpawn(pl)
	
	--timer.Simple(.2,function() pl:GetActiveWeapon():SetNetworkedInt("ammo",30,true) end)
end
