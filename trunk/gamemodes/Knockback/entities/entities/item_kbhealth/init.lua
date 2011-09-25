AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.aHealth = 70
ENT.aModel = "models/items/HealthKit.mdl"
ENT.gib = 1
ENT.brkOnUse = 1
ENT.dieTime = 0
ENT.killme = false
ENT.Touched = false

function ENT:Initialize()

	self.Entity:SetModel(self.aModel)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:GetCenterPos()
	return self:GetPos()
end

function ENT:Use(activator, caller)
	return false
end

function ENT:OnRemove()
end

function ENT:Touch(hitEnt)
	if !hitEnt:IsValid() or !hitEnt:IsPlayer() then return end
	
	if self.Entity.Touched == false then
		local health = hitEnt:Health()
	
		if (health <= 30) then
			health = 1
		else
			health = health - 30
		end
	
		hitEnt:SetHealth(health)
		self.Entity.killme = true
		self.Entity.Touched = true
	end
end

function ENT:Think()
	if (self.Entity.killme == true) then
		self:EmitSound("HealthKit.Touch")
		self:Remove()
	end
end