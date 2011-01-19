AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 10000 	// How much speed should it have when it spawns?
ENT.NumBounces 		    	= 99 	// How many bounces before it dissipates?
ENT.HitEffect 		    	= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "explosion_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 1 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "trail_dynamite" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 90    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 50   // How hard should the ball punch players?
ENT.HitSound		    	=  Sound("physics/plastic/plastic_box_impact_hard1.wav")
ENT.DieSound           	 	=  Sound("physics/plastic/plastic_box_impact_hard1.wav")

function ENT:Initialize()

	util.PrecacheModel("models/dav0r/tnt/tnt.mdl")
	self.Entity:SetModel("models/dav0r/tnt/tnt.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	self:SetAngles(VectorRand():Angle())
	
	if self.Trail then
		local ed = EffectData()
		ed:SetEntity( self.Entity )
		util.Effect( self.Trail, ed, true, true )
	end
	
	self.DieTimer = CurTime() + 10
	
	local burn = Sound("General.BurningObject")
	self.BurnSound = CreateSound(self, burn)
	
	self.BurnSound:Play()
	
end

function ENT:Think()
	if self.DieTimer < CurTime() then
		self.Detonate = true
		self.BurnSound:Stop()
	end
	if self.Detonate then
		self.Detonate = false
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
		self:Remove()
	end
end

function ENT:OnRemove()
	if self.DieEffect then
		local ed = EffectData()
		ed:SetOrigin( self.Entity:LocalToWorld(self.Entity:OBBCenter()) )
		util.Effect( self.DieEffect, ed, true, true )
	end
end

function ENT:PhysicsCollide( data, physobj )

	if data.HitEntity then
		if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() then
			if data.HitEntity:Team() != self:GetPlayer():Team() or data.HitEntity == self:GetPlayer() then
				local norm = data.HitNormal
				data.HitEntity:SetVelocity(norm * self.BouncePower + Vector(0,0,100))
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
	
	physobj:SetVelocity( TargetVelocity )
	
end