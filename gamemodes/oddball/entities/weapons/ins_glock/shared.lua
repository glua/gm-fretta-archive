if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "pistol"
end

if ( CLIENT ) then
	SWEP.PrintName		= "CSS Glock"
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

SWEP.ViewModel			= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"
SWEP.ViewModelFlip		= true

SWEP.Drawammo = true
SWEP.DrawCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Recoil		= 0.40
SWEP.Primary.DamageMin		= 8
SWEP.Primary.DamageMax		= 15
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.03
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay		= 0.1
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

SWEP.IronSightsPos = Vector (4.3445, -1.1702, 2.9827)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (0.1694, -11.5419, -3.4638)
SWEP.RunArmAngle = Vector (66.0539, 3.7162, 0)