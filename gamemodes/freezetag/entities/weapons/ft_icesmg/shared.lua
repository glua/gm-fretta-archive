
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	
	SWEP.PrintName = "Icicle SMG"
	SWEP.IconLetter = "/"
	SWEP.Slot = 0
	SWEP.Slotpos = 1
	
	killicon.AddFont( "ft_icesmg", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ft_base"

SWEP.HoldType			= "smg"
	
SWEP.ViewModel	= "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Primary.Sound			= Sound("Weapon_SMG1.Single")
SWEP.Primary.Reload         = Sound("weapons/smg1/smg1_reload.wav")
SWEP.Primary.Damage			= 20
SWEP.Primary.Recoil			= 2.0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true
