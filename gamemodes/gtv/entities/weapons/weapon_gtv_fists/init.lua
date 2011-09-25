AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "slam"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Cooldown = 0.1
SWEP.Slot = SLOT_FISTS
PrecacheParticleSystem("gtv_impact_blood")
SWEP.Weight = 1
SWEP.PrintName = "Fists"

local tracep = {}
tracep.mask = MASK_SHOT
tracep.mins = Vector(-8,-8,-8)
tracep.mins = Vector(8,8,8)

local dmg = DamageInfo()

function SWEP:Shoot()
	tracep.filter = self.Owner
	tracep.start = self.Owner:GetShootPos()
	tracep.endpos = self.Owner:GetShootPos()+self.Owner:GetAimVector()*100
	self.Owner:LagCompensation(true)
	local tr = util.TraceHull(tracep)
	self.Owner:LagCompensation(false)
	if tr.Entity && tr.Entity:IsValid() then
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamage(20)
		dmg:SetDamagePosition(tr.HitPos)
		dmg:SetDamageForce(tr.Normal*100)
		dmg:SetDamageType(DMG_CLUB)
		tr.Entity:TakeDamageInfo(dmg)
		self.Owner:EmitToAllButSelf("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav")
		if (tr.Entity:IsPlayer() || tr.Entity:IsNPC()) then
			ParticleEffect("gtv_impact_blood",tr.HitPos,tr.Normal:Angle(),nil)
		end
	else
		self.Owner:EmitToAllButSelf("weapons/iceaxe/iceaxe_swing1.wav")
	end
	
end