AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 1
SWEP.AmmoCost = 25
SWEP.HoldType = "slam"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.Slot = SLOT_GRENADE
SWEP.ItemType = GTVITEM_GRENADE_INCENDIARY
SWEP.PrintName = "Napalm Grenade"

function SWEP:Shoot()
	local proj = ents.Create("gtv_grenade_incendiary")
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetAngles(self.Owner:GetAngles())
	proj.LifeTime = 2
	proj:SetOwner(self.Owner)
	proj:Spawn()
	proj:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*400+self.Owner:GetVelocity())
	proj:Ignite(2)
	proj:SetPhysicsAttacker(self.Owner)
end