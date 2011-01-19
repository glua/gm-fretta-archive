
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Crowbar"			
SWEP.Slot				= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"

function SWEP:Initialize( )
	self:GMDMInit()
	self:SetWeaponHoldType( "melee" )	
end

function SWEP:HasUsableAmmo( )
	return true
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.CanSprintAndShoot		= true;

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ConstantAccuracy	= true
SWEP.Primary.Cone		= 0.0;

function SWEP:PrimaryAttack( )
	
	if not self:CanShootWeapon( ) then return end
	
	self.Weapon:EmitSound( "Weapon_Crowbar.Single" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if( SERVER ) then
		local hitent = self.Owner:TraceHullAttack( self.Owner:GetShootPos(), self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 16 ), Vector(-16,-16,-16), Vector(36,36,36), 76, DMG_CLUB, 20 );  
	
		if( hitent ) then
			if( hitent:IsValid() and hitent:IsPlayer() and hitent:Health() - 76 < 1 ) then
				self.Weapon:SendWeaponAnim( ACT_VM_HITKILL )
			else
				self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
			end
		else
			self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		end
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	
end

function SWEP:Reload( )
	return
end

function SWEP:SecondaryAttack( )
	self:PrimaryAttack( )
end
