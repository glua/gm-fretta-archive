ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "rocket"
ENT.Author = "Ghor"
ENT.Contact = "none"
ENT.Purpose = "none"

function ENT:PhysicsUpdate()
	if SERVER then
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
		ParticleEffectAttach("gtv_rocket_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.loop = CreateSound(self,"weapons/rpg/rocket1.wav")
		self.loop:Play()
		self.expl = false
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_NONE)
	end
end

function ENT:Use()
end

