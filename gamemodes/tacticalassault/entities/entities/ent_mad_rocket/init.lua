AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local RocketSound = Sound("Missile.Accelerate")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.Owner = self.Entity:GetOwner()

	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end
 
	self.Entity:SetModel("models/weapons/w_missile_closed.mdl")
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)   
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.SpawnTime = CurTime()
 
	self.PhysObj = self.Entity:GetPhysicsObject()

	if (self.PhysObj:IsValid()) then
		self.PhysObj:EnableGravity(false)
		self.PhysObj:EnableDrag(false) 
		self.PhysObj:SetMass(30)
        	self.PhysObj:Wake()
	end
		
	self.Entity:EmitSound(RocketSound)
	util.PrecacheSound("explode_4")

	self.TimeLeft = CurTime() + 3
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	local phys 		= self.Entity:GetPhysicsObject()
	local ang 		= self.Entity:GetForward() * 7500
	local upang
	local rightang

	upang 	= self.Entity:GetUp() * math.Rand(500, 2000) * (math.sin(CurTime() * math.Rand(500, 1000)))
	rightang 	= self.Entity:GetRight() * math.Rand(500, 2000) * (math.cos(CurTime() * math.Rand(500, 1000)))

	local force

	if self.Entity:WaterLevel() > 0 or self.TimeLeft < CurTime() then
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		self.Entity:StopSound(RocketSound)
	else
		if self.SpawnTime + 0.75 < CurTime() then
			force = ang + upang + rightang
		else
			force = ang
		end

		phys:ApplyForceCenter(force)
	end
end

/*---------------------------------------------------------
   Name: ENT:Explosion()
---------------------------------------------------------*/
function ENT:Explosion()

	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0, 0, 32)
	trace.endpos = self.Entity:GetPos() - Vector(0, 0, 128)
	trace.Entity = self.Entity
	trace.mask  = 16395
	local Normal = util.TraceLine(trace).HitNormal

	self.Scale = 0.3

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
	util.Effect("HelicopterMegaBomb", effectdata)

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetNormal(Normal)
		effectdata:SetScale(self.EffectScale)
	util.Effect("effect_mad_ignition", effectdata)
	
	local explo = ents.Create("env_explosion")
		explo:SetOwner(self.Owner)
		explo:SetPos(self.Entity:GetPos())
		explo:SetKeyValue("iMagnitude", "70")
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
	
	/*local ar2Explo = ents.Create("env_ar2explosion")
		ar2Explo:SetOwner(self.Owner)
		ar2Explo:SetPos(self.Entity:GetPos())
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire("Explode", "", 0)*/

	local en = ents.FindInSphere(self.Entity:GetPos(), 300)

	for k, v in pairs(en) do
		if (v:GetPhysicsObject():IsValid()) then
			// Unweld and unfreeze props
			if (math.random(1, 100) < 30) then
				v:Fire("enablemotion", "", 0)
				constraint.RemoveAll(v)
			end
		end
	end
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollide()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, physobj) 

	util.Decal("Scorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal) 

	self:Explosion()

	self.Entity:Remove()
end

/*---------------------------------------------------------
   Name: ENT:OnRemove()
---------------------------------------------------------*/
function ENT:OnRemove()

	self.Entity:StopSound(RocketSound)
end

