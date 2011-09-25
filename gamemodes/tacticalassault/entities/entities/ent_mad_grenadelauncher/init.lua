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

	self.Entity:SetModel("models/items/ar2_grenade.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.Timer = CurTime() + 0.075
	self.Explode = false

//	util.SpriteTrail(self.Entity, 0, Color(155, 155, 155, 155), false, 2, 10, 5, 5 / ((2 + 10) * 0.5), "trails/smoke.vmt")
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	if self.Timer < CurTime() then
		self.Explode = true
		self.Timer = CurTime() + 100
	end

	if self.Entity:WaterLevel() > 2 then
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
		explo:SetKeyValue("iMagnitude", "200")
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode", "", 0)
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "2000")	// Power of the shake
		shake:SetKeyValue("radius", "900")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)

	local en = ents.FindInSphere(self.Entity:GetPos(), 100)

	for k, v in pairs(en) do
		if (v:GetPhysicsObject():IsValid()) then
			// Unweld and unfreeze props
			if (math.random(1, 100) < 10) then
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

	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("Grenade.ImpactHard"))
	end

	if not self.Explode then 
		self.Entity:Fire("kill", "", 5)
		self.Entity:SetNWBool("Explode", true)
		self.Timer = CurTime() + 100
		self.Explode = false
		return 
	end

	self.Explode = false

	util.Decal("Scorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal) 

	self:Explosion()
	self.Entity:Remove()
end