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
SWEP.ItemType = GTVITEM_GRENADE_FRAG
local col = Color(100,100,100,200)
SWEP.PrintName = "Frag Grenade"


function SWEP:Shoot()
	local proj = ents.Create("gtv_grenade_base")
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetAngles(self.Owner:GetAngles())
	proj.LifeTime = 2
	proj:SetOwner(self.Owner)
	proj:Spawn()
	proj:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*400+self.Owner:GetVelocity())
	proj:SetPhysicsAttacker(self.Owner)
	util.SpriteTrail(proj,0,col,false,4,0,1,0.135,"trails/smoke.vmt")
end