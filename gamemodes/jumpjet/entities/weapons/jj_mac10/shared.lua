if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "MAC-10"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "l"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_mac10", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_mac10", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Deploy         = Sound( "weapons/mac10/mac10_boltpull.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/tmp/tmp_clipout.wav" ), 
								Sound( "weapons/mac10/mac10_clipin.wav" ), 
								Sound( "weapons/ump45/ump45_boltslap.wav" ) }
SWEP.Primary.ReloadTime     = 2.50 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.15 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.020 // how fast does recoil fade away?
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.150 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
