if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "pistol"
end

if ( CLIENT ) then
	SWEP.PrintName		= "CSS USP"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_fiveseven", "CSKillIcons", "f", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"
SWEP.ViewModelFlip		= true

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil		= 0.50
SWEP.Primary.DamageMin		= 15
SWEP.Primary.DamageMax		= 22
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.02
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay		= 0.15
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "pistol"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.CanSprintAndShoot = false

SWEP.SprayTime = 0.2
SWEP.SprayAccuracy = 0.5
//7
--SWEP.IronSightsPos = Vector (4.4963, -4.2801, 2.6981)
SWEP.IronSightsPos = Vector (4.4963, -2.2801, 2.6981)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (-0.617, -12.7209, -6.2727)
SWEP.RunArmAngle = Vector (70.0839, 1.5125, 3.2532)