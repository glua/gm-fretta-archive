SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Shotgun"
SWEP.Slot = 1
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.LastFired = 0
SWEP.Cooldown = 0.5
SWEP.AmmoCost = 0
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "shotgun"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.Color = Color(255,255,0,255)
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_shotgun")
killicon.Add("weapon_gtv_shotgun","gtv/weapons/weapon_gtv_shotgun",SWEP.Color)

function SWEP:Shoot()
	local dir = self.Owner:GetAimVector():Angle()
	dir.y = dir.y-15
	local right = self.Owner:GetAimVector():Angle():Right()
	for i=1,7 do
		local edata = EffectData()
			edata:SetOrigin(self.Owner:GetShootPos())
			edata:SetStart(dir:Forward()*2000)
			edata:SetEntity(self.Owner)
			edata:SetScale(0.25)
			util.Effect("ef_gtv_bullet",edata)
		dir.y = dir.y+30/7
	end
	self.Owner:EmitSound("weapons/shotgun/shotgun_dbl_fire7.wav",100,180)
	self.Owner:EmitSound("weapons/shotgun/shotgun_cock.wav",100,160)
end