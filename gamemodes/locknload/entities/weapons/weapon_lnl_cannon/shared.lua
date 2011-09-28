SWEP.Base = "weapon_lnl_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Cannon"

SWEP.Slot					= 5
SWEP.ListPosition			= 6
SWEP.IconLetter				= "3"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_rpg.mdl"
SWEP.WorldModel				= "models/weapons/w_rocket_launcher.mdl"
SWEP.ViewModelAimPos		= Vector (-7.3504, -5.5898, 2.1605)
SWEP.ViewModelAimAng		= Vector (0, 0, 11.9645)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65
	
SWEP.HoldType			= "rpg"

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.FiresBullets			= false

SWEP.Primary.Sound			= Sound ("weapons/stinger_fire1.wav")
SWEP.Primary.SoundPitch		= 180
SWEP.Primary.Damage			= 40
SWEP.Primary.Radius			= 220
SWEP.Primary.Velocity		= 5000
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone				= 0.045
SWEP.Primary.ConeZoomed			= 0.035
SWEP.Primary.Delay			= 0.8

SWEP.Primary.ClipSize		= 3
SWEP.Primary.DefaultClip	= 9000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadSpeedMultiplier = 0.8

SWEP.Modifications		= {}

SWEP.Modifications.enraged = function (self)
	self.Primary.Damage = 45
	self.Primary.Radius	= 240
	self.Primary.SoundPitch = 150
	self.Primary.Cone = 0.07
	self.Primary.ConeZoomed = 0.055
	self.Primary.NWLetter = "e"
end

SWEP.Modifications.rapid = function (self)
	self.Primary.Damage = 40
	self.Primary.Radius = 200
	self.Primary.Delay = 0.6
	self.Primary.SoundPitch = 210
	self.Primary.NWLetter = "r"
end

SWEP.Modifications.accurised = function (self)	
	self.Primary.Delay = 1.05
	self.Primary.Cone = 0.025
	self.Primary.ConeZoomed = 0.015
	self.Primary.Velocity		= 7000
	self.Primary.NWLetter = "a"
	self.Primary.DisableGravity = true
end

SWEP.Modifications.rapidreloading = function(self)
	self.Primary.ClipSize = 2
	self.Weapon:SetClip1 (2)
	self.ReloadSpeedMultiplier = 1.1
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 2 end
end

SWEP.Modifications.highcapacity = function(self)
	self.Primary.ClipSize = 4
	self.Weapon:SetClip1 (4)
	self.ReloadSpeedMultiplier = 0.57
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 4 end
end

if CLIENT then
	SWEP.AmmoDrawValues = {
		UnitWidth = 20,
		UnitWidthGap = 6,
		UnitHeight = 25,
		UnitsPerRow = 3,
		RowHeightGap = 4
	}
	
	killicon.AddFont ("lnl_cannonshot", "HL2MPTypeDeath", "3", Color (150, 150, 255, 255))
end

function SWEP:CustomPrimaryAttack ()	
	self:FireEffects()
	self:TakePrimaryAmmo (1)
	self.TimeWhenShotHappened = CurTime()
	self.Weapon:SetNextPrimaryFire (CurTime() + self.Primary.Delay)
	
	self.Weapon:EmitSound (self.Primary.Sound or "", 100, self.Primary.SoundPitch or 100)
	
	if CLIENT then return end
		local shot = ents.Create ("lnl_cannonshot")
		
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:EyeAngles()
		
		pos = pos + 8 * ang:Forward()
		if self.Owner:KeyDown (IN_ATTACK2) then
			pos = pos + 8 * ang:Right()
		else
			pos = pos + 14 * ang:Right()
		end
		pos = pos + -2 * ang:Up()
		
		shot:SetPos (pos)
		shot:SetOwner (self.Owner)
		shot:SetAngles (self.Owner:EyeAngles())
		shot:Spawn()
		shot.Damage = self.Primary.Damage
		shot.Radius = self.Primary.Radius
		shot:SetNWString ("fm", self.Primary.NWLetter)
		
		local phys = shot:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity ((self.Owner:GetAimVector() + Vector (math.random() - 0.5, math.random() - 0.5, 0) * self.Primary.Cone) * self.Primary.Velocity)
			if self.Primary.DisableGravity then
				phys:EnableGravity (false)
			end
		end
end

SWEP.WeaponIconDrawValues = {{typ = "text", text = "3", font = "HL2Weapons70", x = 10, y = 12}}

GAMEMODE:RegisterWeapon ("weapon_lnl_cannon", SWEP.WeaponIconDrawValues, {PositiveDesc = "Fires projectiles with explosive radius", NegativeDesc = "Slow firerate, low capacity"})

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})