
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.CustomSecondaryAmmo = true

if ( CLIENT ) then

	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/nade" )

end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "#SMG"			
SWEP.Slot				= 2
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.Weight				= 6

local ShootSound = Sound( "Weapon_Pistol.NPC_Single" )
local Launch_Sound = Sound( "Weapon_AR2.NPC_Double" )

function SWEP:Initialize()

	self:GMDMInit()
	self:SetWeaponHoldType( "smg" )
	
end


/*---------------------------------------------------------
   Name: FirstTimePickup
---------------------------------------------------------*/
function SWEP:FirstTimePickup( Owner )
	Owner:GiveAmmo( 64, "SMG1", true )	
	Owner:AddCustomAmmo( "FireBalls", 1 )	
end

/*---------------------------------------------------------
   Name: HasUsableAmmo
---------------------------------------------------------*/
function SWEP:HasUsableAmmo()
	return ( self.Owner:GetCustomAmmo( "FireBalls" ) > 0 || self:Ammo1() > 0 || self:Clip1() > 0 )
end

SWEP.RunArmAngle  = Angle( 0, -50, 12 )
SWEP.RunArmOffset = Vector( 4, 1, 10 )

/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.06 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.06 )

	if ( !self:CanShootWeapon() ) then return end
	if ( !self:CanPrimaryAttack() ) then return end

	self:GMDMShootBullet( 12, ShootSound, -2, math.Rand( -1.0, 1.0 ), 1, 0.05 / self:GetStanceAccuracyBonus() )
	
	if( SERVER and gmdm_unlimitedammo:GetBool() == false ) then
		self:TakePrimaryAmmo( 1 )
	end
	
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
SWEP.Primary.Ammo			= "SMG1"

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.1 )

	if ( !self:CanShootWeapon() ) then return end	
	if ( self.Owner:GetCustomAmmo( "FireBalls" ) < 1 ) then return end
	
	self.Weapon:EmitSound( Launch_Sound )
	self.Owner:Recoil( -5, 0 )
	self:NoteGMDMShot()
	
	if ( SERVER ) then
		
		if( gmdm_unlimitedammo:GetBool() == false ) then
			self.Owner:TakeCustomAmmo( "FireBalls", 1 )	
		end
	
		local grenade = ents.Create( "smg_grenade" )
	//	local grenade = ents.Create( "item_tripmine" )
			grenade:SetPos( self.Owner:GetShootPos() )
			grenade:SetOwner( self.Owner )
		grenade:Spawn()
		
		local phys = grenade:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetVelocity( self.Owner:GetAimVector() * 2000 )
		end
		
		self:CheckRedundancy()
		
	end
	
	if ( CLIENT ) then
	
		ColorModify[ "$pp_colour_addr" ] = 0.1
		//ColorModify[ "$pp_colour_addb" ] = 0.2
	
	end

end

function SWEP:CustomAmmoCount()
	
	if ( !ValidEntity( self.Owner ) ) then return 0 end
	
	return self.Owner:GetCustomAmmo( "FireBalls" )
	
end

