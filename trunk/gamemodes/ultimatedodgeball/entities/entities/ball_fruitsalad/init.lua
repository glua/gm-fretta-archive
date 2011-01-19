AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 2000 	// How much speed should it have when it spawns?
ENT.NumBounces 		    	= 3 	// How many bounces before it dissipates?
ENT.HitEffect 		    	= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "rainbow_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 0.9 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 50    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 250   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("physics/flesh/flesh_squishy_impact_hard2.wav")
ENT.DieSound                = Sound("physics/flesh/flesh_bloody_break.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props_junk/watermelon01.mdl")
	self.Entity:SetModel("models/props_junk/watermelon01.mdl")
	
	self.Entity:PhysicsInitSphere( 8, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	self.Entity:SetCollisionBounds( Vector( -8, -8, -8 ), Vector( 8, 8, 8 ) )
	
	self:SetAngles(VectorRand():Angle())
	
end

function ENT:OnRemove()

	if self.DieEffect then
		local ed = EffectData()
		ed:SetOrigin( self.Entity:LocalToWorld(self.Entity:OBBCenter()) )
		util.Effect( self.DieEffect, ed, true, true )
	end
	
	self:EmitSound(self.DieSound,100,math.random(90,110))
	
	for i=1,math.random(10,15) do
		local ball = ents.Create( table.Random({"ball_banana","ball_orange"}) )
		ball:SetPos(self:GetPos())
		ball:SetOwner(self:GetOwner())
		ball:Spawn()
	end
	
end
