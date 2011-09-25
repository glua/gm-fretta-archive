AddCSLuaFile("cl_init.lua")
ENT.Author = "Ghor"
ENT.Type = "anim"
ENT.Base = "gtv_grenade_base"
ENT.Created = 0
ENT.FuseTime = 2
ENT.Model = "models/Items/grenadeAmmo.mdl"
PrecacheParticleSystem("gtv_explosion_r300")

function ENT:Explode()
	util.BlastDamage(self,self:GetOwner(),self:GetPos(),150,20)
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),200)) do
		if v:GetPhysicsObject():IsValid() then
			v:Ignite((200-v:GetPos():Distance(self:GetPos()))/20)
			v.IgnitedBy = self:GetOwner()
		end
	end
	self:EmitSound("ambient/fire/gascan_ignite1.wav")
	ParticleEffect("gtv_explosion_r300",self:GetPos(),Angle(0,0,0),Entity(0))
	self:Remove()
end