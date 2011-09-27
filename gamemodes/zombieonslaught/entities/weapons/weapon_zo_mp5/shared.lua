if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "HK MP5"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "x"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_mp5", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"
	
SWEP.HoldType = "smg"

SWEP.ViewModel			= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mp5.mdl"

SWEP.IronSightsPos = Vector (4.7375, -3.0969, 1.7654)
SWEP.IronSightsAng = Vector (1.541, -0.1335, -0.144)
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6.4
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "SMG"

SWEP.Primary.ShellType      = SHELL_57