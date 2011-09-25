if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "USP"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "a"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_usp", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_usp", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Deploy         = Sound( "weapons/usp/usp_slideback.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/usp/usp_slideback2.wav" ), 
								Sound( "weapons/usp/usp_clipout.wav" ),
								Sound( "weapons/usp/usp_clipin.wav" ),
								Sound( "weapons/glock/glock_sliderelease.wav" )}
SWEP.Primary.ReloadTime     = 2.80 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.30 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.150 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.200

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false