AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 800 	// How much speed should it have when it spawns?
ENT.NumBounces 		   		= 2 	// How many bounces before it dissipates?
ENT.HitEffect 		    	= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		   		= "banana_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 0.7 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 50    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 250   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("physics/flesh/flesh_squishy_impact_hard2.wav")
ENT.DieSound                = Sound("physics/flesh/flesh_squishy_impact_hard3.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props/cs_italy/bananna.mdl")
	self.Entity:SetModel("models/props/cs_italy/bananna.mdl")
	
	self.Entity:PhysicsInitSphere( 5, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(VectorRand() * self.InitialVelocity)
	end
	
	self.Entity:SetCollisionBounds( Vector( -5, -5, -5 ), Vector( 5, 5, 5 ) )
	
	self:SetAngles( VectorRand():Angle() )
	
end
