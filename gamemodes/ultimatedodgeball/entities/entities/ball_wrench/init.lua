AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 5000 	// How much speed should it have when it spawns?
ENT.NumBounces 		    	= 2 	// How many bounces before it dissipates?
ENT.HitEffect 		    	= "hitsparks" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "sparks_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 0.8 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 90    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 100   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("weapons/crowbar/crowbar_impact1.wav")
ENT.DieSound                = Sound("weapons/crowbar/crowbar_impact2.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props_c17/tools_wrench01a.mdl")
	self.Entity:SetModel("models/props_c17/tools_wrench01a.mdl")
	
	self.Entity:PhysicsInitSphere( 4, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end

	self.Entity:SetCollisionBounds( Vector( -4, -4, -4 ), Vector( 4, 4, 4 ) )
	
	self:SetAngles(VectorRand():Angle())
	
end
