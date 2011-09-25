//General Variables\\
SWEP.DrawCrosshair = true
SWEP.Weight = 5
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 60
SWEP.Slot = 2

SWEP.AutoSwitchTo = true


SWEP.FiresUnderwater = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ReloadSound = "Weapon_Pistol.Reload"
SWEP.SlotPos = 0
SWEP.Instructions = "Right Click to zoom"
SWEP.AutoSwitchFrom = false
SWEP.base = "weapon_base"
SWEP.Category = "rifles"
SWEP.DrawAmmo = true
SWEP.PrintName = "sniper laser"
//General Variables\\

//Primary Fire Variables\\
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Spread = 0.0
SWEP.Primary.ClipSize = 4
SWEP.Primary.Force = 500
SWEP.Primary.Damage = 10
SWEP.Primary.Delay = 1.5
SWEP.Primary.Recoil = 1
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Automatic = false
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Sound = "Weapon_Mortar.Single"
//Primary Fire Variables\\

//Secondary Fire Variables\\
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.NumberofShots = 0
SWEP.Secondary.Damage = 15
SWEP.Secondary.Ammo = "Pistol"
SWEP.Secondary.Spread = 0.1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Force = 100
SWEP.Secondary.Recoil = 3
SWEP.Secondary.Sound = "Weapon_Pistol.Single"
SWEP.Secondary.TakeAmmo = 1
SWEP.Secondary.Delay = 0.2
SWEP.Zoomed = false
//Secondary Fire Variables\\

//SWEP:Initialize()\\
function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheSound(self.Secondary.Sound)
	self.Zoomed = false
	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
end
//SWEP:Initialize()\\

//SWEP:PrimaryFire()\\
function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer	= 1									// Show a tracer on every x bullets 
		bullet.TracerName = "AR2Tracer"
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo
	local rnda = self.Primary.Recoil * -1
	local rndb = self.Primary.Recoil * math.random(-1, 1)
	self:ShootEffects()
	self.Owner:FireBullets( bullet )
	self.Weapon:EmitSound(Sound(self.Primary.Sound))
	if !self.Owner:Crouching() then
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	end
	self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.02 )
	
end
//SWEP:PrimaryFire()\\

//SWEP:SecondaryFire()\\
function SWEP:SecondaryAttack()
	
	-- We have already defined Zoomed as being false.
	if (!self.Zoomed) then -- The player is not zoomed in
 
		self.Zoomed = true -- Now he is
		if SERVER then
			self.Owner:SetFOV( 35, 0.3 ) -- SetFOV is serverside only
	
		end
	else -- If he is
 
		self.Zoomed = false -- We tell the SWEP that he is not
		if SERVER then
			self.Owner:SetFOV( 0, 0.3 ) -- Setting to 0 resets the FOV
	
		end
	end

	return false
end
//SWEP:SecondaryFire()\\




