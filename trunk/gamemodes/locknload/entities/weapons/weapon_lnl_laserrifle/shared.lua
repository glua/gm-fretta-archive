SWEP.Base = "weapon_lnl_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Laser Rifle"

SWEP.Slot					= 3
SWEP.ListPosition			= 4
SWEP.IconLetter				= "2"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_irifle.mdl"
SWEP.WorldModel				= "models/weapons/w_irifle.mdl"
SWEP.ViewModelAimPos		= Vector (-3.4599, -1.5141, 1.7999)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.FiresBullets			= false

SWEP.Primary.Sound			= Sound ("weapons/ar2/fire1.wav")
SWEP.Primary.SoundPitch		= 120
SWEP.Primary.Damage			= 27
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.05
SWEP.Primary.MaxAccuracyDelay	= 1.5
SWEP.Primary.PowerDownDelay	= 2.5
SWEP.Primary.Delay			= 0.5
SWEP.Primary.ChargeStartDelay	= 0.2
SWEP.Primary.ChargeSound	= Sound ("weapons/physcannon/physcannon_charge.wav")
SWEP.Primary.ChargeSoundPitch = 90

SWEP.Primary.BaseAngleGap			= 4.5
SWEP.Primary.MaxAngleGapDecrease	= 3.6

SWEP.Primary.ClipSize		= 3
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
	self.Primary.Damage = 36
	self.Primary.SoundPitch = 90
	self.Primary.BaseAngleGap = 6
	self.Primary.MaxAngleGapDecrease = 4.7
	
	self.CustomTracerName = "laser_trace_enraged"
	
	self.Weapon:SetNWInt ("ft", 1)
end

SWEP.Modifications.rapid = function (self)
	self.Primary.Damage = 21
	self.Primary.Delay = 0.35
	self.Primary.MaxAccuracyDelay = 1
	self.Primary.PowerDownDelay = 2
	self.Primary.SoundPitch = 160
	self.Primary.ChargeSoundPitch = 135
	
	self.CustomTracerName = "laser_trace_rapid"
	
	self.Weapon:SetNWInt ("ft", 2)
end

SWEP.Modifications.accurised = function (self)	
	self.Primary.Delay = 0.7
	self.Primary.MaxAccuracyDelay = 2
	self.Primary.PowerDownDelay = 3
	self.Primary.BaseAngleGap = 3.5
	self.Primary.MaxAngleGapDecrease = 3.2
	self.Primary.ChargeSoundPitch = 68
	
	self.CustomTracerName = "laser_trace_accurised"
	
	self.Weapon:SetNWInt ("ft", 3)
end

SWEP.Modifications.rapidreloading = function(self)
	self.Primary.ClipSize = 2
	self.Weapon:SetClip1 (2)
	self.ReloadSpeedMultiplier = 1.3
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 2 end
end

SWEP.Modifications.highcapacity = function(self)
	self.Primary.ClipSize = 4
	self.Weapon:SetClip1 (4)
	self.ReloadSpeedMultiplier = 0.75
	if CLIENT then self.AmmoDrawValues.UnitsPerRow = 4 end
end

if CLIENT then
	SWEP.AmmoDrawValues = {
		UnitWidth = 7,
		UnitWidthGap = 5,
		UnitHeight = 25,
		UnitsPerRow = 3,
		RowHeightGap = 4
	}
	
	killicon.AddFont ("weapon_lnl_laserrifle", "HL2MPTypeDeath", "2", Color (150, 150, 255, 255))
end

function SWEP:CustomPrimaryAttack ()
	if not self.ChargeStartTime and IsFirstTimePredicted() then
		self.ChargeStartTime = CurTime() + self.Primary.ChargeStartDelay
		
		--self.Weapon:EmitSound (self.Primary.ChargeSound, 100, self.Primary.ChargeSoundPitch)
		self.ChargeCSoundPatch = CreateSound (self.Owner, self.Primary.ChargeSound)
		self.ChargeCSoundPatch:Play()
		self.ChargeCSoundPatch:ChangePitch (self.Primary.ChargeSoundPitch)
		
		self.Weapon:SetNWBool ("chg", true)
		
		--let it shine!
		local glow = EffectData()
		glow:SetEntity (self.Owner)
		glow:SetAttachment (1)
		util.Effect ("laserrifle_glow", glow, true)
		
		self.Weapon:SetNextPrimaryFire (CurTime() + 99999)
	end
end

function SWEP:CustomThink ()
	if self.ChargeStartTime and CurTime() - self.ChargeStartTime > 0 then
		if not self.Owner:KeyDown (IN_ATTACK) then
			--print (CLIENT, "Fire by release")
			self:FireLasers (math.min(1,(CurTime() - self.ChargeStartTime) / self.Primary.MaxAccuracyDelay))
			self.Weapon:SetNWBool ("chg", false)
			self:CanPrimaryAttack(true)
		end
	end
end

function SWEP:DoShootLaser (dmg, aimvec, charge)
	local bullet = {}
	bullet.Num 		= 1
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= aimvec
	bullet.Spread 	= Vector (0,0,0)
	bullet.Tracer	= 1
	bullet.TracerName	= self.CustomTracerName or "laser_trace"
	LNL_TracerAlpha = 255 * (1/3 + charge * 2/3)
	
	bullet.Force	= dmg
	bullet.Damage	= dmg * (1/3 + charge * 2/3)
	bullet.Callback	= self.CustomBulletCallback
	
	--print ("sub-fire")
	self.Owner:FireBullets (bullet)
	--print ("post-fire")
