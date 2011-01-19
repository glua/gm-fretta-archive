AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	= 2000 	// How much speed should it have when it spawns?
ENT.NumBounces 		    = 4 	// How many bounces before it dissipates?
ENT.HitEffect 		    = "hitgrav" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    = "grav_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	        = 1.0 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		        = "trail_rings" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage              = 60    // How much damage does the ball deal upon impact?
ENT.BouncePower         = 300   // How hard should the ball punch players?
ENT.HitSound		    = Sound("npc/roller/mine/rmine_taunt1.wav")
ENT.DieSound            = Sound("ambient/levels/citadel/weapon_disintegrate2.wav")

function ENT:Initialize()

	util.PrecacheModel("models/dav0r/hoverball.mdl")
	self.Entity:SetModel("models/dav0r/hoverball.mdl")
	
	self.Entity:PhysicsInitSphere( 10, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	self.Entity:SetCollisionBounds( Vector( -10, -10, -10 ), Vector( 10, 10, 10 ) )
	
	local ed = EffectData()
	ed:SetEntity( self.Entity )
	util.Effect( self.Trail, ed, true, true )
	
end
