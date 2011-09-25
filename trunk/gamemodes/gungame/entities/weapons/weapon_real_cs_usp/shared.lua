/*---------------------------------------------------------*/
local HitImpact = function(attacker, tr, dmginfo)

	local hit = EffectData()
	hit:SetOrigin(tr.HitPos)
	hit:SetNormal(tr.HitNormal)
	hit:SetScale(20)
	util.Effect("effect_hit", hit)

	return true
end
/*---------------------------------------------------------*/

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "pistol"
end

if (CLIENT) then
	SWEP.PrintName 		= "HK USP .45"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "a"

	killicon.AddFont("weapon_real_cs_usp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.ShellEffect			= "rg_shelleject" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models

SWEP.EjectDelay			= 0.05
/*-------------------------------------------------------*/

SWEP.Instructions 		= "Damage: 20% \nRecoil: 10% \nPrecision: 85.5% \nType: Semi-Automatic \n\nSilence Mode: E + Left Click"

SWEP.Base 				= "weapon_real_base_special_aim"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_USP.Single")
SWEP.Primary.Damage 		= 20
SWEP.Primary.Recoil 		= 1
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0155
SWEP.Primary.ClipSize 		= 12
SWEP.Primary.Delay 		= 0.16
SWEP.Primary.DefaultClip 	= 12
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "pistol"

SWEP.IronSightsPos 		= Vector (3.963, -3.271, 1.7058)
SWEP.IronSightsAng 		= Vector (1.5025, 0.6891, 0)

SWEP.data 				= {}

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
	end

	self.Reloadaftershoot = 0

	self.data[self.mode].Init(self)
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.data.init then		
		self.data.init = nil
	end

	if self.deployed then
		if self.deployed == 0 then
			if self.data.silenced then
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
			else
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			end
			self.deployed = false
			self.Weapon:SetNextPrimaryFire( CurTime() + .001 )
		else
			self.deployed = self.deployed - 1
		end
	end

	if (self:GetIronsights() == true) then
			self.DrawCrosshair = true
	else
			self.DrawCrosshair = false
	end

	self:IronSight()
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if !self.Owner:KeyDown(IN_USE) then

		if not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 2 then return end
		-- If your gun have a problem or if you are under water, you'll not be able to fire

		self.Reloadaftershoot = CurTime() + self.Primary.Delay
		-- Set the reload after shoot to be not able to reload when firering

		self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
		-- Set next secondary fire after your fire delay

		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		-- Set next primary fire after your fire delay

		self:TakePrimaryAmmo(1)
		-- Take 1 ammo in you clip

		self.Weapon:EmitSound(self.Primary.Sound)
		-- Emit the gun sound when you fire
		
		self:RecoilPower()

	else
		if self.data.silenced then
			self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
			self.Primary.Sound			= Sound("Weapon_USP.Single")
			self.data.silenced 			= false
		else
			self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
			self.Primary.Sound			= Sound("Weapon_USP.SilencedShot")
 			self.data.silenced 			= true
		end
		self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
		self.Reloadaftershoot = CurTime() + 3
	end

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end


/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end 
	-- If you're firering, you can't reload

	if not ValidEntity(self.Owner) then return end

	if self.data.silenced then
		self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
	else
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	end

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then

		self.Owner:SetFOV( 0, 0.15 )
		-- Zoom = 0

		self:SetIronsights(false)
		-- Set the ironsight to false
	end

	return true
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	if self.data.silenced then
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	end

	self.Reloadaftershoot = CurTime() + 1
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	return true
end

/*---------------------------------------------------------
ShootBullet
---------------------------------------------------------*/
function SWEP:CSShootBullet(dmg, recoil, numbul, cone)
	numbul = numbul or 1
	cone = cone or 0.01

	local bullet = {}
	bullet.Num  = numbul
	bullet.Src = self.Owner:GetShootPos()       	-- Source
	bullet.Dir = self.Owner:GetAimVector()      	-- Dir of bullet
	bullet.Spread = Vector(cone, cone, 0)     	-- Aim Cone
	bullet.Tracer = 1       				-- Show a tracer on every x bullets
	bullet.Force = 0.5 * dmg     				-- Amount of force to give to phys objects
	bullet.Damage = dmg					-- Amount of damage to give to the bullets
	bullet.Callback 	= HitImpact

	self.Owner:FireBullets(bullet)
	if self.data.silenced then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
		self.MuzzleEffect			= "rg_muzzle_silenced"
	else
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:MuzzleFlash()
		self.MuzzleEffect			= "rg_muzzle_pistol"
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(self.MuzzleAttachment)
	util.Effect(self.MuzzleEffect,fx)						-- Additional muzzle effects
	
	timer.Simple( self.EjectDelay, function()
		if  not IsFirstTimePredicted() then 
			return
		end

			local fx 	= EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetNormal(self.Owner:GetAimVector())
			fx:SetAttachment(self.ShellEjectAttachment)

			util.Effect(self.ShellEffect,fx)				-- Shell ejection
	end)

	if ((SinglePlayer() and SERVER) or (not SinglePlayer() and CLIENT)) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end
end
