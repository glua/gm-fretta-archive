if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Glock 18"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "c"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_glock18", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ts_base"
	
SWEP.HoldType = "pistol"

SWEP.ViewModel	= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 3.8
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 18
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_9MM

function SWEP:OnRemove()

end