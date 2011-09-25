SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Bee Gun"
SWEP.Slot = 2
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 2
SWEP.AmmoCost = 100
SWEP.HoldType = "rpg"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_beegun")
SWEP.Color = Color(255,153,0,255)
killicon.Add("weapon_gtv_beegun","gtv/weapons/weapon_gtv_beegun",SWEP.Color)
killicon.Add("gtv_projectile_bees","gtv/weapons/weapon_gtv_beegun",SWEP.Color)

function SWEP:Shoot()
end