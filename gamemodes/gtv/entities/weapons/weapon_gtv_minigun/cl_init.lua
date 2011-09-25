SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Minigun"
SWEP.Slot = 2
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0.05
SWEP.AmmoCost = 1
SWEP.HoldType = "ar2"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.Color = Color(255,153,0,255)
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_minigun")
killicon.Add("weapon_gtv_minigun","gtv/weapons/weapon_gtv_minigun",SWEP.Color)
SWEP.Weight = 3

function SWEP:Shoot()
	local dir = (self.Owner:GetAimVector()+VectorRand()*0.1):Normalize()
	//self.Owner:EmitSound("weapons/ar1/ar1_dist1.wav",100,200)
	local edata = EffectData()
	edata:SetOrigin(self.Owner:GetShootPos())
		edata:SetStart(dir*2000)
		edata:SetEntity(self.Owner)
		edata:SetScale(0.25)
	util.Effect("ef_gtv_bullet",edata)
	self.Owner:EmitSound("weapons/ar2/ar2_altfire.wav",100,255)
end