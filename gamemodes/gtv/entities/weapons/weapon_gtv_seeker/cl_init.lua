SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Ion-U Cannon"
SWEP.Slot = 2
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0.1
SWEP.AmmoCost = 2
SWEP.HoldType = "rpg"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_seeker")
SWEP.Color = Color(255,153,0,255)
killicon.Add("weapon_gtv_seeker","gtv/weapons/weapon_gtv_seeker",SWEP.Color)
killicon.Add("gtv_projectile_seeker","gtv/weapons/weapon_gtv_seeker",SWEP.Color)

function SWEP:Shoot()
end