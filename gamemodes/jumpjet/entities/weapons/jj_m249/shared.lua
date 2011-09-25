if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "smg"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "M249"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "z"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_m249", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_m249", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_M249.Single" )
SWEP.Primary.Deploy         = Sound( "weapons/m249/m249_coverup.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/m249/m249_coverup.wav" ), 
								Sound( "weapons/m249/m249_boxin.wav" ), 
								Sound( "weapons/m249/m249_chain.wav" ), 
								Sound( "weapons/m249/m249_boxout.wav" ) }
SWEP.Primary.ReloadTime     = 4.50 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.10 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.012 // how fast does recoil fade away?
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.280 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.070

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= true
