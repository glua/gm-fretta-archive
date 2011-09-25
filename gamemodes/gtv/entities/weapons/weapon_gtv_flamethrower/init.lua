AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "smg"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.Slot = SLOT_EXTRA
SWEP.AmmoCost = 1
SWEP.CoolDown = 0.05
SWEP.ItemType = GTVITEM_FLAMETHROWER
PrecacheParticleSystem("gtv_flamethrower")
SWEP.PrintName = "Flamethrower"

local proj = {}
	local Callback = function(self,tr)
						local ent = tr.Entity
						if ent && ent:IsValid() then
							ent:Ignite(5,0)
							ent.IgnitedBy = self:GetOwner()
							local dmg = DamageInfo()
							dmg:SetDamage((self.deathtime-CurTime())*15)
							dmg:SetDamageForce(tr.Normal*500)
							dmg:SetDamagePosition(tr.HitPos)
							if self:GetOwner():IsValid() then
								dmg:SetAttacker(self:GetOwner())
							end
							if self:GetInflictor():IsValid() then
								dmg:SetInflictor(self:GetInflictor())
							end
							dmg:SetDamageType(DMG_DIRECT)
							ent:TakeDamageInfo(dmg)
						end
					end
	proj = GProjectile()
	proj:SetCallback(Callback)
	proj:SetBBox(Vector(-8,-8,-8),Vector(8,8,8))
	proj:SetPiercing(false)
	proj:SetGravity(vector_origin)
	proj:SetMask(MASK_SHOT)
	proj:SetLifetime(1)
	proj:SetMaxRange(350)
SWEP.Bullet = proj

local tracep = {}
tracep.mask = MASK_SHOT
tracep.mins = Vector(-16,-16,-16)
tracep.maxs = Vector(16,16,16)

function SWEP:Shoot()
	local proj = self.Bullet
	if !self.toggleeffect then
		local edata = EffectData()
		edata:SetOrigin(self.Owner:GetShootPos())
		edata:SetEntity(self)
		self:AddToggleEffect("ef_gtv_fthrow",edata)
	end
	proj:SetOwner(self.Owner)
	proj:SetInflictor(self)
	proj:SetFilter(self.Owner)
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetVelocity(self.Owner:GetAimVector()*600+self.Owner:GetVelocity())
	proj:Fire()
end

function SWEP:Think()
	if !self.Owner:KeyDown(IN_ATTACK) || (self.Weapon:Ammo1() <= 0) then
		self:KillEffect()
	end
end

function SWEP:Holster()
	self:KillEffect()
	return true
end
