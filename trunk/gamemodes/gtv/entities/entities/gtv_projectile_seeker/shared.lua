ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "rocket"
ENT.Author = "Ghor"
ENT.Contact = "none"
ENT.Purpose = "none"

PrecacheParticleSystem("gtv_seeker_trail")
PrecacheParticleSystem("gtv_seeker_impact")

function ENT:PhysicsUpdate()
	if SERVER then
		if self.target:IsValid() && (!self.target:IsPlayer() || (self.target:IsPlayer() && self.target:Alive())) then
			local vel = self:GetVelocity():Angle()
			local vec1 = (self.target:GetPos()+self.target:OBBCenter()-self:GetPos()):Angle()
			local amt = 180*(CurTime()-self.lastupdate)
			vel.p = math.ApproachAngle(vel.p,vec1.p,amt)
			vel.y = math.ApproachAngle(vel.y,vec1.y,amt)
			vel.r = math.ApproachAngle(vel.r,vec1.r,amt)
			self:GetPhysicsObject():SetVelocity(vel:Forward()*1000)
		else
			self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity():GetNormalized()*10000)
			self.target = NULL
		end
		self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity():GetNormalized()*1000)
		self:SetLocalAngles(self:GetPhysicsObject():GetVelocity():GetNormalized():Angle())
		self.lastupdate = CurTime()
	end
end


function ENT:Initialize()
	self:SetModel("models/weapons/W_missile_closed.mdl")
	if SERVER then
		self.expl = false
		self.Entity:PhysicsInitBox(Vector(-5,-5,-5),Vector(5,5,5))
		self.Entity:SetCollisionBounds(Vector(-5,-5,-5),Vector(5,5,5))
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.lastupdate = CurTime()
		self.Created = CurTime()
		self:SetTrigger(true)
		self:GetPhysicsObject():EnableGravity(false)
	else
		ParticleEffectAttach("gtv_seeker_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.loop = CreateSound(self,"ambient/energy/electric_loop.wav")
		self.loop:Play()
		self.expl = false
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_NONE)
	end
end

function ENT:Use()
end

