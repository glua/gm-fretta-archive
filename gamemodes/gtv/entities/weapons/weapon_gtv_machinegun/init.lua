AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "smg"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.Slot = SLOT_PISTOL
SWEP.ItemType = GTVITEM_MACHINEGUN
SWEP.Weight = 2
SWEP.PrintName = "Machinegun"

function SWEP:Shoot()
	local proj = self.Bullet
	ProjectileLagCompensation(self.Owner)
	local edata = EffectData()
		edata:SetOrigin(self.Owner:GetShootPos())
		edata:SetStart(self.Owner:GetAimVector()*2000)
		edata:SetScale(0.25)
		edata:SetEntity(self.Owner)
		util.Effect("ef_gtv_bullet",edata)
	proj:SetOwner(self.Owner)
	proj:SetInflictor(self)
	proj:SetFilter(self.Owner)
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetVelocity(self.Owner:GetAimVector()*2000)
	proj:Fire()
	self.Owner:EmitToAllButSelf("weapons/smg1/smg1_fire1.wav",100,200)
	ProjectileLagCompensation(NULL)
end