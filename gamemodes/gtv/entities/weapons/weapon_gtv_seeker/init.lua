AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 0.1
SWEP.AmmoCost = 2
SWEP.HoldType = "rpg"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.Slot = SLOT_EXTRA
SWEP.ItemType = GTVITEM_SEEKER
SWEP.Weight = 3
SWEP.PrintName = "Ion-U Cannon"

function SWEP:Shoot()
	local proj = ents.Create("gtv_projectile_seeker")
	local target = NULL
	local closest = 600
	for k,v in ipairs(player.GetAll()) do
		if (v != self.Owner) && (v:GetPos():Distance(self.Owner:GetPos()) < closest) && v:Alive() then
			closest = v:GetPos():Distance(self.Owner:GetPos())
			target = v
		end
	end
	proj.target = target
	proj:SetPos(self.Owner:GetShootPos())
	proj:SetAngles(self.Owner:GetAngles())
	proj.LifeTime = 2
	proj:SetOwner(self.Owner)
	proj.Owner = self.Owner
	proj:Spawn()
	proj:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*400)
	self.Owner:EmitSound("ambient/energy/zap9.wav",40)
end