AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 900 	// How much speed should it have when it spawns?
ENT.NumBounces 		    	= 3 	// How many bounces before it dissipates?
ENT.HitEffect 		   	 	= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "skull_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 1.1 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "trail_skull" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 80    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 900   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("physics/concrete/concrete_impact_hard2.wav")
ENT.DieSound                = Sound("npc/stalker/go_alert2.wav")
ENT.KillBall            	= Sound("weapons/stunstick/stunstick_fleshhit1.wav")

function ENT:Initialize()

	util.PrecacheModel("models/gibs/hgibs.mdl")
	self.Entity:SetModel("models/gibs/hgibs.mdl")
	
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

ENT.Search = 0
function ENT:Think()
	if self.Search < CurTime() then
		self.Search = CurTime() + 0.2
		for k,v in pairs(ents.FindByClass("ball_*")) do
			if v:GetPlayer():Team() != self:GetPlayer():Team() then
				if self:GetPos():Distance(v:GetPos()) < 300 then
				
					local ed = EffectData()
					ed:SetStart(self:GetPos())
					ed:SetOrigin(v:GetPos())
					util.Effect( "skull_beam", ed, true, true )
					
					v:Remove()
					self:EmitSound(self.KillBall,100,math.random(90,110))
					
				end
			end
		end	
	end
end
