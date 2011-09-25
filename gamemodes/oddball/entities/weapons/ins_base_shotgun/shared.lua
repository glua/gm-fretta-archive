if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName		= "COD4ish"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
end

SWEP.Category = "BlackOps"

SWEP.Base		= "ins_base"

SWEP.HoldType			= "ar2"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.ViewModelFlip		= false

SWEP.Drawammo = true
SWEP.DrawCrosshair = true
SWEP.AccurateCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil		= 1.20
SWEP.Primary.DamageMin		= 8
SWEP.Primary.DamageMax		= 18
SWEP.Primary.BulletForce	= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.03
SWEP.Primary.ClipSize		= 60
SWEP.Primary.Delay		= 0.085
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "smg1"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.IronSightsPos = nil 	//		= Vector( X, Y, Z )
SWEP.RunArmAngle = nil 		//		= Vector( 10, -70, 0 )
SWEP.RunArmOffset = nil 	//		= Vector( 10, 16, 16 )

SWEP.CanSprintAndShoot = false

SWEP.SprayTime = 0.2
SWEP.SprayAccuracy = 0.5

SWEP.InsertShellDelay = 0.5

function SWEP:Reload()
	if self.Reloading || self.Owner:GetAmmoCount(self.Primary.Ammo) == 0 then return end
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		self:SetIronsights( false )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
		self.Reloading = true
		timer.Create( "Reload_" .. self.Weapon:EntIndex(), self.InsertShellDelay, 0, self.PerformReload, self )
	end
end

function SWEP:Holster()
	if self.Reloading then
		self.Reloading = false
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
	end
	return true
end

function ENT:OnRemove()
	if self.Reloading then
		self.Reloading = false
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
	end
end

function SWEP:PerformReload()

	if !self.Weapon then return end

	if !self.Reloading then 
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
		return
	end	
	
	if self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
		self.Reloading = false
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
	else
		self.Reloading = true
		if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
		self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
		self.Weapon:SetNextSecondaryFire( CurTime() + self.InsertShellDelay )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.InsertShellDelay-0.1 )
	end
end