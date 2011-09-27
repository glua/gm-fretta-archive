AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ('shared.lua')

local Bounce_Sound = Sound ("physics/concrete/rock_impact_hard4.wav")

function ENT:Initialize()
	self.Entity:SetModel ("models/Items/grenadeAmmo.mdl")
	--self.Entity:PhysicsInitSphere (16, "metal_bouncy")
	self:PhysicsInit (SOLID_VPHYSICS)
	self:SetMoveType (MOVETYPE_VPHYSICS)
	self:SetSolid (SOLID_VPHYSICS)
	
	// Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		--phys:SetDamping (1, 0.2)
		--phys:AddAngleVelocity (VectorRand() * 360)
	end
	
	// Set collision bounds exactly
	--self.Entity:SetCollisionBounds (Vector()*-16, Vector()*16)
	
	self.ExplodeTime = CurTime() + self.FuseLength
	self.Entity:SetNetworkedFloat ("ExplodeTime", self.ExplodeTime)	

	self.SpriteTrail = util.SpriteTrail( self, 0, Color(255, 0, 0), true, 64, 0, 2, 0, "sprites/bluelaser1.vmt" )
end

function ENT:Think()
	if self.ExplodeTime > CurTime() then return end
	self:Explode()
end

function ENT:Explode()
	if self.Exploded then return end
	
	self.Exploded = true
	
	self.SpriteTrail:SetParent (NULL)
	
	SafeRemoveEntityDelayed (self.SpriteTrail, 2)
	
	--GMDM_Explosion_Electric( self.Entity:GetPos(), self.Entity:GetOwner(), self.Entity, 110, 512, 1 )
	
	local effectdata = EffectData()
	effectdata:SetOrigin (self.Entity:GetPos())
	effectdata:SetStart (self.Entity:GetPos())
	util.Effect("Explosion", effectdata)
	util.BlastDamage (self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 300, 70)
	
	self.Entity:Remove()
end

--[[function ENT:PhysicsCollide (data, physobj)
	if data.Speed > 80 && data.DeltaTime > 0.2 then
		self.Entity:EmitSound (Bounce_Sound, 100)
	end
	
	local LastSpeed = data.OurOldVelocity:Length()
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max (NewVelocity:Length(), LastSpeed)
	local TargetVelocity = NewVelocity * LastSpeed * 0.5
	physobj:SetVelocity (TargetVelocity)
end]]