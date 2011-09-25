AddCSLuaFile("cl_init.lua")
ENT.Author = "Ghor"
ENT.Type = "anim"
ENT.Base = "gtv_grenade_base"
ENT.Created = 0
ENT.FuseTime = 1
ENT.Model = "models/Items/grenadeAmmo.mdl"
ENT.ParticleEffect = "gtv_forcenade_rings"
PrecacheParticleSystem("gtv_ring_large_shockwave")
PrecacheParticleSystem("gtv_forcenade_rings")

function ENT:Explode()
	ParticleEffect("gtv_explosion",self:GetPos(),Angle(0,0,0),Entity(0))
	ParticleEffect("gtv_ring_large_shockwave",self:GetPos(),Angle(0,0,0),Entity(0))
	local tab = ents.FindInSphere(self:GetPos(),500)
	//PrintTable(tab)
	for k,v in ipairs(tab) do
		if v:GetPhysicsObject():IsValid() then
			local dir = (v:GetPos()-self:GetPos())
			local length = dir:Length()
			dir:Normalize()
			dir = dir+Vector(0,0,0.5)
			if v:IsPlayer() || v:IsNPC() then
				v:SetGroundEntity(NULL)
				local vel = dir*(500-length)*10
				vel.z = 5
				v:SetVelocity(vel)		
				//v:GetPhysicsObject():SetVelocity(dir*(150-length)*50)
				v.ThrownBy = self:GetOwner()
			else
				v:GetPhysicsObject():SetVelocity(dir*(500-length))
				v:SetPhysicsAttacker(self:GetOwner())
			end
		end
	end
	self:EmitSound("weapons/357/357_fire2.wav",100,45)
	util.BlastDamage(self,self:GetOwner(),self:GetPos(),150,20)
	self:Remove()
end