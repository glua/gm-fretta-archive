if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "TMP"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "d"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_tmp", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"

SWEP.ViewModel			= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_tmp.mdl"

SWEP.IronSightsPos = Vector (5.2182, -0.9358, 2.5587)
SWEP.IronSightsAng = Vector (0.6118, -0.144, 0.3591)

SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Silenced" )
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6.2
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "SMG"

SWEP.Primary.ShellType      = SHELL_9MM