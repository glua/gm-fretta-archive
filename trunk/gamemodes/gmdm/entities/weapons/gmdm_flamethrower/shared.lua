
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "smg"

if ( CLIENT ) then

	SWEP.PrintName			= "Flamethrower"			
	SWEP.Slot				= 5
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo			= true
	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/ammo" )

end

SWEP.Author			= "Garry Newman"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Hold left click to let out a burning wave of flames. Fire either on people or the ground as blockades that ignite people when stepped on."

SWEP.Base				= "gmdm_base"
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.05 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.05 )

	if ( !self:CanPrimaryAttack() ) then return end

	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetShootPos() )
		effectdata:SetEntity( self.Weapon )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetNormal( self.Owner:GetAimVector() )
		effectdata:SetAttachment( 1 )
	util.Effect( "flamethrower", effectdata )
	
	self.Owner:Recoil( mathx.Rand( -0.5, 0.5 ), mathx.Rand( -0.5, 0.5 ) )
	self:TakePrimaryAmmo( 1 )
	
if ( SERVER ) then

	local tr = self.Owner:TraceLine( 300.0 )
	
	if ( tr.Entity != NULL && tr.Entity:IsPlayer() ) then
		
		tr.Entity:Ignite( self.Owner )
		
	elseif ( tr.HitWorld ) then
	
		self.LastFlame = self.LastFlame or 0
		
		if ( self.LastFlame < CurTime() && NUM_FIRES < MAX_NUM_FIRES ) then
		
			self.LastFlame = CurTime() + 0.15
			
			// Only lay fire on flat(ish) ground
			if ( Vector( 0, 0, 1 ):Dot( tr.HitNormal ) > 0.25 ) then
		
				local fire = ents.Create( "gmdm_fire" )
					fire:SetPos( tr.HitPos + tr.HitNormal * 32 )
					fire:SetAngles( tr.HitNormal:Angle() )
					fire:SetOwner( self.Owner )
					fire:Spawn()
					fire:Activate()
					
			end
			
		end
	
	end

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

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.1 )
	
	// Launch grenade

end


