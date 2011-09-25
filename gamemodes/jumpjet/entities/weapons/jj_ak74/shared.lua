if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "ar2"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "AK-74"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "b"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_ak74", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_ak74", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Deploy         = Sound("weapons/ak47/ak47_boltpull.wav")
SWEP.Primary.ReloadSounds   = { Sound("weapons/sg552/sg552_clipout.wav"), 
								Sound("weapons/m4a1/m4a1_clipin.wav"), 
								Sound("weapons/ak47/ak47_boltpull.wav") }
SWEP.Primary.ReloadTime     = 3.20 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.15 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.080 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.170

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true
