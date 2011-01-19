
if SERVER then

	AddCSLuaFile("shared.lua")
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel = "models/Zed/weapons/v_undead.mdl"

SWEP.Primary.Voice          = Sound("npc/fast_zombie/idle1.wav")
SWEP.Primary.Sound			= Sound("npc/zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/fast_zombie/claw_strike1.wav")
SWEP.Primary.Damage			= 20
SWEP.Primary.HitForce       = 600
SWEP.Primary.Delay			= 0.80
SWEP.Primary.FreezeTime     = 0
SWEP.Primary.Automatic		= true

