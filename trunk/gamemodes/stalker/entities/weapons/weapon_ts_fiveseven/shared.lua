if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "FN Five-Seven"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "y"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_fiveseven", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "ts_base"

SWEP.ViewModel	= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_fiveseven.Single" )
SWEP.Primary.Damage			= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_9MM

function SWEP:OnRemove()

end