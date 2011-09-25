// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base_sniper"

SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_crossbow.mdl"
SWEP.WorldModel			= "models/weapons/w_crossbow.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Crossbow.Single")
SWEP.Primary.Recoil		= 1
SWEP.Primary.Damage		= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay 		= 0.5

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "XBowBolt"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.IronSightsPos 		= Vector (-6.9575, -13.4387, 3.0843)
SWEP.IronSightsAng 		= Vector (0, 0, 0)
SWEP.RunArmOffset 		= Vector (1.6747, -1.5757, 3.7093)
SWEP.RunArmAngle 			= Vector (-19.0161, 11.682, 0)

SWEP.ScopeZooms			= {8}

SWEP.BoltActionSniper		= true

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	if (self.ActionDelay > CurTime()) then return end 

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self.ActionDelay = CurTime() + 2
		self.Owner:SetFOV(0, 0.15)
		self:SetIronsights(false)

		self.Weapon:EmitSound("Weapon_Crossbow.Reload")
		timer.Simple(1, function() 
			if not IsFirstTimePredicted() then return end
			if not self.Owner:IsNPC() and not self.Owner:Alive() then return end

			local effectdata = EffectData()
				effectdata:SetOrigin(self.Owner:GetShootPos())
				effectdata:SetEntity(self.Weapon)
				effectdata:SetStart(self.Owner:GetShootPos())
				effectdata:SetNormal(self.Owner:GetAimVector())
				effectdata:SetAttachment(1)
			util.Effect("effect_mad_shotgunsmoke", effectdata)

			self.Weapon:EmitSound("Weapon_Crossbow.BoltElectrify") 
		end)

		if not (CLIENT) then
			self.Owner:DrawViewModel(true)
		end

		//self:IdleAnimation(2)
	end
end

/*---------------------------------------------------------
   Name: SWEP:Bolt()
---------------------------------------------------------*/
function SWEP:Bolt()

	if (CLIENT) then return end

	local bolt = ents.Create("ent_mad_arrow")

	if not self.Weapon:GetDTBool(1) then
		local pos = self.Owner:GetShootPos()
			pos = pos + self.Owner:GetForward() * -10
			pos = pos + self.Owner:GetRight() * 9
			pos = pos + self.Owner:GetUp() * -7
		bolt:SetPos(pos)	
	else
		bolt:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() + self.Owner:GetUp() + self.Owner:GetForward() * -10)
	end

	bolt:SetAngles(self.Owner:GetAimVector():Angle())
	bolt:SetOwner(self.Owner)
	bolt:Spawn()

	if (self.Owner:WaterLevel() == 3) then
		bolt:SetVelocity(self.Owner:GetAimVector() * BOLT_WATER_VELOCITY)
	else
		bolt:SetVelocity(self.Owner:GetAimVector() * BOLT_AIR_VELOCITY)
	end
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if (not self:CanPrimaryAttack()) then return end

	self.ActionDelay = (CurTime() + self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		// View model animation
	self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo(1)

	self:Bolt()

	if (not self.Owner:IsNPC()) then
		self.Owner:ViewPunch(Vector(math.Rand(-1, -5), math.Rand(0, 0), math.Rand(0, 0)))
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Owner:GetShootPos())
		effectdata:SetEntity(self.Weapon)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(1)
	util.Effect("effect_mad_shotgunsmoke", effectdata)	

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

	local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

	if (self.Weapon:Clip1() < 1 and not self.Weapon:GetDTBool(1)) then
		timer.Simple(self.Primary.Delay + 0.1, function() 
			if self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
				self:Reload() 
			end
		end)
	end
end