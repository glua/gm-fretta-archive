AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0.5
SWEP.AmmoCost = 10
SWEP.HoldType = "rpg"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.ItemType = GTVITEM_ROCKETLAUNCHER
SWEP.Slot = SLOT_EXTRA
SWEP.Weight = 3
SWEP.PrintName = "Rocket Launcher"

function SWEP:Shoot()
	local proj = ents.Create("gtv_projectile_rocket")
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetAngles(self.Owner:GetAngles())
	proj.LifeTime = 2
	proj:SetOwner(self.Owner)
	
	//proj:SetNetworkedVector("vel",self.Owner:GetAimVector()*400)
	proj:Spawn()
	proj:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*400)
end