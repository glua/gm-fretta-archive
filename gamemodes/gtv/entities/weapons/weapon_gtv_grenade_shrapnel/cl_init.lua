SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Shrapnel Grenade"
SWEP.Slot = 3
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 1
SWEP.AmmoCost = 25
SWEP.HoldType = "slam"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.Color = Color(255,255,255,255)
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_grenade_shrapnel")
killicon.Add("gtv_grenade_shrapnel","gtv/weapons/weapon_gtv_grenade_shrapnel",SWEP.Color)
killicon.Add("gtv_grenade_shrapnel_ref","gtv/weapons/weapon_gtv_grenade_shrapnel",SWEP.Color)

function SWEP:Shoot()
end