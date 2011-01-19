if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "P228 Compact"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "y"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_p228", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ts_base"

SWEP.ViewModel	= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_P228.Single" )
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.2
SWEP.Primary.Cone			= 0.010
SWEP.Primary.Delay			= 0.120

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_9MM

function SWEP:OnRemove()

end