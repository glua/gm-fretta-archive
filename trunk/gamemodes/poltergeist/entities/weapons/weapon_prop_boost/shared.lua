if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.PrintName = "Thruster"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
end

SWEP.WorldModel		= ""

SWEP.Primary.Sound			= Sound("ambient/machines/machine1_hit1.wav")

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

function SWEP:Initialize()
	
end

function SWEP:Deploy()

	if SERVER then
		self.Owner:DrawWorldModel( false )
	end

	return true
	
end  

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
	self.Weapon:EmitSound( self.Primary.Sound )	
	
	if CLIENT then return end
	
	local prop = self.Owner:GetProp()
	if not prop or not prop:IsValid() then return end
	
	local phys = prop:GetPhysicsObject()
	if not phys or not phys:IsValid() then return end
	
	phys:SetVelocityInstantaneous( self.Owner:GetAimVector() * 5000 )
	
end

function SWEP:Think()	

end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()
	
end

