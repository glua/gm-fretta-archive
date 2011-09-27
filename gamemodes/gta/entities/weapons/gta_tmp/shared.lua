if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "TMP"
	SWEP.IconLetter = "d"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_tmp", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "gta_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel			= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_tmp.mdl"

SWEP.IronSightsPos = Vector( 5.2182, -0.9358, 2.5587 )
SWEP.IronSightsAng = Vector( 0.6118, -0.144, 0.3591 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.Recoil			= 2.0
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.075
SWEP.Primary.ShellType      = SHELL_9MM

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
