// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_magnade.mdl"
SWEP.WorldModel			= "models/weapons/w_magnade.mdl"
SWEP.HoldType				= "grenade"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 1.5

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Grenade"

SWEP.Secondary.ClipSize		= 1				// Size of a clip
SWEP.Secondary.DefaultClip	= 1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "Gravity"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.RunArmOffset 		= Vector (-0.5928, 0, 6.3399)
SWEP.RunArmAngle 			= Vector (-19.4462, -2.5193, 0)

SWEP.Throw 				= CurTime()
SWEP.Primed 			= 0

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

	if self.Throw > CurTime() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Primed != 0 or self.Weapon:GetDTBool(0) then return end

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	local Animation = self.Owner:GetViewModel()
	Animation:SetSequence(Animation:LookupSequence("drawbackhigh"))

	self.Primed = 1
	self.PrimaryThrow = true
	self.Throw = CurTime() + 0.35
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if (self.Throw > CurTime() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Primed != 0 or self.Weapon:GetDTBool(0)) then return end

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	local Animation = self.Owner:GetViewModel()
	Animation:SetSequence(Animation:LookupSequence("drawbacklow"))

	self.Primed = 1
	self.PrimaryThrow = false
	self.Throw = CurTime() + 0.35
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	self:SecondThink()

	if (self.Owner:KeyDown(IN_SPEED) and self.Primed == 0) or self.Weapon:GetDTBool(0) then
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

	if (self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) and self.PrimaryThrow) then
		if self.Throw < CurTime() then
			self.Primed = 2
			self.Throw = CurTime() + 1

			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("throw"))

			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple(0.15, function()	if not self.Owner then return end self:ThrowStickyGrenade() self.Owner:ViewPunch(Vector(math.Rand(1, 2), math.Rand(0, 0), math.Rand(0, 0))) end)
		end
	end

	if (self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK2) and not self.PrimaryThrow) then
		if self.Throw < CurTime() then
			self.Primed = 2
			self.Throw = CurTime() + 1

			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("roll"))

			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple(0.15, function()	if not self.Owner then return end self:ThrowGrenade() self.Owner:ViewPunch(Vector(math.Rand(-1, -2), math.Rand(0, 0), math.Rand(0, 0))) end)
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
   Desc: Weapon wants to holster.
	   Return true to allow the weapon to holster.
---------------------------------------------------------*/
function SWEP:Holster()

	self.Primed = 0
	self.Throw = CurTime()

	return true
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay 	= (CurTime() + self.DeployDelay)
	self.Throw = CurTime() + self.DeployDelay
	self.Primed = 0

	return true
end

/*---------------------------------------------------------
   Name: SWEP:ThrowStickyGrenade()
---------------------------------------------------------*/
function SWEP:ThrowStickyGrenade()

	if (self.Primed != 2 or CLIENT) then return end

	local grenade = ents.Create("ent_mad_sticky_magnade")

	local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 1
		pos = pos + self.Owner:GetRight() * 9

		if self.Owner:KeyDown(IN_SPEED) then
			pos = pos + self.Owner:GetUp() * -4
		else
			pos = pos + self.Owner:GetUp() * -1
		end

	grenade:SetPos(pos)

	grenade:SetAngles(Vector(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
	grenade:SetOwner(self.Owner)
	grenade:Spawn()

	local phys = grenade:GetPhysicsObject()

	if self.Owner:KeyDown(IN_FORWARD) then
		self.Force = 3200
	elseif self.Owner:KeyDown(IN_BACK) then
		self.Force = 2100
	else
		self.Force = 2500
	end

	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 200))

	phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)

	timer.Simple(0.4, function()
		if not self.Owner then return end

		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Primed = 0
		else
			self.Primed = 0
			self.Owner:ConCommand("lastinv")
		end
	end)
end

/*---------------------------------------------------------
   Name: SWEP:ThrowGrenade()
---------------------------------------------------------*/
function SWEP:ThrowGrenade()

	if (self.Primed != 2 or CLIENT) then return end

	local grenade = ents.Create("ent_mad_magnade")

	local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * -10
		pos = pos + self.Owner:GetRight() * 9
		pos = pos + self.Owner:GetUp() * -20

	grenade:SetPos(pos)

	grenade:SetAngles(Vector(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
	grenade:SetOwner(self.Owner)
	grenade:Spawn()

	local phys = grenade:GetPhysicsObject()

	if self.Owner:KeyDown(IN_FORWARD) then
		self.Force = 3200
	elseif self.Owner:KeyDown(IN_BACK) then
		self.Force = 2100
	else
		self.Force = 2500
	end

	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 400))

	phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)

	timer.Simple(0.4, function()
		if not self.Owner then return end

		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Primed = 0
		else
			self.Primed = 0
			self.Owner:ConCommand("lastinv")
		end
	end)
end