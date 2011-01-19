if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Desert Eagle"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "f"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_deagle", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"

SWEP.ViewModel	= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.IronSightsPos = Vector (5.1378, 1.6550, 2.6575)
SWEP.IronSightsAng = Vector (0.3551, -0.1281, 0.4)
SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Damage			= 29
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 5.2
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.370

SWEP.Primary.ClipSize		= 7
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_57
MsgN(3333)