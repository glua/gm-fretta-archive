if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "ar2"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "FN P90"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "m"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_p90", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_p90", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_P90.Single" )
SWEP.Primary.Deploy         = Sound( "weapons/p90/p90_boltpull.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/mac10/mac10_boltpull.wav" ),
								Sound( "weapons/p90/p90_clipout.wav" ), 
								Sound( "weapons/p90/p90_clipin.wav" ),
								Sound( "weapons/p90/p90_boltpull.wav" ) }
SWEP.Primary.ReloadTime     = 3.80 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.10 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.280 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.080

SWEP.Primary.ClipSize		= 50
SWEP.Primary.Automatic		= true
