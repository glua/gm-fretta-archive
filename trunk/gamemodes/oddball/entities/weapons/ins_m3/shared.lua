if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "shotgun"
end

if ( CLIENT ) then
	SWEP.PrintName		= "CSS M3"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_m3", "CSKillIcons", "k", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base_shotgun"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"
SWEP.ViewModelFlip		= true

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_M3.Single" )
SWEP.Primary.Recoil		= 2.00
SWEP.Primary.DamageMin		= 9
SWEP.Primary.DamageMax		= 13
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 12
SWEP.Primary.Cone		= 0.1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay		= 0.95
SWEP.Primary.DefaultClip	= 24
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "buckshot"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.CanSprintAndShoot = false

SWEP.InsertShellDelay = 0.5

SWEP.SprayTime = 0.2
SWEP.SprayAccuracy = 0.5

SWEP.IronSightsPos = Vector (5.7484, -3.1948, 3.3643)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (-0.4732, -9.2314, 0.6093)
SWEP.RunArmAngle = Vector (-0.7707, -71.2668, 0)