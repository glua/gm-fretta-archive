
if SERVER then

	AddCSLuaFile("shared.lua")
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel = "models/Zed/weapons/v_ghoul.mdl"

SWEP.Primary.Voice          = Sound("npc/zombie/zo_attack2.wav")
SWEP.Primary.Sound			= Sound("npc/zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/zombie/claw_strike1.wav")
SWEP.Primary.Damage			= 45
SWEP.Primary.HitForce       = 800
SWEP.Primary.Delay			= 1.20
SWEP.Primary.FreezeTime     = 0.40
SWEP.Primary.Automatic		= false

