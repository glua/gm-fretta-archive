// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base_shotgun"

SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_SHOTGUN.Single")
SWEP.Primary.Reload		= Sound("Weapon_SHOTGUN.Reload")
SWEP.Primary.Special		= Sound("Weapon_SHOTGUN.Special1")
SWEP.Primary.Double		= Sound("Weapon_SHOTGUN.Double")
SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 7
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.04
SWEP.Primary.Delay 		= 0.8

SWEP.Primary.ClipSize		= 6					// Size of a clip
SWEP.Primary.DefaultClip	= 6					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.ClipSize		= 1				// Size of a clip
SWEP.Secondary.DefaultClip	= 1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "Gravity"

SWEP.IronSightsPos 		= Vector (-8.9203, -4.7091, 1.7697)
SWEP.IronSightsAng 		= Vector (3.0659, 0.0913, 0)
SWEP.RunArmOffset 		= Vector (3, 0, 2.5)
SWEP.RunArmAngle 			= Vector (-13, 27, 0)

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.3
SWEP.ShotgunBeginReload		= 0.5

SWEP.Type				= 3 					// 1 = Automatic/Semi-Automatic mode, 2 = Suppressor mode, 3 = Burst fire mode
SWEP.Mode				= true

SWEP.data 				= {}
SWEP.data.NormalMsg		= "Switched to single rounds."
SWEP.data.ModeMsg			= "Switched to double rounds."
SWEP.data.Delay			= 0.5
SWEP.data.Cone			= 1
SWEP.data.Damage			= 1
SWEP.data.Recoil			= 1
SWEP.data.Automatic		= false

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/shotgun/shotgun_reload1.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_reload2.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_reload3.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_cock.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_fire6.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_fire7.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_dbl_fire.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_dbl_fire7.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	if self.Weapon:Clip1() > self.Primary.ClipSize then
		self.Weapon:SetClip1(self.Primary.ClipSize)
	end

	if self.Weapon:GetNetworkedBool("Reloading") == true then
		if self.Weapon:GetNetworkedInt("ReloadTime") < CurTime() then
			if self.unavailable then return end

			if (self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 1)
				self.Weapon:SetNextSecondaryFire(CurTime() + 1)
				self.Weapon:SetNetworkedInt("ReloadTime", CurTime() + 1)
				self.Weapon:SetNetworkedBool("Reloading", false)
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

				if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
					self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration())
				end
			else
				self.Weapon:SetNetworkedInt("ReloadTime", CurTime() + 0.5)
				self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
				self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
				self.Weapon:SetClip1(self.Weapon:Clip1() + 1)
				self.Weapon:SetNextPrimaryFire(CurTime() + 1)
				self.Weapon:SetNextSecondaryFire(CurTime() + 1)
				self.Weapon:EmitSound(self.Primary.Reload)

				if (self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
					self.Weapon:SetNextPrimaryFire(CurTime() + 1)
					self.Weapon:SetNextSecondaryFire(CurTime() + 1)
				else
					self.Weapon:SetNextPrimaryFire(CurTime() + 1)
					self.Weapon:SetNextSecondaryFire(CurTime() + 1)
				end
			end
		end
	end

	if self.Owner:KeyPressed(IN_ATTACK) and (self.Weapon:GetNWBool("Reloading", true)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		self.Weapon:SetNetworkedInt("ReloadTime", CurTime() + 1)
		self.Weapon:SetNetworkedBool("Reloading", false)

		timer.Simple(self.Owner:GetViewModel():SequenceDuration(), function()
			if not self.Owner then return end
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

			if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
				self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration())
			end
		end)
	end

	self:SecondThink()

	if self.IdleDelay < CurTime() and self.IdleApply and self.Weapon:Clip1() > 0 then
		local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

		if self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)

			if self.AllowPlaybackRate and not self.Weapon:GetDTBool(1) then
				self.Owner:GetViewModel():SetPlaybackRate(1)
			else
				self.Owner:GetViewModel():SetPlaybackRate(0)
			end		
		end

		self.IdleApply = false
	elseif self.Weapon:Clip1() <= 0 then
		self.IdleApply = false
	end

	if self.Weapon:GetDTBool(1) and self.Owner:KeyDown(IN_SPEED) then
		self:SetIronsights(false)
	end

	// If you're running or if your weapon is holsted, the third person animation is going to change
	if self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0) then
		if self.Rifle or self.Sniper or self.Shotgun then
			if (SERVER) then
				self:SetWeaponHoldType("passive")
			end
		elseif self.Pistol then
			if (SERVER) then
				self:SetWeaponHoldType("normal")
			end
		end
	else
		if (SERVER) then
			self:SetWeaponHoldType(self.HoldType)
		end
	end

	self:NextThink(CurTime())
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

	if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
		self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration() + 0.5)
	end

	if self.Weapon:GetDTBool(3) and (self.Weapon:Clip1() >= 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay + 0.2)
		self.Weapon:EmitSound(self.Primary.Double)
		self:TakePrimaryAmmo(2)
		self.Primary.NumShots = 12

		timer.Simple(0.45, function()
			if not self.Owner or not IsFirstTimePredicted() or self.Weapon:Clip1() == 0 then return end

			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self.Weapon:EmitSound(self.Primary.Special)

			if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
				self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration())
			end
		end)
	else
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.Weapon:EmitSound(self.Primary.Sound)
		self:TakePrimaryAmmo(1)
		self.Primary.NumShots = 8

		timer.Simple(0.3, function()
			if not self.Owner or not IsFirstTimePredicted() or self.Weapon:Clip1() == 0 then return end

			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self.Weapon:EmitSound(self.Primary.Special)

			if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
				self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration())
			end
		end)
	end

	self:ShootBulletInformation()

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
function SWEP:ShootAnimation()

	if self.Weapon:GetDTBool(3) and (self.Weapon:Clip1() >= 2) then
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end