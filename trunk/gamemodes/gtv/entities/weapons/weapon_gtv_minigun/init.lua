AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0.05
SWEP.AmmoCost = 1
SWEP.HoldType = "ar2"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.ItemType = GTVITEM_MINIGUN
SWEP.Slot = SLOT_EXTRA
SWEP.PrintName = "Minigun"

function SWEP:Shoot()
	local proj = self.Bullet
	local dir = (self.Owner:GetAimVector()+VectorRand()*0.1):Normalize()
	ProjectileLagCompensation(self.Owner)
	local edata = EffectData()
		edata:SetOrigin(self.Owner:GetShootPos())
		edata:SetStart(dir*2000)
		edata:SetScale(0.25)
		edata:SetEntity(self.Owner)
		util.Effect("ef_gtv_bullet",edata)
	proj:SetOwner(self.Owner)
	proj:SetInflictor(self)
	proj:SetFilter(self.Owner)
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetVelocity(dir*2000)
	proj:Fire()
	self.Owner:EmitSound("weapons/ar2/ar2_altfire.wav",100,255)
	ProjectileLagCompensation(NULL)
end

local proj = {}
	local Callback = function(self,tr)
						local dmg = DamageInfo()
						dmg:SetDamageType(DMG_BULLET)
						if self:GetOwner():IsValid() then
							dmg:SetAttacker(self:GetOwner())
						end
						if self:GetInflictor():IsValid() then
							dmg:SetInflictor(self:GetInflictor())
						end
						dmg:SetDamage(self.Damage)
						dmg:SetDamageForce(vector_origin)
						if (tr.Entity:GetClass() != "func_breakable") then
							tr.Entity:TakeDamageInfo(dmg)
						else
							tr.Entity:TakeDamage(13,dmg:GetAttacker(),dmg:GetInflictor())
						end
					end
	proj = GProjectile()
	proj:SetCallback(Callback)
	proj:SetBBox(Vector(-8,-8,-8),Vector(8,8,8))
	proj:SetPiercing(false)
	proj:SetGravity(vector_origin)
	proj:SetMask(MASK_SHOT)
	proj:SetLifetime(0.25)
	proj.Damage = 13
SWEP.Bullet = proj