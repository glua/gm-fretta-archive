
SWEP.Base = "cb_weapon_base"

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.MaxEnergy = 15
SWEP.HoldType = "pistol"

SWEP.ShootSound = Sound("weapons/pistol/pistol_fire2.wav")

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()
	
	// bail if we can't fire
	if( !self:CanAttack() ) then return false end

	self:TakeAmmo( 1 )
	
	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85

	// shoot bullet
	self:ShootBullet(12,1,0.01)
	
	// shoot effects
	self:ShootEffects()
	
end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()
	
	// bail if we can't fire
	if( !self:CanAttack(5) ) then return false end

	self:TakeAmmo( 5 )
	
	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85

	// shoot bullet
	self:ShootBullet(12,4,0.04)

	// shoot effects
	self:ShootEffects(Angle(8,0.5,0.5))
	
end
