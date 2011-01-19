AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 800 	// How much speed should it have when it spawns?
ENT.NumBounces 		    	= 6 	// How many bounces before it dissipates?
ENT.HitEffect 		    	= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "rainbow_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 0.9 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "trail_rainbow" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 70    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 500   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("weapons/grenade/tick1.wav")
ENT.DieSound                = Sound("weapons/physcannon/energy_sing_explosion2.wav")

function ENT:Initialize()

	// Use the helibomb model
	util.PrecacheModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	
	// Dont use the model physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 16, "metal_bouncy" )
	
	self:StartMotionController()
	
	// Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	
	self:SetAngles(VectorRand():Angle())
	
	if self.Trail then
		local ed = EffectData()
		ed:SetEntity( self.Entity )
		util.Effect( self.Trail, ed, true, true )
	end
	
	local closest = 99999
	for k,v in pairs(player.GetAll()) do
		if v:Team() != self:GetPlayer():Team() then
			if self:GetPos():Distance(v:GetPos()) < closest then
				closest = self:GetPos():Distance(v:GetPos())
				self.Target = v
			end
		end
	end	
	
end

ENT.Home = 0
function ENT:Think()
	if self.Home < CurTime() then
		self.Home = CurTime() + 0.5
		local closest = 99999
		for k,v in pairs(player.GetAll()) do
			if v:Team() != self:GetPlayer():Team() and v:Alive() then
				if self:GetPos():Distance(v:GetPos()) < closest then
					closest = self:GetPos():Distance(v:GetPos())
					self.Target = v
				end
			end
		end	
	end
end

function ENT:PhysicsSimulate(phys, frametime)
	phys:Wake()
	if self.Target then 
		if self.Target:IsValid() and self.Target != NULL then
			local dist = self.Target:GetPos():Distance(self:GetPos())
			if dist < 400 then
				local dir = (self:GetPos() - self.Target:GetPos()):Normalize()
				phys:ApplyForceCenter((dir * (math.Clamp(dist / 10,20,400) * -1)))
			end
		end
	end
end
