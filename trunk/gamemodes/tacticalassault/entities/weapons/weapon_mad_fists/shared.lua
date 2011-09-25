// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFOV			= 47
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_punch.mdl"
SWEP.WorldModel			= "models/weapons/w_fists_t.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound		= Sound("")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 0.35

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Delay 		= 0.40

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.ComboActivated		= false 
SWEP.QuickHittingTime		= 0

SWEP.IronSightsPos 		= Vector (0.001, -6.7271, 5.4635)
SWEP.IronSightsAng 		= Vector (-55.5761, -2.6453, 0)
SWEP.RunArmOffset 		= Vector (-0.3561, 0, 5.9544)
SWEP.RunArmAngle 		= Vector (-28.873, -1.6004, 0)
SWEP.DamageMul 		= 20

SWEP.ComboHit = {
	Sound("physics/body/body_medium_break2.wav"),
	Sound("physics/body/body_medium_break3.wav")
}

SWEP.Hit = {
	Sound("physics/body/body_medium_impact_hard1.wav"),
	Sound("physics/body/body_medium_impact_hard2.wav"),
	Sound("physics/body/body_medium_impact_hard3.wav"),
	Sound("physics/body/body_medium_impact_hard4.wav"),
	Sound("physics/body/body_medium_impact_hard5.wav"),
	Sound("physics/body/body_medium_impact_hard6.wav")
}
	
SWEP.Swing = {
	Sound("weapons/slam/throw.wav")
}
	
SWEP.PushElse = {
	Sound("physics/body/body_medium_impact_hard1.wav"),
	Sound("physics/body/body_medium_impact_hard2.wav"),
	Sound("physics/body/body_medium_impact_hard3.wav"),
	Sound("physics/body/body_medium_impact_hard4.wav"),
	Sound("physics/body/body_medium_impact_hard5.wav"),
	Sound("physics/body/body_medium_impact_hard6.wav")
}

SWEP.DoorHit = {
  	Sound("physics/wood/wood_crate_impact_hard2.wav"),
}

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

	util.PrecacheSound("physics/body/body_medium_break2.wav")
	util.PrecacheSound("physics/body/body_medium_break3.wav")
	util.PrecacheSound("physics/body/body_medium_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet4.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet5.wav")
	util.PrecacheSound("physics/body/body_medium_impact_hard1.wav")
	util.PrecacheSound("physics/body/body_medium_impact_hard2.wav")
	util.PrecacheSound("physics/body/body_medium_impact_hard3.wav")
	util.PrecacheSound("physics/body/body_medium_impact_hard4.wav")
	util.PrecacheSound("physics/body/body_medium_impact_hard5.wav")
	util.PrecacheSound("physics/body/body_medium_impact_hard6.wav")
	util.PrecacheSound("weapons/slam/throw.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Initialize()
   Desc: Called when the weapon is first loaded.
---------------------------------------------------------*/
function SWEP:Initialize()

	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)

		self:SetNPCMinBurst(30)
		self:SetNPCMaxBurst(30)
		self:SetNPCFireRate(self.Primary.Delay)
	end
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay = (CurTime() + self.DeployDelay)

	return true
end

