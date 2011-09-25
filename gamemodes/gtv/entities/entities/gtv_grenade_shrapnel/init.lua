AddCSLuaFile("cl_init.lua")
ENT.Author = "Ghor"
ENT.Type = "anim"
ENT.Base = "gtv_grenade_base"
ENT.Created = 0
ENT.FuseTime = 2
ENT.Model = "models/Items/grenadeAmmo.mdl"
ENT.Bullet = weapons.Get("weapon_gtv_base").Bullet
ENT.ParticleEffect = "gtv_shrapnade_rings"
PrecacheParticleSystem("gtv_explosion")
PrecacheParticleSystem("gtv_shrapnade_rings")

local proj = {}
	local Callback = function(self,tr)
						if !tr.Entity:IsValid() ||!tr.Entity:IsPlayer() then
							return
						end
						local dmg = DamageInfo()
						dmg:SetDamageType(DMG_BULLET)
						if self:GetOwner():IsValid() then
							dmg:SetAttacker(self:GetOwner())
						end
						if self:GetInflictor():IsValid() then
							dmg:SetInflictor(self:GetInflictor())
						end
						dmg:SetDamage(self.Damage)
						dmg:SetDamageForce(vector_origin*1)
						tr.Entity:TakeDamageInfo(dmg)
					end
	proj = GProjectile()
	proj:SetCallback(Callback)
	proj:SetBBox(Vector(-8,-8,-8),Vector(8,8,8))
	proj:SetPiercing(false)
	proj:SetGravity(vector_origin)
	proj:SetMask(MASK_SHOT)
	proj:SetLifetime(0.25)
	proj.Damage = 10
ENT.Bullet = proj

function ENT:Explode()
	local proj = self.Bullet
	local dir = Angle(0,0,0)
	proj:SetOwner(self:GetOwner())
	proj:SetInflictor(self)
	proj:SetFilter(self:GetOwner())
	proj:SetPos(self:GetPos()+Vector(0,0,32))
	proj.LagCompensated = false
	for i=1,36 do
		local edata = EffectData()
			edata:SetOrigin(self:GetPos()+Vector(0,0,32))
			edata:SetStart(dir:Forward()*1000)
			edata:SetEntity(self:GetOwner())
			edata:SetScale(0.5)
			util.Effect("ef_gtv_bullet",edata)
		proj:SetVelocity(dir:Forward()*1000)
		proj:Fire()
		dir.y = dir.y+10
	end
	proj.LagCompensated = true
	util.BlastDamage(self,self:GetOwner(),self:GetPos(),150,20)
	ParticleEffect("gtv_explosion",self:GetPos(),Angle(0,0,0),Entity(0))
	self:EmitSound("ambient/levels/labs/electric_explosion1.wav",100,200)
	self:Remove()
end