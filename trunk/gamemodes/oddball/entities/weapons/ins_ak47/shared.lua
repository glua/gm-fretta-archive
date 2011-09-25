if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "ar2"
end

if ( CLIENT ) then
	SWEP.PrintName		= "CSS AK47"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_ak47", "CSKillIcons", "b", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"
SWEP.ViewModelFlip		= true

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil		= 0.70
SWEP.Primary.DamageMin		= 9
SWEP.Primary.DamageMax		= 20
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.0325
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay		= 0.08
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "smg1"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.CanSprintAndShoot = false

SWEP.SprayTime = 0.2
SWEP.SprayAccuracy = 0.5

//SWEP.SprayTime = 0.1
//SWEP.SprayAccuracy = 0.5

SWEP.IronSightsPos = Vector (6.0664, -6.2162, 2.4758)
SWEP.IronSightsAng = Vector (2.2418, -0.0407, 0)

SWEP.RunArmAngle = Vector (1.6101, -67.9273, 0.7297)
SWEP.RunArmOffset = Vector (-1.9896, -11.1352, -0.9945)