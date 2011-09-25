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
	end

	self.Timer = CurTime() + 3.25
	self.SoundTimer = CurTime() + 2
	self.EffectTimer = CurTime() + 3

	util.SpriteTrail(self.Entity, 0, Color(128, 255, 255, 255), false, 30, 0, 1, 1 / ((30 + 0) * 0.5), "trails/laser.vmt")
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	if self.EffectTimer < CurTime() then
		local tracedata = {}
		tracedata.start = self.Entity:GetPos()
		tracedata.endpos = Vector(self.Entity:GetPos().x, self.Entity:GetPos().y, self.Entity:GetPos().z - 10)
		tracedata.filter = self.Entity
		local tr = util.TraceLine(tracedata)

		if tr.Hit then
			self.Entity:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, 500))
		end

		self.EffectTimer = CurTime() + 5
	end

	if self.SoundTimer < CurTime() then
		self.Entity:EmitSound("weapons/strider_buster/strider_buster_stick1.wav")
		self.SoundTimer = CurTime() + 5

		local energyball = ents.Create("env_citadel_energy_core")
		energyball:SetPos(self.Entity:GetPos())
		energyball:SetKeyValue("scale", 2)
		energyball:Spawn()
		energyball:Activate()
		energyball:SetParent(self.Entity)
		energyball:Fire("StartCharge", "1", 0)
	end

	if self.Timer < CurTime() then
		self:Explosion()
		self.Entity:Remove()
	end
end

/*---------------------------------------------------------
   Name: ENT:Explosion()
---------------------------------------------------------*/
function ENT:Explosion()

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
	util.Effect("HelicopterMegaBomb", effectdata)
	
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