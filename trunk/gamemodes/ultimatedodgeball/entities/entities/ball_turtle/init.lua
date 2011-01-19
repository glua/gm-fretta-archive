AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 2000 	// How much speed should it have when it spawns?
ENT.NumBounces 		    	= 10 	// How many bounces before it dissipates?
ENT.HitEffect 		   	 	= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "smoke_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 1.1 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 60    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 200   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("npc/headcrab/attack3.wav")
ENT.DieSound                = Sound("npc/headcrab/headbite.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props/de_tides/vending_turtle.mdl")
	self.Entity:SetModel("models/props/de_tides/vending_turtle.mdl")
	
	self.Entity:PhysicsInitSphere( 6, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end

	self.Entity:SetCollisionBounds( Vector( -6, -6, -6 ), Vector( 6, 6, 6 ) )
	
	self:SetAngles(VectorRand():Angle())
	
end

function ENT:PhysicsCollide( data, physobj )

	if data.HitEntity then
		if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() then
			if data.HitEntity:Team() != self:GetPlayer():Team() or data.HitEntity == self:GetPlayer() then
				local norm = data.HitNormal
				data.HitEntity:SetVelocity(norm * self.BouncePower + Vector(0,0,100))
				data.HitEntity:TakeDamage(self.Damage,self:GetPlayer())
				self.RemoveMe = true
			end
		end
	end
	
	// Play sound on bounce
	if (data.Speed > 80 && data.DeltaTime > 0.2 ) then
		self.Entity:EmitSound( self.HitSound, 100, math.random(95,105) )
	end
	
	// Bounce like a crazy bitch - the default ball
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * self.Bounciness
	
	physobj:SetVelocity( TargetVelocity + VectorRand() * 100 )
	
	self.NumBounces = self.NumBounces - 1
	if self.NumBounces == 0 then
		self:Remove()
	end
	
end