-- Read the weapon_real_base if you really want to know what each action does

/*---------------------------------------------------------*/
local Ar2Impact = function(attacker, tr, dmginfo)

	local auto = EffectData()
	auto:SetOrigin(tr.HitPos)
	auto:SetNormal(tr.HitNormal)
	auto:SetScale(20)
	util.Effect("AR2Impact", auto)

	return true
end

local ShotgunImpact = function(attacker, tr, dmginfo)

	local burst = EffectData()
	burst:SetOrigin(tr.HitPos)
	burst:SetNormal(tr.HitNormal)
	burst:SetScale(20)
	util.Effect("StunstickImpact", burst)

	return true
end
/*---------------------------------------------------------*/

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "ar2"
end

if (CLIENT) then
	SWEP.PrintName 		= "ADMIN GUN"
	SWEP.DrawAmmo		= false
	SWEP.DrawCrosshair	= true
	SWEP.ViewModelFOV		= 60
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "D"

	killicon.AddFont("weapon_cs_admin_weapon", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

SWEP.Instructions 		= "Damage: 1000% \nRecoil: 0% \nPrecision: 100% \nType: Automatic \nRate of Fire: 360 rounds per minute \n\nChange Mode: E + Right Click"

SWEP.Base 				= "weapon_real_base_rifle"

SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= true	-- Admin only!

SWEP.ViewModel			= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Recoil 		= 0
SWEP.Primary.Damage 		= 1000
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.01
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.Delay 		= 0.15
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.data 				= {}
SWEP.mode 				= "auto"

SWEP.data.auto 			= {}
SWEP.data.auto.Cone 		= 0.01
SWEP.data.auto.NumShots 	= 1
SWEP.data.auto.Delay		= 0.15
SWEP.data.auto.Trace		= "AirboatGunTracer"
SWEP.data.auto.Impact		= Ar2Impact
SWEP.data.auto.Sound		= Sound("npc/strider/strider_minigun.wav")

SWEP.data.burst 			= {}
SWEP.data.burst.Cone 		= 0.06
SWEP.data.burst.NumShots 	= 15
SWEP.data.burst.Delay		= 0.01
SWEP.data.burst.Trace		= 1
SWEP.data.burst.Impact		= ShotgunImpact
SWEP.data.burst.Sound		= Sound("weapons/shotgun/shotgun_fire7.wav")

SWEP.IronSightsPos 		= Vector (3.963, -3.271, 1.7058)
SWEP.IronSightsAng 		= Vector (1.5025, 0.6891, 0)

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
   
 	if ( SERVER ) then 
 		self:SetWeaponHoldType( self.HoldType ) 
 	end 

	util.PrecacheSound("npc/strider/strider_minigun.wav")
	util.PrecacheSound("weapons/shotgun/shotgun_fire7.wav")

	self.data[self.mode].Init(self)
end 

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.mode == "auto" then
		self.MuzzleEffect			= "rg_muzzle_rifle" 		-- This is an extra muzzleflash effect
		self.ShellEffect			= "rg_shelleject_rifle" 	-- This is a shell ejection effect
	else
		self.MuzzleEffect			= "rg_muzzle_grenade" 		-- This is an extra muzzleflash effect
		self.ShellEffect			= "rg_shelleject_shotgun" 	-- This is a shell ejection effect
	end

	if !self.Owner:KeyDown(IN_USE) then
 		if self.Owner:KeyPressed(IN_ATTACK2) then
			self.Owner:SetFOV( 40, 0.15 )
			self.scopein = 1
			self.MouseSensitivity = 0.4
		end

 		if self.Owner:KeyReleased(IN_ATTACK2) then
			self.Owner:SetFOV( 0, 0.15 )
			self.scopein = 0
			self.MouseSensitivity = 1
		end
	end
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()

	self.Reloadaftershoot = CurTime() + self.Primary.Delay
	-- Set the reload after shoot to be not able to reload when firering

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	-- Set next secondary fire after your fire delay

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	-- Set next primary fire after your fire delay

	self.Weapon:EmitSound(self.data[self.mode].Sound)
	-- Emit the gun sound when you fire

	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.data[self.mode].NumShots, self.data[self.mode].Cone)
	-- Ar2/Shotgun

	self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * 0.2, math.Rand(-1,1) * 0.2, 0))
	-- Punch the screen

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:KeyDown(IN_USE) then
	-- When you're pressing E + Right click, then

		if self.mode == "auto" then
			self.mode = "burst"
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
			self.Weapon:SetNextSecondaryFire(CurTime() + 2.5)
			self.Weapon:SetNextPrimaryFire(CurTime() + 2.5)
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Buckshot Rounds" )
		else
			self.mode = "auto"
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
			self.Weapon:SetNextSecondaryFire(CurTime() + 2.5)
			self.Weapon:SetNextPrimaryFire(CurTime() + 2.5)
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Strider Rounds" )
		end
		self.data[self.mode].Init(self)
	end
end

/*---------------------------------------------------------
ShootBullet
---------------------------------------------------------*/
function SWEP:CSShootBullet(dmg, recoil, numbul, cone)
	numbul = numbul or 1
	cone = cone or 0.01

	local tr = self.Owner:GetEyeTrace()

	local bullet = {}
	bullet.Num  = numbul
	bullet.Src = self.Owner:GetShootPos()       	-- Source
	bullet.Dir = self.Owner:GetAimVector()      	-- Dir of bullet
	bullet.Spread = Vector(cone, cone, 0)     	-- Aim Cone
	bullet.Tracer = 1       				-- Show a tracer on every x bullets
	bullet.TracerName = self.data[self.mode].Trace
	bullet.Callback = self.data[self.mode].Impact
	bullet.Force = 1000	    				-- Amount of force to give to phys objects
	bullet.Damage = 1000					-- Amount of damage to give to the bullets

	self.Owner:FireBullets(bullet)					-- Fire the bullets

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)      	-- View model animation
	self.Owner:MuzzleFlash()        					-- Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(self.MuzzleAttachment)
	util.Effect(self.MuzzleEffect,fx)					-- Additional muzzle effects
	
		local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetNormal(self.Owner:GetAimVector())
		fx:SetAttachment(self.ShellEjectAttachment)

		util.Effect(self.ShellEffect,fx)				-- Shell ejection

	if ((SinglePlayer() and SERVER) or (not SinglePlayer() and CLIENT)) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end
end