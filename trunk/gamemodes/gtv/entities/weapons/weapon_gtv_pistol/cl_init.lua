SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Pistol"
SWEP.Slot = 1
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "smg"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Cooldown = 0.2
SWEP.Color = Color(255,255,0,255)
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_pistol")
killicon.Add("weapon_gtv_pistol","gtv/weapons/weapon_gtv_pistol",SWEP.Color)

function SWEP:Shoot()
	local edata = EffectData()
	edata:SetOrigin(self.Owner:GetShootPos())
	edata:SetStart(self.Owner:GetAimVector()*2000)
	edata:SetEntity(self.Owner)
	edata:SetScale(0.25)
	util.Effect("ef_gtv_bullet",edata)
	self.Owner:EmitSound("weapons/smg1/smg1_fire1.wav",60,200)
end