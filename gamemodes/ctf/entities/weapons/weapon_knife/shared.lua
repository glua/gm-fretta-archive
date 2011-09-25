
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "gmdm_csbase"
SWEP.PrintName			= "Knife"			
SWEP.Slot				= 2
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"

if( CLIENT ) then
	SWEP.IconLetter			= "j";
	killicon.AddFont( "weapon_knife", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 )  );
	
	SWEP.ViewModelFlip = false;
end
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

SWEP.RunArmOffset = Vector(0,0,0)
SWEP.RunArmAngle = Angle(0,0,0)

SWEP.ConstantAccuracy	= true
SWEP.Primary.Cone		= 0.0;

function SWEP:PrimaryAttack( )
	
	if not self:CanShootWeapon( ) then return end
	
	if IsFirstTimePredicted() then
		self.Weapon:EmitSound( "Weapon_Knife.Slash" )
	end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	
	// needs some prediction..
	if( SERVER ) then
		local hitent = self.Owner:TraceHullAttack( self.Owner:GetShootPos(), self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 32 ), Vector(-16,-16,-16), Vector(36,36,36), 76, DMG_SLASH, 20 );  
	
		if( hitent and hitent:IsValid() ) then
			if( hitent:IsPlayer() and hitent:Health() - 76 < 1 ) then
				self.Weapon:SendWeaponAnim( ACT_VM_HITKILL )
				hitent:EmitSound( "Weapon_Knife.Stab" )
			else
				self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
				hitent:EmitSound( "Weapon_Knife.SlashWorld" )
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
