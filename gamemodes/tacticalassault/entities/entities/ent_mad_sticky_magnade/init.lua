// Thanks to CptFuzzies for helping me with the constraint.Weld.
// He told me that we can't weld an entity if we use the PhysicsCollide function.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.Owner = self.Entity:GetOwner()

	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end

	self.Entity:SetModel("models/weapons/w_magnade.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	
//	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(2)
		phys:EnableGravity(true)
		phys:EnableDrag(true)
	end

//	self.Timer = CurTime() + 3

	util.SpriteTrail(self.Entity, 0, Color(128, 255, 255, 255), false, 30, 0, 1, 1 / ((30 + 0) * 0.5), "trails/laser.vmt")
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	if (self.Entity.HitWeld) then  
		self.HitWeld = false  
		constraint.Weld(self.Entity.HitEnt, self.Entity, 0, 0, 0, true)  
	end 
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollide()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, phys)

	if not self.Entity.Hit then self.Entity.Hit = false end
	if self.Entity.Hit then return end

	self.Entity.Hit = true

	timer.Simple(0.5, function() if not self.Entity then return end self.Entity:EmitSound("weapons/strider_buster/strider_buster_stick1.wav") end)
	timer.Simple(1.75, function() if not self.Entity then return end self:Explosion() self.Entity:Remove() end)

	self.Entity:EmitSound("NPC_Hunter.FlechetteHitBody")

	phys:EnableMotion(false)
	phys:Sleep()

	if data.HitEntity:IsValid() then
		if data.HitEntity:IsNPC() or data.HitEntity:IsPlayer() then
			self.Entity:SetParent(data.HitEntity)
		else
			self.Entity.HitEnt = data.HitEntity
			self.Entity.HitWeld = true
		end

		phys:EnableMotion(true)
		phys:Wake()
	end

	local energyball = ents.Create("env_citadel_energy_core")
	energyball:SetPos(self.Entity:GetPos())
	energyball:SetKeyValue("scale", 2)
	energyball:Spawn()
	energyball:Activate()
	energyball:SetParent(self.Entity)
	energyball:Fire("StartCharge", "1", 0)
end

/*---------------------------------------------------------
   Name: ENT:Explosion()
---------------------------------------------------------*/
function ENT:Explosion()

	local explo = ents.Create("env_explosion")
		explo:SetOwner(self.Owner)
		explo:SetPos(self.Entity:GetPos())
		explo:SetKeyValue("iMagnitude", "125")
		explo:SetKeyValue("spawnflags", "66")
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode", "", 0)
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "1000")	// Power of the shake
		shake:SetKeyValue("radius", "600")		// Radius of the shake
		shake:SetKeyValue("duration", "1.5")	// Time of shake
		shake:SetKeyValue("frequency", "225")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)

	local en = ents.FindInSphere(self.Entity:GetPos(), 75)

	for k, v in pairs(en) do
		if (v:GetPhysicsObject():IsValid()) then
			// Unweld and unfreeze props
			if (math.random(1, 100) < 10) then
				v:Fire("enablemotion", "", 0)
				constraint.RemoveAll(v)
			end
		end
	end

	self.Entity:EmitSound("npc/ministrider/flechette_explode" .. math.random(1, 3) .. ".wav", 150)
end