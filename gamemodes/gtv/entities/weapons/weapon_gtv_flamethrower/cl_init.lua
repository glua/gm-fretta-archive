SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Flamethrower"
SWEP.Slot = 2
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "smg"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.AmmoCost = 1
SWEP.CoolDown = 0.1
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_flamethrower")
SWEP.Color = Color(255,153,0,255)
killicon.Add("weapon_gtv_flamethrower","gtv/weapons/weapon_gtv_flamethrower",SWEP.Color)
killicon.Add("entityflame","gtv/weapons/weapon_gtv_flamethrower",SWEP.Color)

function SWEP:Shoot()
end