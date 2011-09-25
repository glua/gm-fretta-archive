-- Read the weapon_real_base if you really want to know what each action does.
-- Read the weapon_real_cs_pumpshotgun if you really want to know how shotguns work.

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if (CLIENT) then
	SWEP.PrintName 		= "BENELLI M4 SUPER 90"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "B"

	killicon.AddFont("weapon_real_cs_xm1014", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_grenade" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "rg_shelleject_shotgun" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models

SWEP.EjectDelay			= 0.1
/*-------------------------------------------------------*/

SWEP.Instructions 		= "Buckshot Damage (Per buckshot lead): 7.5% \nSlug Damage (Per slug): 77% \nRecoil: 60% \nBuckshot Precision: 55% \nSlug Precision: 85% \nType: Semi-Automatic \n\nChange Mode: E + Right Click"

SWEP.Base 				= "weapon_real_cs_pumpshotgun"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel 			= "models/weapons/w_shot_xm1014.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_XM1014.Single")
SWEP.Primary.Recoil 		= 6
SWEP.Primary.Damage 		= 7.5
SWEP.Primary.NumShots 		= 12
SWEP.Primary.Cone 		= 0.045
SWEP.Primary.ClipSize 		= 6
SWEP.Primary.Delay 		= 0.25
SWEP.Primary.DefaultClip 	= 6
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "buckshot"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (5.1536, -3.817, 2.1621)
SWEP.IronSightsAng 		= Vector (-0.1466, 0.7799, 0)

SWEP.data 				= {}
SWEP.mode 				= "burst"
SWEP.data.newclip 		= false

SWEP.data.burst 			= {}
SWEP.data.burst.Delay 		= .3
SWEP.data.burst.Cone 		= 0.045
SWEP.data.burst.NumShots 	= 12
SWEP.data.burst.Damage 		= 7.5

SWEP.data.semi 			= {}
SWEP.data.semi.Delay 		= .3
SWEP.data.semi.Cone 		= 0.015
SWEP.data.semi.NumShots 	= 1
SWEP.data.semi.Damage 		= 77

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:KeyDown(IN_USE) then
		if self.mode == "semi" then
			self.mode = "burst"
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Buckshot Rounds" )
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			timer.Simple(0.5, function() self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) end)
		else
			self.mode = "semi"
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Slug Rounds" )
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			timer.Simple(0.5, function() self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) end)
		end
		self.data[self.mode].Init(self)

	elseif SERVER then
		end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.Weapon:Clip1() > self.Primary.ClipSize then
		self.Weapon:SetClip1(self.Primary.ClipSize)
	end

	if self.Weapon:GetNetworkedBool( "reloading") == true then
	
		if self.Weapon:GetNetworkedInt( "reloadtimer") < CurTime() then
			if self.unavailable then return end

			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
				self.Weapon:SetNetworkedBool( "reloading", false)
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			else
			
			self.Weapon:SetNetworkedInt( "reloadtimer", CurTime() + 0.45 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)

				if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0) then
					self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
					self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
				else
					self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
					self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
				end
			end
		end
	end

	self:IronSight()

	if self.Owner:KeyPressed(IN_ATTACK) and (self.Weapon:GetNWBool("reloading", true)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNetworkedBool( "reloading", false)
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
	end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end

	self:SetIronsights(false)

	if (self.Weapon:GetNWBool("reloading", false)) or ShotgunReloading then return end

	if (self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
			ShotgunReloading = true
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		timer.Simple(0.5, function()
			ShotgunReloading = false
			self.Weapon:SetNetworkedBool("reloading", true)
			self.Weapon:SetVar("reloadtimer", CurTime() + 1)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		end)
	end

	self.Owner:SetFOV( 0, 0.15 )
	-- Zoom = 0

	self:SetIronsights(false)
	-- Set the ironsight to false
end