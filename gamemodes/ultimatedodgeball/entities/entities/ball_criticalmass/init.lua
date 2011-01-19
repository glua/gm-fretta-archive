AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 500 	// How much speed should it have when it spawns?
ENT.NumBounces 		    	= 2 	// How many bounces before it dissipates?
ENT.HitEffect 		    	= "hitmass" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "mass_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 1.2 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		   			= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 70    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 400   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("weapons/physcannon/energy_sing_flyby2.wav")
ENT.DieSound                = Sound("weapons/physcannon/energy_sing_flyby1.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props/cs_italy/orange.mdl")
	self.Entity:SetModel("models/props/cs_italy/orange.mdl")
	
	self.Entity:PhysicsInitSphere( 6, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	self.Entity:SetCollisionBounds( Vector( -6, -6, -6 ), Vector( 6, 6, 6 ) )
	
	self:SetColor(0,0,0,255)
	self.Suck = 0
	
end

function ENT:Think()
	if self.Suck < CurTime() then
		self.Suck = CurTime() + 0.1
		local tbl = ents.FindByClass("ball_*")
		tbl = table.Add(tbl,player.GetAll())
		for k,v in pairs(tbl) do
			if v:GetPos():Distance(self:GetPos()) < 700 then
				local dir = (self:GetPos() - v:GetPos()):Normalize()
				if v:IsPlayer() then
					if v != self:GetPlayer() then
						v:SetVelocity(dir * 300 + Vector(0,0,50))
					end
				else
					local phys = v:GetPhysicsObject()
					if phys and phys:IsValid() then
						phys:ApplyForceCenter(dir * 300)
					end
				end
			end
		end
	end
end
