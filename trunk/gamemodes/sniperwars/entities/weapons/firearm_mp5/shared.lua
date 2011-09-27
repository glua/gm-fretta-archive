if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "HK MP5"
	SWEP.IconLetter = "x"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	killicon.AddFont( "firearm_mp5", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "firearm_base"

SWEP.HoldType = "smg"

SWEP.ViewModel	= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
SWEP.SprintAng = Vector(-3.4815, -21.9362, 0)

SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.045
SWEP.Primary.Delay			= 0.085

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

