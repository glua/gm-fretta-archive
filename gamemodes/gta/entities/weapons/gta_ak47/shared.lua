if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "AK47"
	SWEP.IconLetter = "b"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_ak47", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "gta_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.IronSightsPos = Vector( 6.0826, -6.62, 2.4372 )
SWEP.IronSightsAng = Vector( 2.4946, -0.1113, -0.0844 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= 4.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.100
SWEP.Primary.ShellType      = SHELL_556

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true