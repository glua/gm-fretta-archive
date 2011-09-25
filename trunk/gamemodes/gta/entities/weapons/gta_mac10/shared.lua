if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "MAC-10"
	SWEP.IconLetter = "l"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_mac10", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "gta_base"

SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"
SWEP.ViewModel = "models/weapons/v_smg_mac10.mdl"

SWEP.IronSightsPos = Vector( 6.9362, -1.351, 2.812 )
SWEP.IronSightsAng = Vector( 1.0483, 5.2515, 6.6932 )

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Recoil         = 3.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.075
SWEP.Primary.ShellType      = SHELL_9MM

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true
