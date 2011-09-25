AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.target = NULL
PrecacheParticleSystem("gtv_rocket_trail")

function ENT:OnTakeDamage()
end

function ENT:PhysicsCollide()
	self:SetMoveType(MOVETYPE_NONE)
	if !self.expl then
		timer.Simple(0,self.Explode,self)
	end
end 

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:Touch(hitent)
	if (hitent:GetSolid() != SOLID_NONE) && (hitent:GetSolid() != SOLID_VPHYSICS) && (hitent != self:GetOwner()) && !self.expl then
		self:Explode(hitent)
	end
end

function ENT:Think()
end

function ENT:Explode(hitent)
	if !self.expl && self:IsValid() then
		self.expl = true
		if self.crit then
			self.damagemul = 3
			self.blastmul = 2
		else
			self.damagemul = 2
			self.blastmul = 1
		end
		local didhit = false
		local knockback = {}
		knockback = ents.FindInSphere(self:GetPos(),100)
		if table.getn(knockback) != 0 then
			local num = table.getn(knockback)
					for i=1,num,1 do
							if knockback[i].Entity and !knockback[i].Entity:IsWorld() and knockback[i]:GetCollisionGroup() !=0 then
									local tracek = {}
									tracek.start = self:GetPos()+Vector(0,0,5)
									tracek.endpos = knockback[i].Entity:GetPos()
									tracek.mask = MASK_NONE
									tracek.filter = self.Entity
									local trace = util.TraceLine(tracek)

									if knockback[i]:GetPhysicsObject():IsValid() then
										knockback[i]:GetPhysicsObject():Wake()
										knockback[i].Entity:SetGroundEntity(nil)
										knockback[i].Entity:SetVelocity(knockback[i].Entity:GetVelocity()*0.1+Vector(0,0,100)+(tracek.endpos+Vector(0,0,20)-tracek.start):GetNormalized()*500*self.blastmul)
										didhit = true
									end
							end
					end
			if didhit and self.crit then
				WorldSound("player/crit_hit"..math.random(2,5)..".wav",self:GetPos(),125,100)
				self.criticalhit = true
			end
		end
		util.ScreenShake(self:GetPos(),100,1,1,500)
		util.BlastDamage(self,self:GetOwner(),self:GetPos(),64,60)
		ParticleEffect("gtv_explosion",self:GetPos(),Angle(0,0,0),Entity(0))
		self:EmitSound("weapons/ar2/fire1.wav",100,35)
		self:Remove()
		
	end
	
end

function ENT:OnRemove()
end