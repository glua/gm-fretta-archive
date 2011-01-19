if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "ar2"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "AK-47"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "b"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_ak47", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"

SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.IronSightsPos = Vector (6.0826, -6.62, 2.4372)
SWEP.IronSightsAng = Vector (2.4946, -0.1113, -0.0844)

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Damage			= 32
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6.2
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "Rifle"

SWEP.Primary.ShellType      = SHELL_556