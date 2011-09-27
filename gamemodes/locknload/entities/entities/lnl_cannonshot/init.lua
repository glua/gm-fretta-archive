AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ('shared.lua')

local Bounce_Sound = Sound ("physics/concrete/rock_impact_hard4.wav")

function ENT:Initialize()
	self.Entity:SetModel ("models/Items/AR2_Grenade.mdl")
	self.Entity:PhysicsInitSphere (8, "metal_bouncy")
	
	// Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetDamping (0, 0)
	end
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds (Vector()*-8, Vector()*8)
	
	self.NoMoreBounceTime = CurTime() + self.BouncableDuration
	self.ExplodeTime = CurTime() + self.FuseLength
	--self.Entity:SetNetworkedFloat ("ExplodeTime", self.ExplodeTime)
end

function ENT:Think()
	if self.ExplodeTime > CurTime() then return end
	self:Explode()
end

function ENT:Explode()
	if self.Exploded then return end
	
	self.Exploded = true
	
	--GMDM_Explosion_Electric( self.Entity:GetPos(), self.Entity:GetOwner(), self.Entity, 110, 512, 1 )
	
	local effectdata = EffectData()
	effectdata:SetOrigin (self.Entity:GetPos())
	effectdata:SetStart (self.Entity:GetPos())
	util.Effect("Explosion", effectdata)
	util.BlastDamage (self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), self.Radius or 2500, self.Damage or 400)
	
	self.Entity:Remove()
end

function ENT:PhysicsCollide (data, physobj)
	if self.NoMoreBounceTime < CurTime() then
		self:Explode()
		return
	end
	
	if data.Speed > 80 && data.DeltaTime > 0.2 then
		self.Entity:EmitSound (Bounce_Sound, 100)
	end
	
	local LastSpeed = data.OurOldVelocity:Length()
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max (NewVelocity:Length(), LastSpeed)
	local TargetVelocity = NewVelocity * LastSpeed * 0.9
	physobj:SetVelocity (TargetVelocity)
	self:SetAngles (NewVelocity:Angle())
end