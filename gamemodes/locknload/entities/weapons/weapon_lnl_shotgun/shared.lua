SWEP.Base = "weapon_lnl_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "shotgun"
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Shotgun"

SWEP.Slot					= 1
SWEP.ListPosition			= 2
SWEP.IconLetter				= "0"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel				= "models/weapons/w_shotgun.mdl"
SWEP.ViewModelAimPos		= Vector (-7.2043, -3.4132, 1.8321)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.FiresBullets			= true

SWEP.Primary.Sound			= Sound ("weapons/shotgun/shotgun_fire6.wav")
SWEP.Primary.SoundPitch		= 110
SWEP.Primary.Damage			= 6
SWEP.Primary.NumShots		= 10
SWEP.Primary.Cone			= 0.055
SWEP.Primary.Delay			= 0.9

SWEP.Primary.ClipSize		= 6
SWEP.NoChamberingRounds		= true
SWEP.Primary.DefaultClip	= 6000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Recoil					= 4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadDelay			= 0.5
SWEP.CustomReload			= true

SWEP.Modifications		= {}

SWEP.Modifications.enraged = function (self)
	self.Primary.Damage = 7
	self.Primary.NumShots = 12
	self.Primary.Cone = 0.085
	self.Primary.SoundPitch = 88
	self.CustomTracerName = "bullet_trace_enraged"
end

SWEP.Modifications.rapid = function (self)
	self.Primary.Damage = 6
	self.Primary.NumShots = 8
	self.Primary.Delay = 0.68
	self.Primary.SoundPitch = 132
	self.CustomTracerName = "bullet_trace_rapid"
end

SWEP.Modifications.accurised = function (self)
	self.Primary.Cone = 0.032
	self.Primary.Delay = 1.1
	self.RicochetChance = 1
	self.CustomTracerName = "bullet_trace_accurised"
end

SWEP.Modifications.rapidreloading = function(self)
	self.Primary.ClipSize = 4
	self.Weapon:SetClip1 (4)
	self.ReloadSpeedMultiplier = 1.3
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 4 end
end

SWEP.Modifications.highcapacity = function(self)
	self.Primary.ClipSize = 8
	self.Weapon:SetClip1 (8)
	self.ReloadSpeedMultiplier = 0.7
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 8 end
end

function SWEP:Reload()
	if SERVER and SinglePlayer() then
		self.Owner:SendLua ("LocalPlayer():GetActiveWeapon():Reload()")
	end
	
 	if self.Weapon:GetNWBool ("reloading", false) then return end
	
	if (self.FireTime or 0) + 0.5 > CurTime() then return end
	
 	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
 		self.Weapon:SetNWBool ("reloading", true)
		self.ReloadStartTime = true
 		self.nextReload = CurTime() + self.ReloadDelay / (self.ReloadSpeedMultiplier or 1)
		self.Weapon:SetNextPrimaryFire (CurTime() + 9999)
 		self.Weapon:SendWeaponAnim (ACT_VM_RELOAD)
		self.Owner:GetViewModel():SetPlaybackRate (self.ReloadSpeedMultiplier or 1)
 	end
end

function SWEP:CustomThink()
	if self.Weapon:GetNWBool ("reloading", false) then
		--self.Reloading = true
		if (self.nextReload or 0) < CurTime() then
			if self.Primary.ClipSize <= self.Weapon:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self.Weapon:SetNWBool ("reloading", false)
				self.ReloadStartTime = false
				return
			end
			
			self.nextReload = CurTime() + self.ReloadDelay / (self.ReloadSpeedMultiplier or 1)
			self.Weapon:SendWeaponAnim (ACT_VM_RELOAD)
			self.Owner:GetViewModel():SetPlaybackRate (self.ReloadSpeedMultiplier or 1)
			self.Weapon:EmitSound ("Weapon_Shotgun.Reload")
			
			self.Owner:RemoveAmmo (1, self.Primary.Ammo, false)
			self.Weapon:SetClip1 (self.Weapon:Clip1()+1)
			
			if self.Primary.ClipSize <= self.Weapon:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then
				self.Weapon:SendWeaponAnim (ACT_SHOTGUN_RELOAD_FINISH)
				self.Owner:GetViewModel():SetPlaybackRate (self.ReloadSpeedMultiplier or 1)
				self.nextReload = CurTime() + self.ReloadDelay / (self.ReloadSpeedMultiplier or 1)
				self.Weapon:SetNextPrimaryFire (CurTime() + 0.7 / (self.ReloadSpeedMultiplier or 1))
				self.Weapon:SetNWBool ("reloading", false)
				self.ReloadStartTime = false
			end
		end
	elseif self.Reloading and ((self.nextReload or 0) < CurTime()) then
		--self.Reloading = false
		self.Pumped = true
		self.FireTime = CurTime() - 0.3
	end
	
	if self.AnimFired and ((self.FireTime or 0) + 0.01 < CurTime()) then
		--Msg ("FIRE2\n")
		--self.Weapon:SendWeaponAnim (ACT_VM_PRIMARYATTACK)
		self.AnimFired = false
		--if self.Weapon:Clip1() > 0 then
			self.Pumped = true
		--else
		--	self.Weapon:SetNextPrimaryFire (CurTime() + 0.01)
		--end
	elseif self.Pumped and ((self.FireTime or 0) + (self.Primary.Delay / 3) < CurTime()) then
		--Msg ("PUMP\n")
		self.Weapon:SendWeaponAnim (ACT_SHOTGUN_PUMP)
		if not (SERVER and SinglePlayer()) then
			self.Weapon:EmitSound ("weapons/shotgun/shotgun_cock.wav")
		end
		self.Pumped = false
		self.Idled = true
	elseif self.Idled and ((self.FireTime or 0) + 0.7 < CurTime()) then
		--Msg ("IDLE\n")
		self.Weapon:SendWeaponAnim (ACT_VM_IDLE)
		self.Idled = false
	end
end

function SWEP:CustomPrimaryAttack()
	if SERVER and SinglePlayer() then 
		self.Owner:SendLua("LocalPlayer():GetActiveWeapon():CustomPrimaryAttack()")
		return
	end
	--Msg ("FIRE\n")
	self.FireTime = CurTime()
	self.AnimFired = true
end

function SWEP:CustomHolster()
	self.Reloading = false
	self.ReloadStartTime = false
	self.Weapon:SetNWBool ("reloading", false)
end

if CLIENT then
	SWEP.AmmoDrawValues = {
		UnitWidth = 14,
		UnitWidthGap = 5,
		UnitHeight = 25,
		UnitsPerRow = 6,
		RowHeightGap = 4
	}
	
	killicon.AddFont ("weapon_lnl_shotgun", "HL2MPTypeDeath", "0", Color (150, 150, 255, 255))
end

SWEP.WeaponIconDrawValues = {{typ = "text", text = "0", font = "HL2Weapons80", x = 4, y = 8}}

GAMEMODE:RegisterWeapon ("weapon_lnl_shotgun", SWEP.WeaponIconDrawValues, {PositiveDesc = "High damage up close", NegativeDesc = "Low accuracy and firerate"})