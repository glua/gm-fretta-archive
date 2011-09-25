AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 10 )
	ent:Spawn()
	ent:Activate()	
	
	return ent

end

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self.BuildTime = 15
	
end

function ENT:SetType( n, pl, raise )

	local types = {
		[1] = { 
			model = "models/devin/barricade_small.mdl",
			health = 250,
			buildtime = 10,
			height = 102.780,
			},
		[2] = {
			model = "models/devin/barricade_medium.mdl",
			health = 500,
			buildtime = 20,
			height = 102.780,
			},
		[3]  = {
			model = "models/devin/barricade_large.mdl",
			health = 1000,
			buildtime = 30,
			height = 102.780,
			raiseup = 0,
		},
	}
	
	if !types[n] then return end
	local to_set = types[n]
	self.Entity:SetModel(to_set.model)
	self.Entity:SetNWInt("Health",to_set.health)
	self.Entity:SetNWInt("MaxHealth",to_set.health)
	self.Entity:SetNWInt("Height",to_set.height)
	self.Entity:SetNWInt("RaiseUp",raise)
	self.HealthPts = 1
	self.BuildTime =to_set.buildtime
	
	self.Entity:SetNWInt("Team",pl:Team())
	self.Entity:SetNWInt("BuildTime",self.BuildTime)
	self.Entity:SetNWInt("MaxBuild",self.BuildTime)

	hook.Add("ShouldCollide",self.Entity:EntIndex().."collide",function(e1,e2)
		if (e1 == self.Entity || e2 == self.Entity) && (e1:IsPlayer() || e2:IsPlayer()) && self:GetNWInt("BuildTime") > 0.1 then return false end
	end)
			
	// ERROR: HEALTH UPDATING IS FAIL?
	local rate = self.BuildTime / to_set.height 
	timer.Create("updateBarrier"..self.Entity:EntIndex(),rate,self.BuildTime / rate,function()
		if self.Entity && self.Entity:IsValid() then
			local n = self.Entity:GetNWInt("BuildTime") - rate
			self.HealthPts = math.Clamp(self.HealthPts + to_set.health / (self.BuildTime /rate),0,to_set.health)
			self.Entity:SetNWInt("BuildTime",n)
			if n <= rate then 
				self.Entity:SetSolid(SOLID_VPHYSICS) 
				self.HealthPts = to_set.health
			end
			self.Entity:SetNWInt("Health",self.HealthPts)
		end
	end)
end

function ENT:OnTakeDamage( dmg )
	if dmg:GetAttacker():Team() == self.Entity:GetNWInt("Team") then return end

	if self.Entity:GetNWInt("BuildTime") > 0.2 then self.HealthPts = self.HealthPts - dmg:GetDamage() * 5
	else self.HealthPts = self.HealthPts - dmg:GetDamage() / 2 end
	
	self.Entity:SetNWInt("Health",self.HealthPts)
	
	if self.HealthPts <= 0 then
		// FX Here?
		self.Entity:Remove()
	end
end

function ENT:Think()


end

function ENT:OnRemove()
	hook.Remove("ShouldCollide",self.Entity:EntIndex().."collide")
end







