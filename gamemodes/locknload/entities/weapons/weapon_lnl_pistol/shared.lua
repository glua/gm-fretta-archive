SWEP.Base = "weapon_lnl_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Pistol"

SWEP.Slot					= 2
SWEP.ListPosition			= 3
SWEP.IconLetter				= "-"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"
SWEP.ViewModelAimPos		= Vector (-4.3745, -1.5071, 2.7434)
SWEP.ViewModelAimAng		= Vector (-0.005, -1.3209, 2.1863)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65
	
SWEP.HoldType			= "pistol"

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.FiresBullets			= true
SWEP.DrawSpeed				= 2
SWEP.WalkSpeedMultiplier	= 1.25
SWEP.RunSpeedMultiplier		= 1.4

SWEP.Primary.Sound			= Sound ("weapons/pistol/pistol_fire3.wav")
SWEP.Primary.SoundPitch		= 130
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ConeZoomed		= 0.02
SWEP.Primary.Delay			= 0.18

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 9000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Modifications		= {}

SWEP.Modifications.enraged = function (self)
	self.Primary.Damage = 13
	self.Primary.Cone = 0.065
	self.Primary.ConeZoomed = 0.045
	self.Primary.SoundPitch = 100
	self.CustomTracerName = "bullet_trace_enraged"
end

SWEP.Modifications.rapid = function (self)
	self.Primary.Damage = 8
	self.Primary.Delay = 0.1
	self.Primary.SoundPitch = 160
	self.CustomTracerName = "bullet_trace_rapid"
end

SWEP.Modifications.accurised = function (self)
	self.Primary.Cone = 0.02
	self.Primary.ConeZoomed = 0.01
	self.Primary.Delay = 0.22
	self.CustomTracerName = "bullet_trace_accurised"
	self.RicochetChance = 1
end

SWEP.Modifications.rapidreloading = function(self)
	self.Primary.ClipSize = 9
	self.Weapon:SetClip1 (9)
	self.ReloadSpeedMultiplier = 1.3
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 9 end
end

SWEP.Modifications.highcapacity = function(self)
	self.Primary.ClipSize = 18
	self.Weapon:SetClip1 (18)
	self.ReloadSpeedMultiplier = 0.7
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 9 end
end

if CLIENT then
	SWEP.AmmoDrawValues = {
		UnitWidth = 7,
		UnitWidthGap = 5,
		UnitHeight = 14,
		UnitsPerRow = 6,
		RowHeightGap = 4
	}
	
	killicon.AddFont ("weapon_lnl_pistol", "HL2MPTypeDeath", "-", Color (150, 150, 255, 255))
end

SWEP.WeaponIconDrawValues = {{typ = "text", text = "-", font = "HL2Weapons80", x = 22, y = 6}}

GAMEMODE:RegisterWeapon ("weapon_lnl_pistol", SWEP.WeaponIconDrawValues, {PositiveDesc = "Draws quickly, boosts movespeed", NegativeDesc = "Low firerate and capacity"})

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})