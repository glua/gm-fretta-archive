if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "M249 SAW"
	SWEP.IconLetter = "z"
	SWEP.ViewModelFlip = false
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_m249", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "gta_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.IronSightsPos = Vector( -4.4543, 0, 2.0536 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil         = 3.5 
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.080
SWEP.Primary.ShellType      = SHELL_762NATO

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= true
