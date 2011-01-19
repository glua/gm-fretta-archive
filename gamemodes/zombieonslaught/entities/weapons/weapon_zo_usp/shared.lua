if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "USP Compact"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "a"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_usp", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"

SWEP.ViewModel	= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.IronSightsPos = Vector (4.473, 0.5303, 2.7239)
SWEP.IronSightsAng = Vector (-0.2771, 0.0702, 0)
SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.6
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.170

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_9MM