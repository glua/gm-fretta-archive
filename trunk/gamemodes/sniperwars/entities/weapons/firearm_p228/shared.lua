if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "pistol"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "P228 Compact"
	SWEP.IconLetter = "y"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	killicon.AddFont( "firearm_p228", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "firearm_base"

SWEP.ViewModel	= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.SprintPos = Vector(-0.8052, 0, 3.0657)
SWEP.SprintAng = Vector(-16.9413, -5.786, 4.0159)

SWEP.Primary.Sound			= Sound("weapons/p228/p228-1.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.180

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