end

function SWEP:GetLaserCharge (num)
	local charge;
	if num == 1 then
		charge = math.min (1, math.min(1,math.max(0,(CurTime() - (self.ChargeStartTime or 9999999))) / self.Primary.MaxAccuracyDelay) + 0.5)
	else
		charge = math.max (0, math.min(1,(CurTime() - (self.ChargeStartTime or 9999999)) / self.Primary.MaxAccuracyDelay))
	end
	return charge
end

function SWEP:GetLaserDirection (num, charge)
	local aimang = self.Owner:EyeAngles()
	local dist = self.Primary.BaseAngleGap - charge * self.Primary.MaxAngleGapDecrease
	local rotvals = Vector (0,0)
	local deg = charge * 90
	if num == 1 then
		--do nothing!
	elseif num == 2 then
		rotvals = Vector (dist * math.sin(math.rad(deg)),dist * math.cos(math.rad(deg)))
	elseif num == 3 then
		dist = -dist
		rotvals = Vector (dist * math.sin(math.rad(deg)),dist * math.cos(math.rad(deg)))
	end
	aimang:RotateAroundAxis (aimang:Right(), rotvals.x)
	aimang:RotateAroundAxis (aimang:Up(), rotvals.y)
	local aimvec = aimang:Forward()
	return aimvec
end

function SWEP:FireLasers (charge)
	--print (CLIENT, "Firing at charge "..charge)
	--self.Weapon:StopSound (self.Primary.ChargeSound)
	if self.ChargeCSoundPatch then
		self.ChargeCSoundPatch:Stop()
	end
	self.Weapon:EmitSound (self.Primary.Sound or "", 100, self.Primary.SoundPitch or 100)
	--bullets.
	for i=1, 3 do
		local charge = self:GetLaserCharge (i)
		self:DoShootLaser (self.Primary.Damage, self:GetLaserDirection(i, charge), charge)
	end
		
	self:FireEffects()
	self:TakePrimaryAmmo (1)
	self.TimeWhenShotHappened = CurTime()
	self.Weapon:SetNextPrimaryFire (CurTime() + self.Primary.Delay)
	self.ChargeStartTime = false
end

function SWEP:CustomDeploy()
	self.ChargeStartTime = false
end

function SWEP:CustomHolster()
	if self.ChargeCSoundPatch then
		self.ChargeCSoundPatch:Stop()
	end
	self.ChargeStartTime = false
	self.Weapon:SetNWBool ("chg", false)
end

if CLIENT then

local flare = Material("effects/blueflare1")

function SWEP:DrawHUD()
	local scrpos = Vector (ScrW() * 0.5, ScrH() * 0.5)
	local charge = self:GetLaserCharge (1)
	if GetConVar("lnl_zoom_twitchaiming"):GetBool() then
		local hitpos = util.TraceLine ({
			start = LocalPlayer():GetShootPos(),
			endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 4096,
			filter = LocalPlayer(),
			mask = MASK_SHOT
		}).HitPos
		scrpos = hitpos:ToScreen()
	end
	local size = (0.009 - math.max(0.005 * ((self.DegreeOfZoom or 0) - 0.5), 0)) * (1 - charge / 2)
	self:DrawCrosshairElement (scrpos.x, scrpos.y, size, Color (255,255,255,100+charge*50))
	size = 0.004 - math.max(0.0025 * ((self.DegreeOfZoom or 0) - 0.5), 0)
	for i=2,3 do
		charge = self:GetLaserCharge (i)
		local hitpos = util.TraceLine ({
			start = LocalPlayer():GetShootPos(),
			endpos = LocalPlayer():GetShootPos() + self:GetLaserDirection (i,charge) * 4096,
			filter = LocalPlayer(),
			mask = MASK_SHOT
		}).HitPos
		scrpos = hitpos:ToScreen()
		self:DrawCrosshairElement (scrpos.x, scrpos.y, size, Color (255,255,255,50+charge*100))
	end
end

local firstTime = true

--[[function PleaseDrawLolKay ()
	if not ValidEntity (LocalPlayer():GetActiveWeapon()) then return end
	if firstTime then
		firstTime = false
		return
	end
	print ("GRAHH!")
	local muzzlepos = GetTracerShootPosLNL (LocalPlayer():GetActiveWeapon():GetTable(), LocalPlayer():GetShootPos(), LocalPlayer():GetActiveWeapon(), 1)
	render.SetMaterial (flare)
	render.DrawSprite (muzzlepos, 10, 10, Color (255,255,255,255))
end

hook.Add ("RenderScene", "PDLK", PleaseDrawLolKay)]]

end

SWEP.WeaponIconDrawValues = {{typ = "text", text = "2", font = "HL2Weapons70", x = 12, y = 6}}

GAMEMODE:RegisterWeapon ("weapon_lnl_laserrifle", SWEP.WeaponIconDrawValues, {PositiveDesc = "Powerful and accurate when charged", NegativeDesc = "Slow to charge, low capacity"})

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})