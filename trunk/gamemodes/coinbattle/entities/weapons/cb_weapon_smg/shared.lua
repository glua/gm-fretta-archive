
SWEP.Base = "cb_weapon_base"

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Primary.Automatic = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.MaxEnergy = 50
SWEP.Accuracy = 0.04
SWEP.Damage = 6
SWEP.WepKick = Angle(0.85,0.85,0.85)
SWEP.HoldType = "smg"

SWEP.ShootSound = Sound("weapons/smg1/smg1_fire1.wav")

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()
	
	// bail if we can't fire
	if !self:CanAttack() then return false end

	self:TakeAmmo( 1 )
	
	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85

	// shoot bullet
	self:ShootBullet(self.Damage,1,self.Accuracy)
	
	// shoot effects
	self:ShootEffects(self.WepKick)
	
	self:SetNextPrimaryFire( CurTime() + 0.125 )
	
end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()

	self:SetIronsights(!self.Ironsights)
	
	self:SetNextSecondaryFire(CurTime() + 0.3)
	
end

/*-------------------------------------
	SWEP:SetIronSights()
-------------------------------------*/
function SWEP:SetIronsights( b )

	self.Ironsights = b

	if b then

		self.Accuracy = 0.02
		self.Damage = 8
		self.WepKick = Angle(0.5,0.5,0.5)
		if SERVER then
			self.Owner:SetFOV(60,0.25)
		end

	else

		self.Accuracy = 0.04
		self.Damage = 6
		self.WepKick = Angle(0.85,0.85,0.85)
		if SERVER then
			self.Owner:SetFOV(0)
		end

	end

end