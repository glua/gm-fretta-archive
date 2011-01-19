
if SERVER then

	AddCSLuaFile("shared.lua")
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel = "models/Zed/weapons/v_ghoul.mdl"

SWEP.Primary.Voice          = Sound("npc/zombie/zo_attack2.wav")
SWEP.Primary.Sound			= Sound("npc/zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/zombie/claw_strike1.wav")
SWEP.Primary.Damage			= 65
SWEP.Primary.HitForce       = 1000
SWEP.Primary.Delay			= 2.30
SWEP.Primary.FreezeTime     = 0.60
SWEP.Primary.Automatic		= false

