SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Rocket Launcher"
SWEP.Slot = 2
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0.5
SWEP.AmmoCost = 10
SWEP.HoldType = "rpg"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_rocketlauncher")
SWEP.Color = Color(255,153,0,255)
killicon.Add("weapon_gtv_rocketlauncher","gtv/weapons/weapon_gtv_rocketlauncher",SWEP.Color)
killicon.Add("gtv_projectile_rocket","gtv/weapons/weapon_gtv_rocketlauncher",SWEP.Color)

function SWEP:Shoot()
end