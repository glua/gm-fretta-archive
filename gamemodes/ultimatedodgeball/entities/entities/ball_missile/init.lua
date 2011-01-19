AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	= 1000 	// How much speed should it have when it spawns?
ENT.NumBounces 		    = 1 	// How many bounces before it dissipates?
ENT.HitEffect 		    = "hitsmoke" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    = "explosion_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	        = 1.0 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		        = "trail_rocketsmoke" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage              = 60    // How much damage does the ball deal upon impact?
ENT.BouncePower         = 1000   // How hard should the ball punch players?
ENT.HitSound		    = Sound("weapons/c4/c4_exp_deb1.wav")
ENT.DieSound            = Sound("weapons/c4/c4_exp_deb2.wav")
ENT.Launch              = Sound("weapons/stinger_fire1.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props_junk/propane_tank001a.mdl")
	self.Entity:SetModel("models/props_junk/propane_tank001a.mdl")
	
	self.Entity:PhysicsInitSphere( 10, "metal_bouncy" )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	self.Entity:SetCollisionBounds( Vector( -10, -10, -10 ), Vector( 10, 10, 10 ) )
	
	self.Entity:SetAngles(self.Entity:GetPlayer():GetAimVector():Angle() + Angle(90,0,0))
	
	if self.Trail then
		local ed = EffectData()
		ed:SetEntity( self.Entity )
		util.Effect( self.Trail, ed, true, true )
	end
	
	self:EmitSound( self.Launch, 100, math.random(90,110) )
	
end

function ENT:OnRemove()

	if self.DieEffect then
		local ed = EffectData()
		ed:SetOrigin( self.Entity:LocalToWorld(self.Entity:OBBCenter()) )
		util.Effect( self.DieEffect, ed, true, true )
	end
	
	self:EmitSound( self.DieSound, 100, math.random(90,110) )
	
	local tbl = ents.FindByClass("ball_*")
	tbl = table.Add(tbl,player.GetAll())
	
	for k,v in pairs(tbl) do
		if v:GetPos():Distance(self:GetPos()) < 450 then
			v:TakeDamage(self.Damage,self:GetPlayer())
			if not v:IsPlayer() then
				local phys = v:GetPhysicsObject()
				if phys:IsValid() then
					local dir = (v:GetPos() - self:GetPos()):Normalize()
					phys:ApplyForceCenter(dir * ((self.Damage^2) * (phys:GetMass()/2)))
				end
			else
				local dir = (v:GetPos() - self:GetPos()):Normalize()
				v:SetVelocity(dir * 500)
			end
		end
	end	
	
	util.ScreenShake( self:GetPos(), math.Rand(2,5),220, math.random(3,6), 650 ) 
	
end
