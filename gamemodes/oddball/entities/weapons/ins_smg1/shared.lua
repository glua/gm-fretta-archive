if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "smg"
end

if ( CLIENT ) then
	SWEP.PrintName		= "Hl2 SMG1"
	SWEP.Author			= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_smg1", "HL2MPTypeDeath", "/", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.ViewModelFlip		= false

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_SMG1.Single" )
SWEP.Primary.Recoil		= 0.80
SWEP.Primary.DamageMin		= 8
SWEP.Primary.DamageMax		= 18
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.04
SWEP.Primary.ClipSize		= 45
SWEP.Primary.Delay		= 0.06
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "smg1"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.CanSprintAndShoot = false

SWEP.SprayTime = 0.1
SWEP.SprayAccuracy = 0.5

SWEP.IronSightsPos = Vector( -6.443, -11.0504, 2.5448 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.RunArmOffset = Vector (4.8505, -17.1724, -0.3491)
SWEP.RunArmAngle = Vector (-1.0967, 73.7509, 0)
