// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("NPC_Helicopter.FireRocket")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 2

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "RPG_Round"

SWEP.Secondary.ClipSize		= 1				// Size of a clip
SWEP.Secondary.DefaultClip	= 1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "Gravity"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-15.5715, -30.8025, 2.9072)
SWEP.IronSightsAng 		= Vector (0, 0, 0)
SWEP.RunArmOffset 		= Vector (7.6581, -13.4056, 1.4333)
SWEP.RunArmAngle 			= Vector (-14.4149, 29.214, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/stinger_fire1.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Rocket()
---------------------------------------------------------*/
function SWEP:Rocket()

	if (CLIENT) then return end

	local rocket = ents.Create("ent_mad_rocket")

	rocket:SetOwner(self.Owner)
		
	local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 17.5
		pos = pos + self.Owner:GetRight() * 20
		pos = pos + self.Owner:GetUp() * 0
	rocket:SetPos(pos)	
		
	rocket:SetAngles(self.Owner:GetAngles())
	rocket.Number = 1
	rocket:Spawn()
	rocket:Activate()
end

/*---------------------------------------------------------
   Name: SWEP:DoubleRocket()
---------------------------------------------------------*/
function SWEP:DoubleRocket()

	if (CLIENT) then return end

	local rocket = ents.Create("ent_mad_rocket")

	rocket:SetOwner(self.Owner)
		
	local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 17.5
		pos = pos + self.Owner:GetRight() * 20
		pos = pos + self.Owner:GetUp() * 0
	rocket:SetPos(pos)	
		
	rocket:SetAngles(self.Owner:GetAngles())
	rocket.Number = 2
	rocket:Spawn()
	rocket:Activate()
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

	self:SetIronsights(false)

	if self.Weapon:Clip1() == 2 then
		self:TakePrimaryAmmo(1)

		timer.Simple(0.1, function()
			if not self.Owner then return end
			if not IsFirstTimePredicted() then return end
			self:TakePrimaryAmmo(1)
			self:DoubleRocket()
			self.Weapon:EmitSound(self.Primary.Sound)
			self.Owner:ViewPunch(Vector(math.Rand(-30, -35), math.Rand(0, 0), math.Rand(0, 0)))	
		end)

		self:DoubleRocket()

		self.Weapon:EmitSound(self.Primary.Sound)
		self.Owner:ViewPunch(Vector(math.Rand(-30, -35), math.Rand(0, 0), math.Rand(0, 0)))	
	else
		self:TakePrimaryAmmo(1)
		self:Rocket()

		self.Weapon:EmitSound(self.Primary.Sound)
		self.Owner:ViewPunch(Vector(math.Rand(-20, -35), math.Rand(0, 0), math.Rand(0, 0)))	
	end

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

	local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

	if (self.Weapon:Clip1() < 1) then
		timer.Simple(self.Primary.Delay + 0.1, function() 
			if self.Owner and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
				self:Reload() 
			end
		end)
	end
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

// Experimental test: two rockets at the same time.
/*
	if self.Weapon:Clip1() == self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.ActionDelay = (CurTime() + self.Primary.Delay)
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)

		timer.Simple(1, function() 
			if not self.Owner then return end
			if not IsFirstTimePredicted() then return end
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1)
			self.Owner:RemoveAmmo(1, self.Weapon:GetPrimaryAmmoType())
		end)
	end
*/
end