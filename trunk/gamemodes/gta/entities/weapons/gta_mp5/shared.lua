if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "smg"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "HK MP5"
	SWEP.IconLetter = "x"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_mp5", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "gta_base"

SWEP.ViewModel			= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mp5.mdl"

SWEP.IronSightsPos = Vector( 4.7375, -3.0969, 1.7654 )
SWEP.IronSightsAng = Vector( 1.541, -0.1335, -0.144 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Recoil			= 3.0
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.075
SWEP.Primary.ShellType      = SHELL_57

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
