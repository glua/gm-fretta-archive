if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "MAC 10"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "l"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_mac10", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"
	
SWEP.HoldType = "pistol"

SWEP.ViewModel			= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.IronSightsPos = Vector (6.9362, -1.351, 2.812)
SWEP.IronSightsAng = Vector (1.0483, 5.2515, 6.6932)
SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" );
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.080

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "SMG"

SWEP.Primary.ShellType      = SHELL_9MM