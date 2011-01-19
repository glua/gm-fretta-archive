if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "smg"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "HK-UMP45"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "q"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_ump45", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"

SWEP.ViewModel			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.IronSightsPos = Vector (7.3048, -3.8881, 3.1879)
SWEP.IronSightsAng = Vector (-1.2547, 0.2029, 1.6303)
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_UMP45.Single" )
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6.6
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 25
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "SMG"

SWEP.Primary.ShellType      = SHELL_57