
if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "melee"
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel = "models/Zed/weapons/v_disease.mdl"

SWEP.Primary.Voice          = Sound("npc/fast_zombie/idle1.wav")
SWEP.Primary.Sound			= Sound("npc/zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/fast_zombie/claw_strike1.wav")
SWEP.Primary.Damage			= 35
SWEP.Primary.HitForce       = 700
SWEP.Primary.Delay			= 0.95
SWEP.Primary.FreezeTime     = 0
SWEP.Primary.Automatic		= true

SWEP.WorldModel = "models/weapons/w_grenade.mdl"

function SWEP:Deploy()
	
	self.Weapon:SetVar( "NextHit", 0 )

	return true
	
end 

