AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 200000 	// How much speed should it have when it spawns?
ENT.NumBounces 		    = 16 	// How many bounces before it dissipates?
ENT.HitEffect 		    = "hitsmoke" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    = "bigsmoke_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 3 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    = "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 90    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 50   // How hard should the ball punch players?
ENT.HitSound		    =  Sound("vehicles/v8/vehicle_impact_heavy2.wav")
ENT.DieSound            =  Sound("vehicles/v8/vehicle_impact_heavy1.wav")     

function ENT:Initialize()

	util.PrecacheModel("models/props_vehicles/car004a_physics.mdl")
	self.Entity:SetModel("models/props_vehicles/car004a_physics.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(150)
		phys:AddAngleVelocity(Angle(math.random(-20,20),math.random(-20,20),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	local ang = VectorRand():Angle()
	ang.p = 0
	ang.y = 0
	self:SetAngles( ang )
	
end
