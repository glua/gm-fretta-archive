
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base		    = "gmdm_base"
SWEP.PrintName			= "SWARE Velocity Gun"			
SWEP.Slot				= 1
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel		= "models/weapons/v_357.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

SWEP.HoldType = "pistol"

SWEP.Primary.ClipSize		= -1				-- Size of a clip
SWEP.Primary.DefaultClip	= -1				-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false				-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"
SWEP.ShootSound = Sound( "Weapon_AR2.Single" )

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1.3 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.1 )

	if ( not self:CanShootWeapon() ) then return end
	--if ( not self:CanPrimaryAttack() ) then return end

	self.Weapon:EmitSound(self.ShootSound)
	
	self:ShootBullet( 0, 1, 0.0 )
	
	-- Punches the player's view.
	self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
	
	if ( SERVER ) then
	
		-- Make the player fly upwards.
		self.Owner:SetGroundEntity( NULL )
		self.Owner:SetVelocity( self.Owner:GetVelocity()*-1 + self.Owner:GetAimVector() * -250 )
		
		local trace = self.Owner:GetEyeTrace()
		if trace.Entity:IsPlayer() then
			trace.Entity:SetGroundEntity( NULL )
			trace.Entity:SetVelocity(trace.Entity:GetVelocity()*-1 + Vector(0,0,375))
		end
	end

end

SWEP.Secondary.ClipSize		= -1				-- Size of a clip
SWEP.Secondary.DefaultClip	= -1				-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= false			-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire( CurTime() + 3 )

end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation

end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()			-- Source
	bullet.Dir 		= self.Owner:GetAimVector()			-- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	bullet.Tracer	= 1									-- Show a tracer on every x bullets 
	bullet.Force	= 5						-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.HullSize = 2
	bullet.TracerName = "SWARE_FlashTrace"
	
	self.Owner:FireBullets( bullet )
	
	self:ShootEffects()
	
end
