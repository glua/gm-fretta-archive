if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= false

	SWEP.ViewModelFOV		= 10
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Keys"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
end

SWEP.HoldType = "melee"

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1

SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()

	if SERVER then
		self.Owner:DrawWorldModel( false )
	end

	return true
	
end  

function SWEP:Think()	

end

function SWEP:Reload()
	
end

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()
	
end