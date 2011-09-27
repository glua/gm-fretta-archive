// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"
SWEP.HoldType				= "slam"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound		= Sound("npc/roller/mine/rmine_predetonate.wav")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 1

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Slam"

SWEP.Secondary.Delay 		= 2

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

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("npc/roller/mine/rmine_predetonate.wav")
    	util.PrecacheSound("npc/roller/mine/combine_mine_deploy1.wav")
    	util.PrecacheSound("npc/roller/mine/rmine_blip1.wav")
    	util.PrecacheSound("npc/roller/mine/rmine_blip3.wav")
    	util.PrecacheSound("npc/roller/mine/rmine_explode_shock1.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)

	self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay = (CurTime() + self.DeployDelay)

//	self:SetIronsights(false)

	return true
end

/*---------------------------------------------------------
   Name: SWEP:Mine()
---------------------------------------------------------*/
cleanup.Register("Anti-Personal Mine")

function SWEP:Mine()

	if (CLIENT) then return end

	local mine = ents.Create("ent_mad_mine")
	mine.Owner = self.Owner
	local pos = self.Owner:GetShootPos() + self.Owner:GetUp() * -20
	mine:SetPos(pos)	
	mine:SetAngles(self.Owner:GetAngles())
	mine:Spawn()
	mine:Activate()

	undo.Create("Anti-Personal Mine")
		undo.AddEntity(mine)
		undo.SetPlayer(self.Owner)
	undo.Finish()

	self.Owner:AddCleanup("Anti-Personal Mine", mine)

	local phys = mine:GetPhysicsObject()
	phys:SetVelocity(self.Owner:GetAimVector() * 200)
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

//	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		// View model animation
	self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay / 3)

	self:TakePrimaryAmmo(1)

	self:Mine()
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	local ent = self.Owner:GetEyeTrace().Entity

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Delay / 3)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay / 2)

	if ent:GetClass() == "ent_mad_mine" and ent:GetNWEntity("Owner") then
		self.Weapon:EmitSound(self.Primary.Sound, 60, 100)
		timer.Simple(1, function() ent.Boom = true end)
		self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	end
end

/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack()
   Desc: Helper function for checking for no ammo.
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if (self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) or (self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	if (not self.Owner:IsNPC()) and (self.Owner:KeyDown(IN_SPEED)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	return true
end