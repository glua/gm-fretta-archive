AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 		= 1200 	// How much speed should it have when it spawns?
ENT.NumBounces 				= 3 	// How many bounces before it dissipates?
ENT.HitEffect 				= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect				= "smoke_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 				= 1.2 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 					= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage              	= 30    // How much damage does the ball deal upon impact?
ENT.HitSound				= Sound("Rubber.BulletImpact")
ENT.DieSound        		= Sound("weapons/shotgun/shotgun_cock.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props/cs_italy/orange.mdl")
	self.Entity:SetModel("models/props/cs_italy/orange.mdl")
	
	self.Entity:PhysicsInitSphere( 6, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:ApplyForceCenter(self:GetOwner():GetAimVector() * self.InitialVelocity)
	end
	
	self.Entity:SetCollisionBounds( Vector( -6, -6, -6 ), Vector( 6, 6, 6 ) )
	
	for i=1,math.random(7,9) do
		local ball = ents.Create("ball_shotgunpellet")
		ball:SetPos(self:GetPos() + VectorRand() * 30)
		ball:SetOwner(self:GetOwner())
		ball:Spawn()
		ball:Activate()
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:ApplyForceCenter(VectorRand() * 80)
		end
	end
	
end