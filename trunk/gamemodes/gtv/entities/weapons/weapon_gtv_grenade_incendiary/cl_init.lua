SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Napalm Grenade"
SWEP.Slot = 3
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0
SWEP.AmmoCost = 25
SWEP.HoldType = "slam"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.Color = Color(255,255,255,255)
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_grenade_incendiary")
killicon.Add("gtv_grenade_incendiary","gtv/weapons/weapon_gtv_grenade_incendiary",SWEP.Color)

function SWEP:Shoot()
end