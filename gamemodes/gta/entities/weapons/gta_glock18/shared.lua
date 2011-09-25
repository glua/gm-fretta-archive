if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Glock 18"
	SWEP.IconLetter = "c"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_glock18", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "gta_base"

SWEP.ViewModel	= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.IronSightsPos = Vector( 4.3618, 0.5381, 2.8266 )
SWEP.IronSightsAng = Vector( 0.4921, 0.0041, 0 )

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Recoil			= 4.0
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.120
SWEP.Primary.ShellType      = SHELL_9MM

SWEP.Primary.ClipSize		= 18
SWEP.Primary.Automatic		= false