/*---------------------------------------------------------
   Name: SWEP:SecondThink()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:SecondThink()

	if self:GetNWInt("Right") >= 2 then
		self.ComboActivated = true
	elseif self:GetNWInt("Left") >= 2 then
		self.ComboActivated = true
	end
	
	if (CurTime() < self.QuickHittingTime) then
		self.Primary.Delay 	= 0.2
		self.Secondary.Delay	= 0.2
	else
		self.Primary.Delay	= 0.35
		self.Secondary.Delay	= 0.40
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

	local ExtraDamage = 2 * ((self:GetNWInt("Left") + self:GetNWInt("Right")) / 2)

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 50)
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine(tr)

	if (trace.Hit) then
		if trace.Entity:GetClass() == "func_door_rotating" or trace.Entity:GetClass() == "prop_door_rotating" then
			self.Primary.Automatic = false
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			if SERVER then
				self.Owner:EmitSound(self.DoorHit[math.random(1, #self.DoorHit)])
			end
		elseif self.ComboActivated then
			self.Weapon:EmitSound(self.Hit[math.random(#self.Hit)])

			if (SERVER) then
				trace.Entity:SetVelocity((trace.Entity:GetPos() - self.Owner:GetPos()) * 15)
			end

			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = (1.5 + ExtraDamage) * self.DamageMul
			self.Owner:FireBullets(bullet) 

			self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

			timer.Simple(0.07, function() self.Owner:ViewPunch(Angle(-20, 10, 0)) end)

			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
				self.Weapon:EmitSound(self.ComboHit[math.random(#self.ComboHit)])
			end

			self:SetNWInt("Left", 0)
			self:SetNWInt("Right", 0)

			self.ComboActivated = false
		else
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
				self:SetNWInt("Left", self:GetNWInt("Left") + 1)
			end

			self.Weapon:EmitSound(self.Hit[math.random(#self.Hit)])

			if (SERVER) then
				trace.Entity:SetVelocity((trace.Entity:GetPos() - self.Owner:GetPos()) * 7)
			end

			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = (1 + ExtraDamage) * self.DamageMul
			self.Owner:FireBullets(bullet)

			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Owner:ViewPunch(Angle(-1.5, -2.0, 0))
		end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Weapon:EmitSound(self.Swing[math.random(#self.Swing)], 75, math.random(80, 120))
		self.Owner:ViewPunch(Angle(-1, -1.5, 0))
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self.QuickHittingTime = (CurTime() + 0.3)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if (not self:CanPrimaryAttack()) then return end

	local ExtraDamage = 2 * ((self:GetNWInt("Left") + self:GetNWInt("Right")) / 2)

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 50)
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine(tr)

	if (trace.Hit) then
		if trace.Entity:GetClass() == "func_door_rotating" or trace.Entity:GetClass() == "prop_door_rotating" then
			self.Primary.Automatic = false
			self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

			if SERVER then
				self.Owner:EmitSound(self.DoorHit[math.random(1, #self.DoorHit)])
			end
		elseif self.ComboActivated then
			self.Weapon:EmitSound(self.Hit[math.random(#self.Hit)])

			if (SERVER) then
				trace.Entity:SetVelocity((trace.Entity:GetPos() - self.Owner:GetPos()) * 10 + Vector(0, 0, 25))
			end

			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = (2 + ExtraDamage) * self.DamageMul
			self.Owner:FireBullets(bullet) 

			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			timer.Simple(0.07, function() self.Owner:ViewPunch(Angle(-20, -15, 0)) end)

			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
				self.Weapon:EmitSound(self.ComboHit[math.random(#self.ComboHit)])
			end

			self:SetNWInt("Left", 0)
			self:SetNWInt("Right", 0)

			self.ComboActivated = false
		else
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
				self:SetNWInt("Right", self:GetNWInt("Right") + 1)
			end

			self.Weapon:EmitSound(self.Hit[math.random(#self.Hit)])

			if (SERVER) then
				trace.Entity:SetVelocity((trace.Entity:GetPos() - self.Owner:GetPos()) * 5 + Vector(0, 0, 25))
			end

			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage =( 1.5 + ExtraDamage) * self.DamageMul
			self.Owner:FireBullets(bullet)

			self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self.Owner:ViewPunch(Angle(-1.5, 2.0, 0))
		end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self.Weapon:EmitSound(self.Swing[math.random(#self.Swing)], 100, math.random(95, 105))
		self.Owner:ViewPunch(Angle(-1.5, 2.0, 0))
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self.QuickHittingTime = (CurTime() + 0.3)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack()
   Desc: Helper function for checking for no ammo.
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if (not self.Owner:IsNPC()) and (self.Owner:KeyDown(IN_SPEED)) or (self.Weapon:GetDTBool(0)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	return true
end