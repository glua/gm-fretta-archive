
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "physgun"

if ( CLIENT ) then

	SWEP.PrintName			= "Egon"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo			= true
	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/ammo" )

end

SWEP.Base				= "gmdm_base"
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel			= "models/weapons/w_physics.mdl"
SWEP.CustomSecondaryAmmo = true

local sndPowerUp		= Sound("Airboat.FireGunHeavy")
local sndAttackLoop 	= Sound("Airboat_fan_idle")
local sndPowerDown		= Sound("Town.d1_town_02a_spindown")
local sndNoAmmo			= Sound("Weapon_Shotgun.Empty")

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	self:SetSkin(1)
	self:GMDMInit()
	
end

function SWEP:FirstTimePickup( Owner )
	self.Owner:SetCustomAmmo( "egonenergy", 100 )	
end

function SWEP:HasUsableAmmo( )
	return self.Owner:GetCustomAmmo( "egonenergy" ) > 0
end


/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Attacking = false

function SWEP:Think()

	if (!self.Owner || self.Owner == NULL ) then return end
	if ( !self:CanShootWeapon() ) then if( self.Attacking ) then self:EndAttack( false ) end return end
	
	if ( self.Owner:GetCustomAmmo( "egonenergy" ) <= 0 ) then
	
		if ( self.Owner:KeyPressed( IN_ATTACK ) and self.Attacking == true ) then
			self.Weapon:EmitSound( sndNoAmmo )
		end
		
		self:EndAttack( false )
		return
		
	end
	
	if( self.Owner:KeyDown( IN_ATTACK ) and self.Owner:KeyDown( IN_SPEED ) and self.Attacking == true ) then
		self:EndAttack( false )
		return
	elseif ( self.Owner:KeyPressed( IN_ATTACK ) || self.Owner:KeyPressed( IN_ATTACK2 ) ) then
	
		self:StartAttack()
		return
		
	elseif ( self.Owner:KeyDown( IN_ATTACK ) || self.Owner:KeyDown( IN_ATTACK2 ) ) then
	
		self:UpdateAttack()
		return
		
	elseif ( self.Owner:KeyReleased( IN_ATTACK ) || self.Owner:KeyReleased( IN_ATTACK2 )) then
	
		self:EndAttack( true )
		return
		
	end

end



function SWEP:StartAttack()

	if ( !self:CanShootWeapon() ) then return end
	
	if (SERVER) then
		
		if (!self.Beam) then
			self.Beam = ents.Create( "egon_beam" )
				self.Beam:SetPos( self.Owner:GetShootPos() )
			self.Beam:Spawn()
		end
		
		self.Beam:SetParent( self.Owner )
		self.Beam:SetOwner( self.Owner )
	
	end

	self.Attacking = true
	self:UpdateAttack()
	self.Weapon:EmitSound( sndPowerUp )
	self.Weapon:EmitSound( sndAttackLoop )

end

function SWEP:UpdateAttack()
	
	if ( !self:CanShootWeapon() or self.Attacking == false ) then self:EndAttack( false ) return end
	--if ( !self:CanPrimaryAttack() ) then self:EndAttack() return end
	if ( self.Timer && self.Timer > CurTime() ) then return end
	
	self.Timer = CurTime() + 0.05
	
	self.Owner:AddCustomAmmo( "egonenergy", -1 )
	
	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 4096)
		trace.filter = { self.Owner, self.Weapon }
		
	local tr = util.TraceLine( trace )
	
	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( tr.HitPos )
	end
	
	--util.BlastDamage( self.Weapon, self.Owner, tr.HitPos, 80, 5 )
	
	if ( ValidEntity( tr.Entity ) && ( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) ) then
		
		if( SERVER ) then
			--tr.Entity:TakeDamage( 15, self.Owner, self )
			self:GMDMShootBullet( 10, nil, -2, 0.0 )
		end
			
		local effectdata = EffectData()
			effectdata:SetEntity( tr.Entity )
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetNormal( tr.HitNormal )
		util.Effect( "bodyshot", effectdata )
	
	elseif( ValidEntity( tr.Entity ) && string.find( tr.Entity:GetClass(), "prop_physics" ) != nil ) then
		local entphys = tr.Entity:GetPhysicsObject();
		
		if( entphys and entphys:IsValid() ) then
			entphys:ApplyForceOffset( self.Owner:GetAimVector():GetNormalized() * 15000, tr.Entity:WorldToLocal( tr.HitPos ) );
		end
	end

end

function SWEP:EndAttack( shutdownsound )
	
	self.Weapon:StopSound( sndAttackLoop )
	
	if ( shutdownsound ) then
		self.Weapon:EmitSound( sndPowerDown )
	end
	
	self.Attacking = false
	
	if ( CLIENT ) then return end
	if ( !self.Beam ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
end

function SWEP:Holster()
	self:EndAttack( false )
	return true
end

function SWEP:OnRemove()
	self:EndAttack( false )
	return true
end


function SWEP:PrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:CustomAmmoCount()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	return self.Owner:GetCustomAmmo( "egonenergy" )
	
end

