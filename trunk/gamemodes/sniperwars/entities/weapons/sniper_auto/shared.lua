if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Autosniper"
	SWEP.IconLetter = "i"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "sniper_auto", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "sniper_base"

SWEP.ViewModel	= "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.SprintPos = Vector(-2.8398, -3.656, 0.5519)
SWEP.SprintAng = Vector(0.1447, -34.0929, 0)

SWEP.ScopePos = Vector(5.4232, -5.1719, 2.0841)
SWEP.ScopeAng = Vector(-4.7239, 0.5676, 0.6653)

SWEP.ZoomModes = { 0, 30, 10 }
SWEP.ZoomSpeeds = { 0.25, 0.40, 0.40 }

SWEP.Primary.Sound			= Sound("weapons/g3sg1/g3sg1-1.wav")
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.002
SWEP.Primary.Delay			= 0.380

SWEP.Primary.ClipSize		= 20
SWEP.Primary.Automatic		= true

SWEP.Secondary.Sound        = Sound( "weapons/zoom.wav" )
SWEP.Secondary.Delay  		= 0.5

