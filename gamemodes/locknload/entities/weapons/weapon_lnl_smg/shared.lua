SWEP.Base = "weapon_lnl_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "SMG"

SWEP.Slot					= 0
SWEP.ListPosition			= 1
SWEP.IconLetter				= "/"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.ViewModelAimPos		= Vector (-4.391, -1.1411, 1.8545)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65
	
SWEP.HoldType			= "smg"

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.FiresBullets			= true

SWEP.Primary.Sound			= Sound ("weapons/smg1/npc_smg1_fire1.wav")
SWEP.Primary.SoundPitch		= 200
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.ConeZoomed		= 0.02
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 24
SWEP.Primary.DefaultClip	= 7500
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Modifications		= {}

SWEP.Modifications.enraged = function (self)
	self.Primary.Damage = 13
	self.Primary.Cone = 0.06
	self.Primary.ConeZoomed = 0.045
	self.Primary.SoundPitch = 160
	self.CustomTracerName = "bullet_trace_enraged"
end

SWEP.Modifications.rapid = function (self)
	self.Primary.Damage = 7.5
	self.Primary.Delay = 0.06
	self.Primary.SoundPitch = 240
	self.CustomTracerName = "bullet_trace_rapid"
end

SWEP.Modifications.accurised = function (self)
	self.Primary.Cone = 0.0175
	self.Primary.ConeZoomed = 0.01
	self.Primary.Delay = 0.13
	self.RicochetChance = 1
	self.CustomTracerName = "bullet_trace_accurised"
end

SWEP.Modifications.rapidreloading = function(self)
	self.Primary.ClipSize = 18
	self.Weapon:SetClip1 (18)
	self.ReloadSpeedMultiplier = 1.3
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 9 end
end

SWEP.Modifications.highcapacity = function(self)
	self.Primary.ClipSize = 40
	self.Weapon:SetClip1 (40)
	self.ReloadSpeedMultiplier = 0.7
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 20 end
end

if CLIENT then
	SWEP.AmmoDrawValues = {
		UnitWidth = 5,
		UnitWidthGap = 4,
		UnitHeight = 14,
		UnitsPerRow = 12,
		RowHeightGap = 4
	}
	
	killicon.AddFont ("weapon_lnl_smg", "HL2MPTypeDeath", "/", Color (150, 150, 255, 255))
end

function SWEP:FireEffects()
	self.LastFireEffects = self.LastFireEffects or -10
	if self.LastFireEffects + 0.25 > CurTime() then
		self.FireStage = self.FireStage + 1
	else
		self.FireStage = 1
	end
	if self.FireStage == 1 then
		self.Weapon:SendWeaponAnim (ACT_VM_PRIMARYATTACK)
	elseif self.FireStage == 2 then
		self.Weapon:SendWeaponAnim (ACT_VM_RECOIL1)
	else
		self.Weapon:SendWeaponAnim (ACT_VM_RECOIL2)
	end
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation (PLAYER_ATTACK1)
	self.LastFireEffects = CurTime()
end

SWEP.WeaponIconDrawValues = {{typ = "text", text = "/", font = "HL2Weapons80", x = 14, y = 4}}

GAMEMODE:RegisterWeapon ("weapon_lnl_smg", SWEP.WeaponIconDrawValues, {PositiveDesc = "High firerate, medium accuracy", NegativeDesc = "Low damage per shot"})