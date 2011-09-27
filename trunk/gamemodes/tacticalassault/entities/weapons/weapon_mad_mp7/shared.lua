// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.HoldType				= "smg"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_SMG1.Single")
SWEP.Primary.Reload 		= Sound("Weapon_SMG1.Reload")
SWEP.Primary.Recoil		= 0.75
SWEP.Primary.Damage		= 7
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.013
SWEP.Primary.Delay 		= 0.075

SWEP.Primary.ClipSize		= 40					// Size of a clip
SWEP.Primary.DefaultClip	= 40					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "SMG1"

SWEP.Secondary.ClipSize		= 1				// Size of a clip
SWEP.Secondary.DefaultClip	= 1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "Gravity"

SWEP.ShellEffect			= "none"	// "none" or "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-6.4318, -2.0031, 2.5371)
SWEP.IronSightsAng 		= Vector (0, 0, 0)
SWEP.RunArmOffset 		= Vector (9.071, 0, 1.6418)
SWEP.RunArmAngle 			= Vector (-12.9765, 26.8708, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/smg1/smg1_fire1.wav")
    	util.PrecacheSound("weapons/smg1/smg1_reload.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	if (self.ActionDelay > CurTime()) then return end 

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self.Owner:SetFOV( 0, 0.15 )
		self:SetIronsights(false)
		self.Weapon:EmitSound(self.Primary.Reload)
	end
end