
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	
	SWEP.PrintName = "Icicle Revolver"
	SWEP.IconLetter = "."
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "ft_icerevolver", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ft_base"

SWEP.HoldType			= "pistol"

SWEP.ViewModel = "models/weapons/v_357.mdl"  
SWEP.WorldModel	= "models/weapons/w_357.mdl"  

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Reload         = nil
SWEP.Primary.Damage			= 45
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.500

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false

function SWEP:Reload()

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
end

function SWEP:CanPrimaryAttack()

	if self.Weapon:Clip1() <= 0 then

		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		return false
		
	end
	
	return true
	
end