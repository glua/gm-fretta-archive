if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "IMI Galil"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "v"
	SWEP.ViewModelFlip = false
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_galil", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"
	
SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"

SWEP.IronSightsPos = Vector(-5.1337, -3.9115, 2.1624)
SWEP.IronSightsAng = Vector(0.0873, 0.0006, 0)
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_Galil.Single" )
SWEP.Primary.Damage			= 27
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.110

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "Rifle"

SWEP.Primary.ShellType      = SHELL_556