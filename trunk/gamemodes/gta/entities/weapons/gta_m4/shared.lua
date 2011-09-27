if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "M4A1"
	SWEP.IconLetter = "w"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_m4", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "gta_base"

SWEP.HoldType = "ar2"

SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl"

SWEP.IronSightsPos = Vector( 6.024, 0.4309, 0.8493 )
SWEP.IronSightsAng = Vector( 3.028, 1.3759, 3.5968 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Single" )
SWEP.Primary.Recoil         = 4.0 
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.100
SWEP.Primary.ShellType      = SHELL_762NATO

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
