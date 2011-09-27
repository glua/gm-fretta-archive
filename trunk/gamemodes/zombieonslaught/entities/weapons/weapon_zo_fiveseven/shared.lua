if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "FN Five-Seven"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "y"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_fiveseven", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"
	
SWEP.HoldType = "pistol"

SWEP.ViewModel	= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.IronSightsPos = Vector (4.492, 0.9125, 3.3454)
SWEP.IronSightsAng = Vector (-0.4148, -0.2109, 0)
SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound("Weapon_FiveSeven.Single")
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.7
SWEP.Primary.Cone			= 0.015
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_9MM