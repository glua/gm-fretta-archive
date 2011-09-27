if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "FN P90"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "m"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_p90", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ts_base"
	
SWEP.HoldType = "ar2"

SWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_P90.Single" )
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 4.4
SWEP.Primary.Cone			= 0.055
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "SMG"

SWEP.Primary.ShellType      = SHELL_57