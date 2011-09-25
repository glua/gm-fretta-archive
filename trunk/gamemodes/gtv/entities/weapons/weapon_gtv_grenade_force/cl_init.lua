SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Force Grenade"
SWEP.Slot = 3
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.LastFired = 0
SWEP.Cooldown = 1
SWEP.AmmoCost = 25
SWEP.HoldType = "slam"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.Color = Color(255,255,255,255)
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_grenade_force")
killicon.Add("gtv_grenade_force","gtv/weapons/weapon_gtv_grenade_force",SWEP.Color)

function SWEP:Shoot()
end