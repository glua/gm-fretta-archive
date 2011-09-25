if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "pistol"
end

if ( CLIENT ) then
	SWEP.PrintName		= "Hl2 Pistol"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_pistol", "HL2MPTypeDeath", "-", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_Pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_Pistol.mdl"
SWEP.ViewModelFlip		= false

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_Pistol.Single" )
SWEP.Primary.Recoil		= 0.35
SWEP.Primary.DamageMin		= 12
SWEP.Primary.DamageMax		= 12
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.02
SWEP.Primary.ClipSize		= 18
SWEP.Primary.Delay		= 0.15
SWEP.Primary.DefaultClip	= 54
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "pistol"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.CanSprintAndShoot = false

SWEP.SprayTime = 0.1
SWEP.SprayAccuracy = 0.5

SWEP.IronSightsPos = Vector (-5.7183, -10.5266, 4.0303)
SWEP.IronSightsAng = Vector (0.4489, -1.0831, 1.1116)

SWEP.RunArmOffset = Vector (-0.0805, -21.8984, -4.2639)
SWEP.RunArmAngle = Vector (61.304, -9.9066, 0)
