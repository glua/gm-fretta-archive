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
	
	killicon.AddFont( "weapon_zo_p228", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"

SWEP.ViewModel	= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.IronSightsPos = Vector (4.7607, 0.2693, 2.9149)
SWEP.IronSightsAng = Vector (-0.7388, 0.0586, 0)
SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound( "Weapon_P228.Single" )
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.8
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_9MM