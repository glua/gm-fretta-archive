if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Desert Eagle"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "f"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_deagle", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_deagle", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Deploy         = Sound( "weapons/deagle/de_deploy.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/fiveseven/fiveseven_clipout.wav" ), 
								Sound( "weapons/fiveseven/fiveseven_clipin.wav" ),
								Sound( "weapons/p228/p228_slidepull.wav" )}
SWEP.Primary.ReloadTime     = 2.80 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.35 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.200 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.200

SWEP.Primary.ClipSize		= 7
SWEP.Primary.Automatic		= false