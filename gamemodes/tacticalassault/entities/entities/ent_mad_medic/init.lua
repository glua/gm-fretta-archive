AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.Owner = self.Entity.Owner

	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end

	self.Entity:SetModel("models/items/healthkit.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)

	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	undo.Create("Medic Kit")
		undo.AddEntity(self.Entity)
		undo.SetPlayer(self.Owner)
	undo.Finish()

	self.Entity:SetUseType(SIMPLE_USE)
end

/*---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------*/
function ENT:Use(activator, caller)

	self.Entity:EmitSound(Sound("HealthVial.Touch"))
	self.Entity:Remove()

	activator:SetHealth(100)
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	for _, v in pairs(ents.FindInSphere(self.Entity:GetPos(), 5)) do
		if (v:IsNPC()) then
			self.Entity:EmitSound(Sound("HealthVial.Touch"))
			self.Entity:Remove()

			v:SetHealth(100)
		end
	end
end