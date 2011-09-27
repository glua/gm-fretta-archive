
SWEP.Base = "cb_weapon_base"

SWEP.Primary.Automatic = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.CanReload = false
SWEP.MaxEnergy = 10
SWEP.HoldType = "melee"

function SWEP:DoAttack(secondary)
	
	if SERVER then self.Owner:LagCompensation( true ) end

	local trace = self.Owner:GetEyeTrace()
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
		
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		local bullet = {
			Num			= 1,
			Src			= self.Owner:GetShootPos(),
			Dir			= self.Owner:GetAimVector(),
			Spread		= Vector( 0, 0, 0 ),
			Tracer		= 1,
			Force		= 10,
			Damage		= 30,
			AmmoType	= "Pistol",
			TracerName	= "",
			Attacker	= self.Owner,
			Inflictor	= self,
			Hull		= HULL_TINY_CENTERED
		}
		self.Weapon:FireBullets( bullet )
		self.Weapon:EmitSound("Weapon_Crowbar.Melee_Hit")
		
		if secondary and trace.Entity:IsValid() then
			local phys = trace.Entity:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocity((self.Owner:GetAimVector()+Vector(0,0,0.5))*1000)
			end
		end
		
	else
		
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Weapon:EmitSound("Zombie.AttackMiss",75)
		
	end
	
	// handle weapon idle times
	if( SERVER ) then

		self.NextIdleTime = CurTime() + self:SequenceDuration()

	end
	
	// some view punching to make it not so static.
	kick = kick or Angle(0.2,0.2,0.2)
	self.Owner:ViewPunch( Angle( math.Rand( -kick.p, kick.p ), math.Rand( -kick.y, kick.y ), math.Rand( -kick.r, kick.r ) ) )

	if SERVER then self.Owner:LagCompensation( false ) end
	
end

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()

	self:DoAttack(false)
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	
end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()
	
	// bail if we can't fire
	if( !self:CanAttack(10) ) then return end

	if( SERVER ) then

		self:TakeAmmo( 10 )
		
		// delay ammo regeneration so we don't have
		// infinite ammo while shooting
		self.NextAmmoRegeneration = CurTime() + 0.85

	end
	
	self:DoAttack(true)
	
end
