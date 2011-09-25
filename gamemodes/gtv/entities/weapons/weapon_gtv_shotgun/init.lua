AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0.5
SWEP.AmmoCost = 0
SWEP.Primary.Ammo = "pistol"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Slot = SLOT_PISTOL
SWEP.ItemType = GTVITEM_SHOTGUN
SWEP.Weight = 2
SWEP.PrintName = "Shotgun"

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
							tr.Entity:TakeDamage(5,dmg:GetAttacker(),dmg:GetInflictor())
						end
					end
	proj = GProjectile()
	proj:SetCallback(Callback)
	proj:SetBBox(Vector(-8,-8,-8),Vector(8,8,8))
	proj:SetPiercing(false)
	proj:SetGravity(vector_origin)
	proj:SetMask(MASK_SHOT)
	proj:SetLifetime(0.25)
	proj.Damage = 5
SWEP.Bullet = proj

function SWEP:Shoot()
	local proj = self.Bullet
	local dir = self.Owner:GetAimVector():Angle()
	dir.y = dir.y-15
	local right = self.Owner:GetAimVector():Angle():Right()
	proj:SetOwner(self.Owner)
	proj:SetInflictor(self)
	proj:SetFilter(self.Owner)
	proj:SetPos(self.Owner:GetShootPos())
	ProjectileLagCompensation(self.Owner)
	for i=1,7 do
		local edata = EffectData()
			edata:SetOrigin(self.Owner:GetShootPos())
			edata:SetStart(dir:Forward()*2000)
			edata:SetEntity(self.Owner)
			edata:SetScale(0.25)
			util.Effect("ef_gtv_bullet",edata)
		proj:SetVelocity(dir:Forward()*2000)
		proj:Fire()
		dir.y = dir.y+30/7
	end
	self.Owner:EmitToAllButSelf("weapons/shotgun/shotgun_dbl_fire7.wav",100,180)
	self.Owner:EmitToAllButSelf("weapons/shotgun/shotgun_cock.wav",100,160)
	ProjectileLagCompensation(NULL)
end

function SWEP:SecondaryAttack()
	//print("CurTime:"..CurTime())
	//self.Owner:LagCompensation(true)
	//print("Hopefully this is a lower value:"..CurTime())
	//self.Owner:LagCompensation(false)
	//print(Entity(1):Ping())
end

//CreateClientConVar("lasttime",CurTime(),false,true)

