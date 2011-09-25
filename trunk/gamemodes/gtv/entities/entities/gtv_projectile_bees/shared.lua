ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "rocket"
ENT.Author = "Ghor"
ENT.Contact = "none"
ENT.Purpose = "none"

function ENT:PhysicsUpdate()
	if SERVER then
		if self.target:IsValid() && (!self.target:IsPlayer() || (self.target:IsPlayer() && self.target:Alive())) then
			local vel = self:GetVelocity():Angle()
			local vec1 = (self.target:GetPos()+self.target:OBBCenter()-self:GetPos()):Angle()
			local amt = self.MaxTurnSpeed*(CurTime()-self.lastupdate)*math.Clamp(CurTime()-self.Created,0,1)
			vel.p = math.ApproachAngle(vel.p,vec1.p,amt)
			vel.y = math.ApproachAngle(vel.y,vec1.y,amt)
			vel.r = math.ApproachAngle(vel.r,vec1.r,amt)
			self:GetPhysicsObject():SetVelocity(vel:Forward()*self.MaxSpeed)
		else
			self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity():GetNormalized()*self.MaxSpeed)
			self.target = NULL
		end
		self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity():GetNormalized()*self.MaxSpeed)
		self:SetLocalAngles(self:GetPhysicsObject():GetVelocity():GetNormalized():Angle())
		self.lastupdate = CurTime()
	end
end


function ENT:Initialize()
	self:SetModel("models/weapons/W_missile_closed.mdl")
	if SERVER then
		self.expl = false
		self.Entity:PhysicsInitBox(Vector(-1,-1,-1),Vector(1,1,1))
		self.Entity:SetCollisionBounds(Vector(-5,-5,-5),Vector(5,5,5))
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.lastupdate = CurTime()
		self.Created = CurTime()
		self:SetTrigger(true)
		self:GetPhysicsObject():EnableGravity(false)
		self:DrawShadow(false)
	else
		self.expl = false
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_NONE)
	end
end

function ENT:Use()
end

