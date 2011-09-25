// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Powerup effects.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local RarityUpgrade = 15 // Seconds.
local RespawnTime = 5 // Seconds.
ENT.PowerupSound = "NPC_CombineGunship.PatrolPing"

/*-------------------------------------------------------------------
	[ KeyValue ]
	The KeyValues given to this entity.
-------------------------------------------------------------------*/
function ENT:KeyValue(key, value)
	if key == "baserarity" then
		self.BaseRarity = math.Clamp(tonumber(value),1,100)
	elseif key == "maxrarity" then
		self.MaxRarity = math.Clamp(tonumber(value),1,100)
	end
end

/*-------------------------------------------------------------------
	[ Initialize ]
	When the entity is initialized.
-------------------------------------------------------------------*/
function ENT:Initialize()
	self.Rarity = self.BaseRarity or 1
	self.ActivatedTime = 0
	self.Powerup = false
	self.IsActive = false
	
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)
	self.Entity:DrawShadow(false)

	self.Entity:SetCollisionBounds(Vector(-32, -32, -32), Vector(32, 32, 0))
	self.Entity:PhysicsInitBox(Vector(-32, -32, -32), Vector(32, 32, 0))
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then phys:EnableCollisions(false)	end
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self.Entity:SetTrigger(true)
	//self.Entity:SetNotSolid(true) // Using this means that Use will no longer trigger the entity.
	util.PrecacheSound(self.PowerupSound)
	
	if GAMEMODE then self:SetPowerup(GAMEMODE:RollPowerup(self.Rarity)) end
end
 
/*-------------------------------------------------------------------
	[ SetPowerup ] ( Powerup Object )
	Set this pickup to a certain powerup.
-------------------------------------------------------------------*/
function ENT:SetPowerup(powerup)
	
	self.ActivatedTime = CurTime() // When it was set active (used to count until the upgrade in rarity and rerolling)
	self.Powerup = powerup
	self.IsActive = true
	
	self:SetNWString("Powerup",powerup.Name)
	
	/*-----
	umsg.Start("powerup_activate")
		umsg.String(powerup.Name)
		umsg.Entity(self)
	umsg.End()
	-----*/
	
	// TODO: Powerup spawn effect.
end

/*-------------------------------------------------------------------
	[ Think ]
	Think function.
-------------------------------------------------------------------*/
function ENT:Think()
	if self.IsActive and CurTime() - self.ActivatedTime >= RarityUpgrade then
		
		// Up the rarity.
		self.Rarity = self.Rarity + 1
		if self.MaxRarity and self.Rarity > self.MaxRarity then self.Rarity = self.MaxRarity end
		
		// Reroll the powerup at a higher rarity level.
		self:SetPowerup(GAMEMODE:RollPowerup(self.Rarity))
		
	end
end

/*-------------------------------------------------------------------
	[ PowerupPlayer ]
	Give current powerup to a player.
-------------------------------------------------------------------*/
function ENT:PowerupPlayer(ply)
	GAMEMODE:GrantPowerup(ply,self.Powerup)
	
	local fx = EffectData()
		fx:SetOrigin(self:GetPos()+Vector(0,0,8))
		fx:SetEntity(ply)
		fx:SetMagnitude(0.5)
	util.Effect("PwupAcquire",fx,true,true)
	ply:EmitSound(self.PowerupSound,100,255)
	ply:SendLua("LocalPlayer():EmitSound(\""..self.PowerupSound.."\",100,255)")
	
	self.IsActive = false
	self.Rarity = self.BaseRarity or 1
	timer.Simple(RespawnTime,self.SetPowerup,self,GAMEMODE:RollPowerup(self.Rarity))
	
	self:SetNWString("Powerup",false)
end

/*-------------------------------------------------------------------
	[ Touch ]
	When the entity is touched.
-------------------------------------------------------------------*/
function ENT:Touch(ply)
	if self.IsActive and self.Powerup and ply:IsValid() and ply:IsPlayer() and not GAMEMODE:GetPowerupFromSlot(ply,self.Powerup.Type) then
		self:PowerupPlayer(ply)
	end
end


/*-------------------------------------------------------------------
	[ Use ]
	When the entity is used.
-------------------------------------------------------------------*/
function ENT:Use(ply)
	if self.IsActive and self.Powerup and ply:IsValid() and ply:IsPlayer() and GAMEMODE:GetPowerupFromSlot(ply,self.Powerup.Type) ~= self.Powerup then
		GAMEMODE:DropPowerup(ply,self.Powerup.Type) // If we have a powerup in the slot, drop it.
		self:PowerupPlayer(ply)
	end
end
