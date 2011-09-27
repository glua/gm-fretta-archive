// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.HoldType				= "grenade"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

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

SWEP.GrenadeType			= "ent_mad_grenade"
SWEP.GrenadeName			= "weapon_mad_grenade"
SWEP.GrenadeTime			= "4.5"
SWEP.CookGrenade			= true

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

	if (self.Owner:GetNetworkedInt("Throw") > CurTime() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:GetNetworkedInt("Primed") != 0 or self.Weapon:GetNetworkedBool("Holsted")) then return end

	self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)

	self.Owner:SetNetworkedInt("Primed", 1)
	self.Owner:SetNetworkedInt("Throw", CurTime() + 1)
	self.Owner:SetNetworkedBool("Cooked", false)
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// I used the cooking script of Wizey as an example.
	if not self.CookGrenade then return end
	if self.Owner:GetNetworkedBool("Reloading") then return end
	if self.Owner:GetNetworkedInt("Primed") == 0 then return end
	if self.Owner:GetNetworkedInt("Primed") == 2 then return end

	self.Owner:SetNetworkedBool("Reloading", true)
	timer.Simple(self.GrenadeTime + 0.1, function() if not self.Owner then return end self.Owner:SetNetworkedBool("Reloading", false) end)

	self.Weapon:EmitSound("weapons/grenade/cook.wav", 60)

	self.Owner:SetNetworkedBool("Cooked", true)
	self.NextExplode = CurTime() + self.GrenadeTime

	timer.Simple(self.GrenadeTime, function()
		if not self.Owner then return end 	
		if  not IsFirstTimePredicted() then return end

		if self.Owner:GetNetworkedBool("Cooked") and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == self.GrenadeName and self.Owner:Alive() then
			if self.Owner:GetNetworkedInt("Primed") == 1 then
				local grenade = ents.Create(self.GrenadeType)

				local pos = self.Owner:GetShootPos()
					pos = pos + self.Owner:GetForward() * 1
					pos = pos + self.Owner:GetRight() * 7
	
					if self.Owner:KeyDown(IN_SPEED) then
						pos = pos + self.Owner:GetUp() * -4
					else
						pos = pos + self.Owner:GetUp() * 1
					end

				grenade:SetPos(pos)

				grenade:SetAngles(Vector(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
				grenade:SetOwner(self.Owner)
				grenade:SetNetworkedInt("Cook", 0)
				grenade:Spawn()

				self.Owner:SetNetworkedInt("Primed", 0)
				self.Owner:SetNetworkedBool("Cooked", false)

				timer.Simple(0.6, function()
					if not self.Owner then return end

					if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
						self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
						self.Owner:SetNetworkedInt("Primed", 0)
					else
						self.Owner:SetNetworkedInt("Primed", 0)
						self.Owner:ConCommand("lastinv")
					end
				end)
			end			
		end 
	end)
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	self:SecondThink()

	if (self.Owner:KeyDown(IN_SPEED) and self.Owner:GetNetworkedInt("Primed") == 0) or self.Weapon:GetNetworkedBool("Holsted") then
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

	if (self.Owner:GetNetworkedInt("Primed") == 1 and not self.Owner:KeyDown(IN_ATTACK)) then
		if self.Owner:GetNetworkedInt("Throw") < CurTime() then
			self.Owner:SetNetworkedInt("Primed", 2)
			self.Owner:SetNetworkedInt("Throw", CurTime() + 1.5)

			if not self.Owner:Crouching() then
				self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			end

			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple(0.35, function()	if not self.Owner then return end self:ThrowGrenade() self.Owner:ViewPunch(Vector(math.Rand(1, 2), math.Rand(0, 0), math.Rand(0, 0))) end)
		end
	end

	if self.Owner:GetNetworkedBool("Cooked") and self.Owner:GetNetworkedBool("LastShootCook") < CurTime() then
		if ((SinglePlayer() and SERVER) or CLIENT) then
			self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
			self.Owner:EmitSound("NPC_CombineCamera.Click")
		end

		self.Owner:SetNetworkedBool("LastShootCook", CurTime() + 1)
	end
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
   Desc: Weapon wants to holster.
	   Return true to allow the weapon to holster.
---------------------------------------------------------*/
function SWEP:Holster()

	self.Owner:SetNetworkedInt("Primed", 0)
	self.Owner:SetNetworkedInt("Throw", CurTime())

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
	self.Owner:SetNetworkedInt("Throw", CurTime() + self.DeployDelay)

	self.Owner:SetNetworkedBool("LastShootCook", CurTime())

	return true
end

/*---------------------------------------------------------
   Name: SWEP:ThrowGrenade()
---------------------------------------------------------*/
function SWEP:ThrowGrenade()

	if (self.Owner:GetNetworkedInt("Primed") != 2 or CLIENT) then return end

	if self.CookGrenade and not self.Owner:GetNetworkedBool("Cooked") then
		self.NextExplode = CurTime() + self.GrenadeTime
		self.Weapon:EmitSound("weapons/grenade/cook.wav", 60)
	end

	local grenade = ents.Create(self.GrenadeType)

	if self.CookGrenade then
		self.Owner:SetNetworkedBool("Cooked", false)

		local RemainingTime = self.NextExplode - CurTime()
		grenade:SetNetworkedInt("Cook", CurTime() + RemainingTime)
	end

	local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetRight() * 7

		if self.Owner:KeyDown(IN_SPEED) and not self.Owner:Crouching() then
			pos = pos + self.Owner:GetUp() * -4
		elseif not self.Owner:Crouching() then
			pos = pos + self.Owner:GetForward() * -6
			pos = pos + self.Owner:GetUp() * 1
		else
			pos = pos + self.Owner:GetForward() * 1
			pos = pos + self.Owner:GetUp() * -24
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

	if not self.Owner:Crouching() then
		phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 200))
	else
		phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 0))
	end

	phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)

	timer.Simple(0.6, function()
		if not self.Owner then return end

		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Owner:SetNetworkedInt("Primed", 0)
		else
			self.Owner:SetNetworkedInt("Primed", 0)
//			self.Weapon:Remove()
			self.Owner:ConCommand("lastinv")
		end
	end)
end