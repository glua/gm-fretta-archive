if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "ar2"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "M249 SAW"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "z"
	SWEP.ViewModelFlip = false
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_m249", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"

SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.IronSightsPos = Vector(-4.4543, 0, 2.0536)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Damage			= 45
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "Rifle"

SWEP.Primary.ShellType      = SHELL_762NATO