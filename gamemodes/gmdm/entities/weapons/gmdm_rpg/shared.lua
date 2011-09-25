
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.CustomSecondaryAmmo = true
SWEP.HoldType = "rpg"

if ( CLIENT ) then

	SWEP.PrintName			= "RPG"			
	SWEP.Slot				= 3
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo			= true
	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/fireball" )
	
end

SWEP.Base				= "gmdm_base"

SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"
SWEP.Weight				= 8

local Launch_Sound = Sound("weapons/stinger_fire1.wav")
local Cluster_Sound = Sound("weapons/rpg/rocketfire1.wav")

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	self:GMDMInit()
	
end

/*---------------------------------------------------------
   Name: FirstTimePickup
---------------------------------------------------------*/
function SWEP:FirstTimePickup( Owner )
	Owner:AddCustomAmmo( "RPGs", 2 )	
end


/*---------------------------------------------------------
   Name: HasUsableAmmo
---------------------------------------------------------*/
function SWEP:HasUsableAmmo()
	return self.Owner:GetCustomAmmo( "RPGs" ) > 0
end


SWEP.RunArmAngle  = Angle( 60, 00, 0 )
SWEP.RunArmOffset = Vector( 25, 0, -10 )

/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )

	if ( !self:CanShootWeapon() ) then return end	
	if ( self.Owner:GetCustomAmmo( "RPGs" ) < 1 ) then return end
	
	self.Weapon:EmitSound( Launch_Sound )
	self.Owner:Recoil( -5, 0 )
	self:NoteGMDMShot()
	
	if ( SERVER ) then
	
		self.Owner:TakeCustomAmmo( "RPGs", 1 )	
	
		local grenade = ents.Create( "rpg_rocket" )
			grenade:SetPos( self.Owner:GetShootPos() )
			grenade:SetOwner( self.Owner )
			grenade.FlyAngle = self.Owner:GetAimVector():Angle()
		grenade:Spawn()
		
		local phys = grenade:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetVelocity( self.Owner:GetAimVector() * 3000 )
		end
		
		self:CheckRedundancy()
		
	end
	
	if ( CLIENT ) then
	
		ColorModify[ "$pp_colour_addr" ] = 0.3
		ColorModify[ "$pp_colour_addg" ] = 0.2
	
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

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	if ( !self:CanShootWeapon() ) then return end	
	if ( self.Owner:GetCustomAmmo( "RPGs" ) < 1 ) then return end
	
	self.Weapon:EmitSound( Cluster_Sound )
	self.Owner:Recoil( -5, 0 )
	self:NoteGMDMShot()
	
	if ( SERVER ) then
	
		self.Owner:TakeCustomAmmo( "RPGs", 1 )	
	
		local grenade = ents.Create( "rpg_clusterbomb" )
			grenade:SetPos( self.Owner:GetShootPos() )
			grenade:SetOwner( self.Owner )
			grenade.FlyAngle = self.Owner:GetAimVector():Angle()
		grenade:Spawn()
		
		local phys = grenade:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetVelocity( self.Owner:GetAimVector() * 1000 )
		end
		
		self:CheckRedundancy()
		
	end
	
	if ( CLIENT ) then
	
		ColorModify[ "$pp_colour_addr" ] = 0.2
		ColorModify[ "$pp_colour_addg" ] = 0.1
	
	end
	
end


function SWEP:CustomAmmoCount()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	return self.Owner:GetCustomAmmo( "RPGs" )
	
end

