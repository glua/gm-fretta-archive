if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "pistol"
end

if ( CLIENT ) then
	SWEP.PrintName		= "CSS Deagle"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_deagle", "CSKillIcons", "f", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"
SWEP.ViewModelFlip		= true

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil		= 1.5
SWEP.Primary.DamageMin		= 45
SWEP.Primary.DamageMax		= 65
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.015
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay		= 0.20
SWEP.Primary.DefaultClip	= 28
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "pistol"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.CanSprintAndShoot = false

SWEP.SprayTime = 0.3
SWEP.SprayAccuracy = 0.5

SWEP.IronSightsPos = Vector (5.1416, -4.0964, 2.7841)
SWEP.IronSightsAng = Vector (-0.1343, -0.0067, 0)

SWEP.RunArmOffset = Vector (-0.1204, -10.216, -5.4273)
SWEP.RunArmAngle = Vector (59.6952, 3.5692, 0)