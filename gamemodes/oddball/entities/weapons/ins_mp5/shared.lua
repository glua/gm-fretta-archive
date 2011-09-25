if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "smg"
end

if ( CLIENT ) then
	SWEP.PrintName		= "CSS MP5"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_mp5", "CSKillIcons", "x", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mp5.mdl"
SWEP.ViewModelFlip		= true

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Recoil		= 0.60
SWEP.Primary.DamageMin		= 8
SWEP.Primary.DamageMax		= 18
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.03
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

SWEP.IronSightsPos = Vector (4.7529, -4.4431, 1.7617)
SWEP.IronSightsAng = Vector (1.8671, -0.053, 0)

SWEP.RunArmOffset = Vector (-1.1735, -11.0327, 1.1325)
SWEP.RunArmAngle = Vector (-2.1011, -73.4478, 0)