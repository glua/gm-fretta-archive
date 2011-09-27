if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "HK-UMP45"
	SWEP.IconLetter = "q"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_ump45", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "gta_base"

SWEP.HoldType = "smg"

SWEP.ViewModel			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.IronSightsPos = Vector( 7.3048, -3.8881, 3.1879 )
SWEP.IronSightsAng = Vector( -1.2547, 0.2029, 1.6303 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_UMP45.Single" )
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.100
SWEP.Primary.ShellType      = SHELL_57

SWEP.Primary.ClipSize		= 25
SWEP.Primary.Automatic		= true
