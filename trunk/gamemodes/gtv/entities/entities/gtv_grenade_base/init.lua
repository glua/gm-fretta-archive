AddCSLuaFile("cl_init.lua")
ENT.Author = "Ghor"
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Created = 0
ENT.FuseTime = 1
ENT.Model = "models/Items/grenadeAmmo.mdl"
PrecacheParticleSystem("gtv_expwithsmoke")

function ENT:Initialize()
	local ang = self:GetAngles()
	self:SetAngles(Angle(0,0,0))
	self.Created = CurTime()
	self:SetModel(self.Model)
	self:PhysicsInitBox(self:OBBMins(),self:OBBMaxs())
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetAngles(ang)
	self.Owner = self:GetOwner()
	if !self:GetOwner():IsValid() then
		self.Owner = GetWorldEntity()
	end
end

function ENT:Think()
	self:NextThink(CurTime()+0.1)
	if self.ParticleEffect then
		ParticleEffectAttach(self.ParticleEffect,PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.ParticleEffect = nil
	end
	if (self.FuseTime != 0) && (self.Created+self.FuseTime < CurTime()) then
		self:Explode()
	end
	return true
end

function ENT:Explode()
	util.BlastDamage(self,self.Owner,self:GetPos(),150,80)
	ParticleEffect("gtv_expwithsmoke",self:GetPos(),Angle(0,0,0),Entity(0))
	self:EmitSound("weapons/smg1/smg1_fire1.wav",100,42)
	self:Remove()
end

function ENT:PhysicsCollide(data,physobj)
	if data.Speed > 50 then
		self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav")
	end
	physobj:SetVelocity(vector_origin)
end