-- Read the weapon_real_base if you really want to know what each action does

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
	SWEP.HoldType = "pistol"
end

if (CLIENT) then
	SWEP.PrintName 		= "DUAL BERETTA ELITES"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "s"
	SWEP.ViewModelFlip 	= true

	killicon.AddFont("weapon_real_cs_elites", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_pistol" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "none" -- This is a shell ejection effect -- Better like that...
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models
/*-------------------------------------------------------*/

local clip1, clip2
clip1 				= 15
clip2 				= 15

SWEP.Instructions 		= "Damage: 15% \nRecoil: 5% \nPrecision: 84% \nType: Semi-Automatic \n\nLeft click to shoot from the left \nRight click to shoot from the right"

SWEP.Base 				= "weapon_real_base_pistol"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_Elite.Single")
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 15
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.016
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 		= 0.2
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "pistol"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (-4.955, -3.441, 2.9131)
SWEP.IronSightsAng 		= Vector (-0.0325, -0.1378, 0.0087)

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.Owner:KeyPressed(IN_ATTACK) and self.Weapon:Clip1() > 0 and self:CanClip1Attack()  then
	-- When the left click is pressed, then
		self.ViewModelFlip = true
	end

	if self.Owner:KeyPressed(IN_ATTACK2) and self.Weapon:Clip1() > 0 and self:CanClip2Attack() then
	-- When the right click is pressed, then
		self.ViewModelFlip = false
	end
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if not self:CanClip1Attack() or not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 2 then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire

	self.Reloadaftershoot = CurTime() + self.Primary.Delay
	-- Set the reload after shoot to be not able to reload when firering

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	-- Set next secondary fire after your fire delay

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay - 0.1)
	-- Set next secondary fire after your fire delay

	self.Weapon:EmitSound(self.Primary.Sound)
	-- Emit the gun sound when you fire

	self:RecoilPower()

	clip1 = clip1 - 1
	-- Take 1 ammo in your clip

	if clip1 >= 0 then
		self:TakePrimaryAmmo(1)
		-- Take 1 ammo in you clip
	end

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if not self:CanClip2Attack() or not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 2 then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire

	self.Reloadaftershoot = CurTime() + self.Primary.Delay
	-- Set the reload after shoot to be not able to reload when firering

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay - 0.1)
	-- Set next secondary fire after your fire delay

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	-- Set next secondary fire after your fire delay

	self.Weapon:EmitSound(self.Primary.Sound)
	-- Emit the gun sound when you fire

	self:RecoilPower()

	clip2 = clip2 - 1
	-- Take 1 ammo in your clip

	if clip2 >= 0 then
		self:TakePrimaryAmmo(1)
		-- Take 1 ammo in you clip
	end

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end 
	-- If you're firering, you can't reload

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	-- Animation when you're reloading

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then

		timer.Simple(2, function()
			clip1 = 15
			clip2 = 15
		end)
	end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	-- Set the deploy animation when deploying

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	-- Set the next primary fire to 1 second after deploying

	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	-- Set the next primary fire to 1 second after deploying

	if ( self.Weapon:Clip1() == 30 ) then
		clip1 = 15
		clip2 = 15
	end

	return true
end

/*---------------------------------------------------------
ShootBullet
---------------------------------------------------------*/
function SWEP:CSShootBullet(dmg, recoil, numbul, cone)

	numbul 		= numbul or 1
	cone 			= cone or 0.01

	local bullet 	= {}
	bullet.Num  	= numbul
	bullet.Src 		= self.Owner:GetShootPos()       					-- Source
	bullet.Dir 		= self.Owner:GetAimVector()      					-- Dir of bullet
	bullet.Spread 	= Vector(cone, cone, 0)     						-- Aim Cone
	bullet.Tracer 	= 1       									-- Show a tracer on every x bullets
	bullet.Force 	= 0.5 * dmg     								-- Amount of force to give to phys objects
	bullet.Damage 	= dmg										-- Amount of damage to give to the bullets
	bullet.Callback 	= HitImpact
-- 	bullet.Callback	= function ( a, b, c ) BulletPenetration( 0, a, b, c ) end 

	self.Owner:FireBullets(bullet)					-- Fire the bullets
	self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)      	-- View model animation
	self.Owner:MuzzleFlash()        					-- Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

	local fx 		= EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(self.MuzzleAttachment)
	util.Effect(self.MuzzleEffect,fx)					-- Additional muzzle effects
	
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

/*---------------------------------------------------------
CanClip1Attack
---------------------------------------------------------*/
function SWEP:CanClip1Attack()
	if clip1 <= 0 and self.Primary.ClipSize > -1 then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:EmitSound("Weapons/ClipEmpty_Pistol.wav")
		clip1 = 0
		return false
	end

	return true
end

/*---------------------------------------------------------
CanClip2Attack
---------------------------------------------------------*/
function SWEP:CanClip2Attack()
	if clip2 <= 0 and self.Primary.ClipSize > -1 then
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		self.Weapon:EmitSound("Weapons/ClipEmpty_Pistol.wav")
		clip2 = 0
		return false
	end

	return true
end