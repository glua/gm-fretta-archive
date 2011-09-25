AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.Author = "Ghor"
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Created = 0
ENT.Model = "models/Items/item_item_crate.mdl"
ENT.PickupFuncs = {}
PrecacheParticleSystem("gtv_ammoring_large")
PrecacheParticleSystem("gtv_ammoring_medium")
PrecacheParticleSystem("gtv_ammoring_small")
PrecacheParticleSystem("gtv_weaponring")
--PrecacheParticleSystem()
--models/Items/item_item_crate.mdl
--models/Items/BoxMRounds.mdl
--models/Items/BoxBuckshot.mdl

function ENT:Initialize()
	self:SetModel(gtv_itemtable[self.dt.ItemType].Model)
	self.ang = self:GetAngles()
	self.Created = CurTime()
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetTrigger(true)
end

function ENT:Think()
	self:NextThink(CurTime()+0.02)
	self.ang.y = self.ang.y+4
	self:SetAngles(self.ang)
	return true
end

function ENT:Touch(hitent)
	if hitent:IsPlayer() && !self.Activated then
		//self.PickupFuncs[string.lower(self:GetModel())](self,hitent)
		if gtv_itemtable[self.dt.ItemType].PickupFunction(self,hitent) then
			self.Activated = true
			self:Remove()
		end
	end
end

function ENT:PhysicsCollide(data,physobj)
end

function ENT:OnRemove() --if we are a spawned item, let the spawner know so it can prepare to spawn a new one
	if self.GTV_itemowner then
		self.GTV_itemowner.LastTaken = CurTime()
	end
end

