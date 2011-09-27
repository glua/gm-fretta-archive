SWEP.Base = "weapon_lnl_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "shotgun"
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Crossbow"

SWEP.Slot					= 4
SWEP.ListPosition			= 5
SWEP.IconLetter				= "1"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_crossbow.mdl"
SWEP.WorldModel				= "models/weapons/w_crossbow.mdl"
SWEP.ViewModelAimPos		= Vector (-4.2102, -4.8433, 0.3925)
SWEP.ViewModelAimAng		= Vector (0, 0, -12.6692)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.FiresBullets			= false

SWEP.Primary.Sound			= Sound("weapons/crossbow/fire1.wav")
SWEP.Primary.SoundPitch		= 115
SWEP.Primary.Damage			= 65
SWEP.Primary.Velocity		= 45000
SWEP.Primary.ArcMultiplier	= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone				= 0.015
SWEP.Primary.ConeZoomed			= 0.0075
SWEP.Primary.Ricochets 		= 1
--SWEP.Primary.Delay			= 0.8 --irrelevant
SWEP.ReloadSpeedMultiplier 	= 1

SWEP.Primary.ClipSize		= 1
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
	self.Primary.Damage = 80
	self.Primary.SoundPitch = 90
	self.Primary.Cone = 0.0275
	self.Primary.ConeZoomed = 0.02
	self.Primary.ArcMultiplier = 1.5
	self.Primary.NWLetter = "e"
end

SWEP.Modifications.rapid = function (self)
	self.Primary.Damage = 55
	self.ReloadSpeedMultiplier = 1.3
	self.Primary.SoundPitch = 140
	self.Primary.NWLetter = "r"
end

SWEP.Modifications.accurised = function (self)	
	self.ReloadSpeedMultiplier = 0.7
	self.Primary.Cone = 0.005
	self.Primary.ConeZoomed = 0.0
	self.Primary.ArcMultiplier = 0
	self.Primary.Velocity = 30000
	self.Primary.Ricochets = 3
	self.Primary.NWLetter = "a"
end

if CLIENT then
	SWEP.AmmoDrawValues = {
		UnitWidth = 60,
		UnitWidthGap = 6,
		UnitHeight = 5,
		UnitsPerRow = 1,
		RowHeightGap = 2
	}
	
	killicon.AddFont ("lnl_crossbowbolt", "HL2MPTypeDeath", "1", Color (150, 150, 255, 255))
end

function SWEP:CustomPrimaryAttack ()	
	self:FireEffects()
	self:TakePrimaryAmmo (1)
	self.TimeWhenShotHappened = CurTime()
	self.Weapon:SetNextPrimaryFire (CurTime() + self.Primary.Delay)
	
	self.Weapon:EmitSound (self.Primary.Sound or "", 100, self.Primary.SoundPitch or 100)
	
	if CLIENT then return end
		local shot = ents.Create ("lnl_crossbowbolt")
		
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:EyeAngles()
		
		pos = pos + 8 * ang:Forward()
		pos = pos + 8 * ang:Right()
		if self.Owner:KeyDown (IN_ATTACK2) then
			pos = pos + -8 * ang:Up()
		else
			pos = pos + -6* ang:Up()
		end
		
		shot:SetPos (pos)
		shot:SetOwner (self.Owner)
		shot:SetAngles ((self.Owner:GetAimVector() + VectorRand() * self.Primary.Cone):Angle())
		shot:SetNWString ("fm", self.Primary.NWLetter)
		shot:Spawn()
		shot.Damage = self.Primary.Damage
		shot.Velocity = self.Primary.Velocity
		shot.ArcMultiplier = self.Primary.ArcMultiplier
		shot.Ricochets = self.Primary.Ricochets
		
		local phys = shot:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity (shot:GetAngles():Forward() * self.Primary.Velocity)
		end
end

function SWEP:CustomDeploy()
	if self.Weapon:Clip1() == 0 then
		self:Reload()
	end
end

SWEP.WeaponIconDrawValues = {{typ = "text", text = "1", font = "HL2Weapons80", x = 6, y = 6}}

GAMEMODE:RegisterWeapon ("weapon_lnl_crossbow", SWEP.WeaponIconDrawValues, {PositiveDesc = "Very high damage, 1 ricochet", NegativeDesc = "Slow firerate, arcing projectiles"})

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})