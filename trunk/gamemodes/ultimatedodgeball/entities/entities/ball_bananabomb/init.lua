AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 9000 	// How much speed should it have when it spawns?
ENT.NumBounces 		  		= 8 	// How many bounces before it dissipates?
ENT.HitEffect 		    	= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "banana_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 2.1 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 40    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 250   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("physics/flesh/flesh_squishy_impact_hard2.wav")
ENT.DieSound                = Sound("physics/flesh/flesh_bloody_break.wav")

function ENT:Initialize()

	// Use the helibomb model
	util.PrecacheModel("models/props/cs_italy/bananna_bunch.mdl")
	self.Entity:SetModel("models/props/cs_italy/bananna_bunch.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	
	// Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	self:SetAngles( VectorRand():Angle() )
	
end

function ENT:OnRemove()

	if self.DieEffect then
		local ed = EffectData()
		ed:SetOrigin( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
		util.Effect( self.DieEffect, ed, true, true )
	end
	
	self:EmitSound( self.DieSound, 100, math.random(90,110) )
	
	for i=1,math.random(4,8) do
		local ball = ents.Create("ball_banana")
		ball:SetPos(self:GetPos())
		ball:SetOwner(self:GetOwner())
		ball:Spawn()
	end
	
end
