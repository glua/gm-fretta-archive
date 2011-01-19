AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	    = 9000 	// How much speed should it have when it spawns?
ENT.NumBounces 		  		= 99 	// How many bounces before it dissipates?
ENT.HitEffect 		   		= "" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect		    	= "explosion_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 	    	    = 1.05 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 		    		= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage                  = 40    // How much damage does the ball deal upon impact?
ENT.BouncePower             = 50   // How hard should the ball punch players?
ENT.HitSound		    	= Sound("ambient/creatures/teddy.wav")
ENT.DieSound                = Sound("buttons/blip2.wav")

function ENT:Initialize()

	util.PrecacheModel("models/props_c17/doll01.mdl")
	self.Entity:SetModel("models/props_c17/doll01.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(-200,200),math.random(-200,200),math.random(-200,200)))
		phys:ApplyForceCenter(self:GetPlayer():GetAimVector() * self.InitialVelocity)
	end
	
	self:SetAngles( VectorRand():Angle() )

end

function ENT:Think()

	if self.DetThink < CurTime() then
		if self.OldPos:Distance(self:GetPos()) < 25 then
			self.Detonate = CurTime() + 1
			self:EmitSound( self.DieSound )
			self.DetThink = CurTime() + 3
		else
			self.DetThink = CurTime() + 0.5
			self.OldPos = self:GetPos()
		end
	end
	
	if self.Detonate then
		if self.Detonate < CurTime() then
			self.Detonate = CurTime() + 10
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
end

function ENT:OnRemove()

	if self.DieEffect then
		local ed = EffectData()
		ed:SetOrigin( self.Entity:LocalToWorld(self.Entity:OBBCenter()) )
		util.Effect( self.DieEffect, ed, true, true )
	end
	
end

ENT.DetThink = 0
ENT.OldPos = Vector(0,0,0)
function ENT:PhysicsCollide( data, physobj )

	if self.HitEffect then
		local ed = EffectData()
		ed:SetOrigin( data.HitPos )
		ed:SetNormal( data.HitNormal ) 
		util.Effect( self.HitEffect, ed, true, true )
	end

	if data.HitEntity then
		if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() then
			if data.HitEntity:Team() != self:GetPlayer():Team() or data.HitEntity == self:GetPlayer() then
				local norm = data.HitNormal
				data.HitEntity:SetVelocity(norm * self.BouncePower + Vector(0,0,100))
				self:EmitSound( self.DieSound )
				self.Detonate = CurTime() + 3
			end
		end
	end
	
	if (data.Speed > 80 && data.DeltaTime > 0.2 ) then
		self.Entity:EmitSound( self.HitSound, 100, math.random(95,105) )
	end
	
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * self.Bounciness
	
	physobj:SetVelocity( TargetVelocity )
	
end