// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFOV			= 80
SWEP.ViewModel			= "models/items/v_medkit2.mdl"
SWEP.WorldModel			= "models/items/w_medkit.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("HealthVial.Touch")
SWEP.Secondary.Sound 		= Sound("WeaponFrag.Throw")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 2

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

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

//SWEP.RunArmOffset 		= Vector (0.041, 0, 5.6778)
//SWEP.RunArmAngle 		= Vector (-17.6901, 0.321, 0)

SWEP.Power				= 0

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("items/smallmedkit1.wav")
    	util.PrecacheSound("weapons/slam/throw.wav")
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
cleanup.Register("Medic Kit")

function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetNetworkedBool("Holsted", false)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if not IsFirstTimePredicted() then return end
	if self.ActionDelay > CurTime() then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.ActionDelay = (CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER) 			// View model animation

	timer.Simple(1, function()
		if (not self.Owner:Alive() or self.Weapon:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_medic" or not IsFirstTimePredicted()) then return end
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW) 			// View model animation
	end)

	timer.Simple(0.75, function()
		self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

		if (SERVER) then
			self.Weapon:EmitSound(self.Secondary.Sound)
		end

		if (CLIENT) then return end

		local health = ents.Create("ent_mad_medic")

		health.Owner = self.Owner
		
		local pos = self.Owner:GetShootPos() + self.Owner:GetUp() * -12.5
		health:SetPos(pos)	
		
		health:SetAngles(self.Owner:GetAngles())
		health:Spawn()

		undo.Create("Medic Kit")
			undo.AddEntity(health)
			undo.SetPlayer(self.Owner)
		undo.Finish()

		self.Owner:AddCleanup("Medic Kit", health)

		local phys = health:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * 200)
	end)
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
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
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()
end