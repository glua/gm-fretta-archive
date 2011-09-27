
SWEP.Base = "cb_weapon_base"

SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.MaxEnergy = 32
SWEP.HoldType = "shotgun"

SWEP.ShootSound = Sound("weapons/shotgun/shotgun_fire6.wav")

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()
	
	// bail if we can't fire
	if !self:CanAttack( 4 ) then return false end

	self:TakeAmmo( 4 )
	
	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85

	// shoot bullet
	self:ShootBullet(3,8,0.08)
	
	// shoot effects
	self:ShootEffects(Angle(8,0.85,0.85))
	
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	self:SetNextSecondaryFire(CurTime()+1)
	
end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()
	
	// bail if we can't fire
	if( !self:CanAttack(16) ) then return false end

	self:TakeAmmo( 16 )
	
	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85

	// shoot bullet
	self:ShootBullet(5,8,0.08)
	
	// shoot effects
	self:ShootEffects(Angle(8,0.85,0.85))
	
	self:SetNextPrimaryFire(CurTime()+0.5)
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	self.Owner:SetVelocity(self.Owner:GetAimVector()*-400)
	
end
