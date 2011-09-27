
AddCSLuaFile( "shared.lua" )

if SERVER then
	resource.AddFile('sound/claustrophobia/hammer.wav')
	resource.AddFile('sound/claustrophobia/hammer_end.wav')
end

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Breaks rocks really good, doesn't kill players."

SWEP.PrintName			= "Rock Breaker"
SWEP.Slot				= 0
SWEP.SlotPos			= 10
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon   = false
SWEP.SwayScale			= 1.0
SWEP.BobScale			= 1.0

SWEP.HoldType				= "rpg"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_RPG.mdl"
SWEP.WorldModel		= "models/weapons/w_rocket_launcher.mdl"
SWEP.AnimPrefix		= "python"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Play shoot sound
	self.Weapon:EmitSound("claustrophobia/hammer.wav",100,100)

	self:ShootBullet( 50, 1, 0.0 )
	
	// Punch the player's view
	local rand = { math.random(6)-3,math.random(6)-3,math.random(6)-3 }
	util.ScreenShake( self:GetPos(), 10, 1, 1, 256 )

	self.Owner:ViewPunch( Angle( 0,0, rand[3] ) )
	
	self:SetNextPrimaryFire( CurTime() + 0.1 )

end

function SWEP:SecondaryAttack()
	return false
end

/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

end


/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootBullet( damage, num_bullets, aimcone )
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		// Aim Cone
	bullet.Tracer	= 1									// Show a tracer on every x bullets 
	bullet.Force	= 10								// Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.HullSize = 2
	bullet.TracerName = "AirboatGunHeavyTracer"
	
	self.Owner:FireBullets( bullet )
	
	self:ShootEffects()
	
end

SWEP.Attacking = false

function SWEP:Think()
	if ( self.Owner:KeyReleased( IN_ATTACK ) ) then
		self.Weapon:EmitSound("claustrophobia/hammer_end.wav",50,100)
	end

end