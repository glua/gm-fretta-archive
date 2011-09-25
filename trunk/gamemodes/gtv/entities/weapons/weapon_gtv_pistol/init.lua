AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "pistol"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Cooldown = 0.2
SWEP.Slot = SLOT_PISTOL
SWEP.Weight = 2
SWEP.PrintName = "Pistol"

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
							tr.Entity:TakeDamage(15,dmg:GetAttacker(),dmg:GetInflictor())
						end
					end
	proj = GProjectile()
	proj:SetCallback(Callback)
	proj:SetBBox(Vector(-8,-8,-8),Vector(8,8,8))
	proj:SetPiercing(false)
	proj:SetGravity(vector_origin)
	proj:SetMask(MASK_SHOT)
	proj:SetLifetime(0.25)
	proj.Damage = 15
SWEP.Bullet = proj

function SWEP:Shoot()
	local proj = self.Bullet
	ProjectileLagCompensation(self.Owner)
	local edata = EffectData()
		edata:SetOrigin(self.Owner:GetShootPos())
		edata:SetStart(self.Owner:GetAimVector()*4000)
		edata:SetScale(0.25)
		edata:SetEntity(self.Owner)
		util.Effect("ef_gtv_bullet",edata)
	proj:SetOwner(self.Owner)
	proj:SetInflictor(self)
	proj:SetFilter(self.Owner)
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetVelocity(self.Owner:GetAimVector()*4000)
	proj:Fire()
	self.Owner:EmitToAllButSelf("weapons/smg1/smg1_fire1.wav",60,200)
	ProjectileLagCompensation(NULL)
end