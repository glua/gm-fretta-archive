
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "#Shotgun"			
SWEP.Slot				= 2
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"
SWEP.Weight				= 7

SWEP.RunArmAngle  = Angle( 80, -0, 0 )
SWEP.RunArmOffset = Vector( 25, 4, -5 )

function SWEP:NeedsPump()
	return self.Weapon:GetNWBool( "NeedsPump" )
end

function SWEP:SetNeedsPump( b )
	self.Weapon:SetNWBool( "NeedsPump", b )
end

function SWEP:Initialize()

	self:GMDMInit()
	self:SetWeaponHoldType( "smg" )
	self:SetNeedsPump( false )
	
	self.LastTime = 0;
	
end


/*---------------------------------------------------------
   Name: FirstTimePickup
---------------------------------------------------------*/
function SWEP:FirstTimePickup( Owner )
	Owner:GiveAmmo( 32, "buckshot", true )		
end


/*---------------------------------------------------------
   Name: HasUsableAmmo
---------------------------------------------------------*/
function SWEP:HasUsableAmmo()
	return self:Ammo1() > 0
end


/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

function SWEP:PrimaryAttack()

	if ( self.LastTime >= CurTime() ) then return end
	self.LastTime = CurTime()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	
	if ( self:Ammo1() <= 0 ) then return end
	
	if ( self:NeedsPump() ) then
	
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
		self.Weapon:EmitSound( "Weapon_Shotgun.Special1" )
		self:SetNeedsPump( false )
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	
	return end
	
	// Let us pump while running
	if ( !self:CanShootWeapon() ) then return end

	local NumBullets = 5
	
	// Make it look more badass from the shooter's POV
	--if ( CLIENT ) then NumBullets = NumBullets * 2 end
	
	self:GMDMShootBullet( 13, "Weapon_Shotgun.Single", -1, mathx.Rand( -5, 5 ), NumBullets, 0.1 )
	
	if( SERVER and gmdm_unlimitedammo:GetBool() == false ) then
		self:TakePrimaryAmmo(1)
	end
	
	self:SetNeedsPump( true )
	
	if ( SERVER ) then
		self:CheckRedundancy()
	end

end


/*---------------------------------------------------------
   SECONDARY
   Automatic (Uses Primary Ammo)
---------------------------------------------------------*/

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local sndDblShoot = Sound( "Town.d1_town_01a_shotgun_dbl_fire" )

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

	if ( self:Ammo1() <= 0 ) then return end
	
	if ( self:NeedsPump() ) then
	
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
		self.Weapon:EmitSound( "Weapon_Shotgun.Special1" )
		if (SERVER) then self:SetNeedsPump( false ) end
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	
	return end

	// Let us pump while running
	if ( !self:CanShootWeapon() ) then return end
	
	local NumBullets = 9
	
	// Make it look more badass from the shooter's POV
	if ( CLIENT ) then NumBullets = NumBullets * 2 end
	
	
	self:GMDMShootBullet( 10, sndDblShoot, -20, mathx.Rand( -2.0, 2.0 ), NumBullets, 0.1 )
	
	if( SERVER and gmdm_unlimitedammo:GetBool() == false ) then
		self:TakePrimaryAmmo(2)
	end
	self:SetNeedsPump(true)
	
	if ( SERVER ) then
		
		self.Owner:SetGroundEntity( NULL )
		self.Owner:SetVelocity(  self.Owner:GetAimVector() * -250 )
		
		// Note: self.Owner could be NULL after calling this because the
		// player might die and drop the weapon
		//self.Owner:TakeDamage( 8, self.Owner, self.Owner )
		// Undone: The shotgun has to have SOMETHING to make you want to use it.
		
		self:CheckRedundancy()
		
	end
	
end



