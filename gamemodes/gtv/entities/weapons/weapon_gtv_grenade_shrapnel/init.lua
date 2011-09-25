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
SWEP.ItemType = GTVITEM_GRENADE_SHRAPNEL
local col = Color(255,255,100,200)
SWEP.PrintName = "Shrapnel Grenade"

function SWEP:Shoot()
	local proj = ents.Create("gtv_grenade_shrapnel")
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetAngles(self.Owner:GetAngles())
	proj.LifeTime = 2
	proj:SetOwner(self.Owner)
	proj:Spawn()
	proj:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*400+self.Owner:GetVelocity())
	util.SpriteTrail(proj,0,col,false,4,0,1,0.135,"trails/smoke.vmt")
	proj:SetPhysicsAttacker(self.Owner)
end