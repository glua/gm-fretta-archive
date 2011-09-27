if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end

local aimSensitivity = CreateClientConVar ("lnl_zoom_sensitivity", "1", true)
local aimTwitchAiming = CreateClientConVar ("lnl_zoom_twitchaiming", "0", true)

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.PrintName				= "LNL Base"
SWEP.Category				= "LNL"
SWEP.Author					= "Devenger"

SWEP.Slot					= 2 
SWEP.ListPosition			= 3

SWEP.ViewModel				= "models/weapons/v_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)
SWEP.ZoomTime				= 0.2

SWEP.ViewModelFlip			= true
SWEP.ViewModelFOV			= 65
SWEP.CSMuzzleFlashes		= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_SMG1.Single")
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 270
SWEP.NoChamberingRounds		= true
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Tertiary				= {}

SWEP.UseLNLAiming	= true
SWEP.StationaryAimingOn		= false

function SWEP:Initialize()
	if SERVER then
		self:SetWeaponHoldType (self.HoldType)
	end
end

function SWEP:CanPrimaryAttack (nosound)
        if self.Weapon:Clip1() <= 0 then
                if not nosound then self:EmitSound ("Weapon_Pistol.Empty") end
                self:SetNextPrimaryFire (CurTime() + 0.2)
                self:Reload()
                return false
        end
        return true
end

function SWEP:PrimaryAttack()
	self.Reloading = false
	
	self.Weapon:SetNextPrimaryFire (CurTime() + self.Primary.Delay)
	
	if !self:CanPrimaryAttack(true) then
		return
	end
	
	if self.FiresBullets then
		self.Weapon:EmitSound (self.Primary.Sound or "", 100, self.Primary.SoundPitch or 100)
		
		local cone = self.Primary.Cone
		if self.StationaryAimingOn and self.Primary.ConeZoomed then cone = self.Primary.ConeZoomed end
		
		self:DoShootBullet (self.Primary.Damage, self.Primary.NumShots, cone)
		--[[local rec = recoilMul:GetFloat()
		if self.Owner:Crouching() then rec = rec * 0.5 end
		self.Owner:TWRecoil (math.Rand(-1, -0.5) * (self.Recoil or 1) * rec, math.Rand(-0.5, 0.5) * (self.Recoil or 1) * rec)]]
		
		self:TakePrimaryAmmo (1)
	end
	
	if self.CustomPrimaryAttack then self:CustomPrimaryAttack() end
	
	self.TimeWhenShotHappened = CurTime()
	
	self:CanPrimaryAttack(true) --trigger autoreload
end

function SWEP:SecondaryAttack()
	
end

function SWEP:SetAiming (bool)
	self.StationaryAimingOn = bool
end

function SWEP:Thinkie()
	if --[[CLIENT and ]]self.Reloading then
		self:SetAiming (false)
		if not self.CustomReload and (self.LastClip or 0) < self.Weapon:Clip1() then
			self.Reloading = false
			if self.LastClip == 0 and self.Weapon:Clip1() == self.Primary.ClipSize and (not self.NoChamberingRounds) then
				self:TakePrimaryAmmo (1)
				if SERVER then self.Owner:GiveAmmo (1, self.Weapon:GetPrimaryAmmoType(), true) end
			end
		end
	else
		self:SetAiming (self.Owner:KeyDown(IN_ATTACK2)
		and ((self.DrawTime or 0) + 0.8 < CurTime())
		and not self.Owner:KeyDown(IN_SPEED))
	end
	
	self.DegreeOfZoom = LNL_DegreeOfZoom
	if self.StationaryAimingOn then
		self.DegreeOfZoom = math.min((self.DegreeOfZoom or 0) + FrameTime() / self.ZoomTime, 1)
	else
		self.DegreeOfZoom = math.max((self.DegreeOfZoom or 0) - FrameTime() / self.ZoomTime, 0)
	end
	LNL_DegreeOfZoom = self.DegreeOfZoom
	
	if CLIENT then
		self.FOVToSet = ((52 or self.FOVTargetOverride) * self.DegreeOfZoom) + (GetConVarNumber("fov_desired") or 75) * (1-self.DegreeOfZoom)
		self.ViewModelFOV = 65 * ((GetConVarNumber("fov_desired") or 75) / 75) ^ 0.8 --<-- if I knew why this worked, I'd be a much smarter person. Or the other way round....
		--print (self.FOVToSet, self.ViewModelFOV)
		self.SprintMultiplier = self.SprintMultiplier or 1
		if self.Owner:KeyDown (IN_SPEED) then
			self.SprintMultiplier = math.min (self.SprintMultiplier + FrameTime() * 5, 2)
		else
			self.SprintMultiplier = math.max (self.SprintMultiplier - FrameTime() * 5, 1)
		end
		self.MouseSensitivity = 1 - self.DegreeOfZoom * 0.2
		self.BobScale = (1 - self.DegreeOfZoom * 0.7)
		self.SwayScale = (1 - self.DegreeOfZoom * 0.8) * self.SprintMultiplier
	end
	if CLIENT then
		self.WeaponMods = self.WeaponMods or {}
		self.WeaponModNames = self.WeaponModNames or {}
		for i=1, 3 do
			if not self.WeaponMods[i] and self.Weapon:GetNWString("mod"..i, false) then
				self.WeaponMods[i] = self.Weapon:GetNWString("mod"..i)
				local mod = GAMEMODE.WeaponMods[self.WeaponMods[i]]
				if mod then
					self.WeaponModNames[i] = mod.Name
					mod:Apply (self.Weapon)
				end
			end
		end
	end
end

function SWEP:Think()
	if self.CustomThink then
		self:CustomThink()
	end
	if (not self.CustomReload) and self.ReloadStartTime and self.ReloadStartTime + self.ReloadDuration - 0.2 < CurTime() then
		self.Weapon:SetClip1 (self.Primary.ClipSize)
		self.ReloadStartTime = nil
	end
end

function SWEP:Reload()
	if SERVER and SinglePlayer() then
		self.Owner:SendLua ("LocalPlayer():GetActiveWeapon():Reload()")
	end
	--[[local reloadStarted = self.Weapon:DefaultReload (ACT_VM_RELOAD)
	if reloadStarted then
		self.Reloading = true
		self.LastClip = self.Weapon:Clip1()
	end]]
	if self.ReloadStartTime then return end
	if self.Weapon:Clip1() == self.Primary.ClipSize then return end
	self.Weapon:SendWeaponAnim (ACT_VM_RELOAD)
	self.Owner:SetAnimation (PLAYER_RELOAD)
	self.Owner:GetViewModel():SetPlaybackRate (self.ReloadSpeedMultiplier or 1)
	self.ReloadDuration = (self.Weapon:SequenceDuration() / (self.ReloadSpeedMultiplier or 1)) - 0.05
	self.Weapon:SetNextPrimaryFire (CurTime() + self.ReloadDuration + 0.05)
	self.ReloadStartTime = CurTime()
end

SWEP.WalkSpeedMultiplier = 1
SWEP.RunSpeedMultiplier = 1

function SWEP:Deploy()
	if SERVER and SinglePlayer() then
		timer.Simple (0.05, self.Owner.SendLua, self.Owner, "if ValidEntity(LocalPlayer():GetActiveWeapon()) then LocalPlayer():GetActiveWeapon():Deploy() end")
	end
	self.Owner:SetWalkSpeed ((self.Owner.BaseWalkSpeed or 200) * self.WalkSpeedMultiplier)
	self.Owner:SetRunSpeed ((self.Owner.BaseRunSpeed or 300) * self.RunSpeedMultiplier)
	self.Weapon:SendWeaponAnim (ACT_VM_DRAW)
	local duration = self.Weapon:SequenceDuration()
	local delay = duration * 0.5 / (self.DrawSpeed or 1)
	self.Weapon:SetNextPrimaryFire (CurTime() + (math.max (delay, (self.TimeWhenShotHappened or 0) + self.Primary.Delay - CurTime())))
	self.Owner:GetViewModel():SetPlaybackRate (1.5 * (self.DrawSpeed or 1))
	self.DrawTime = CurTime()
	self.ReloadStartTime = nil
	if self.CustomDeploy then self:CustomDeploy() end
end

function SWEP:Holster()
	self:SetAiming (false)
	self.DegreeOfZoom = 0
	--self.Reloading = false
	self.ReloadStartTime = nil
	if self.CustomHolster then self:CustomHolster() end
	return true
end

SWEP.CustomTracerColour = Color (255,255,255,255)

function SWEP:DoShootBullet (dmg, numbul, cone)
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.02

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector (cone, cone, 0)
	bullet.Tracer	= 1
	bullet.TracerName	= self.CustomTracerName or "bullet_trace"
	LNL_TracerColour	= self.CustomTracerColour --odd hack
	bullet.Force	= dmg
	bullet.Damage	= dmg
	bullet.Callback	= function(a, b, c) return self:RicochetCallback_Redirect(a, b, c) end
	
	self.Owner:FireBullets (bullet)
	
	self:FireEffects()
end

SWEP.MaxRicochet = 2
SWEP.RicochetChance = 0.3

function SWEP:RicochetCallback_Redirect (a, b, c) return self:RicochetCallback (0, a, b, c) end

function SWEP:RicochetCallback (bouncenum, atk, tr, dmginfo)
	if !self then return end
	if tr.HitSky then return end
	if tr.MatType == MAT_FLESH then return end
	
	if bouncenum > self.MaxRicochet then return end
	
	if math.random() > self.RicochetChance then return end
	
	local DotProduct = tr.HitNormal:Dot (tr.Normal * -1)
	local Dir = (2 * tr.HitNormal * DotProduct) + tr.Normal
	Dir:Normalize()
	
	local dmg = dmginfo:GetDamage()
	
	local tracer = self.CustomTracerName or "bullet_trace"
	
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= Dir,	
		Spread 		= self.Primary.Cone,
		Tracer		= 1,
		TracerName	= tracer.."_rico",
		Force		= dmg,
		Damage		= dmg,
		AmmoType 	= "Pistol",
	}
	
	bullet.Callback    = function( a, b, c ) if( self.RicochetCallback ) then return self:RicochetCallback( bouncenum+1, a, b, c ) end end
	
	timer.Simple (0.09, atk.FireBullets, atk, bullet, true)
end

function SWEP:FireEffects()
	self.Weapon:SendWeaponAnim (ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation (PLAYER_ATTACK1)
end

function SWEP:DrawHUD()
	local scrpos = Vector (ScrW() * 0.5, ScrH() * 0.5)
	if aimTwitchAiming:GetBool() then
		local hitpos = util.TraceLine ({
			start = LocalPlayer():GetShootPos(),
			endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 4096,
			filter = LocalPlayer(),
			mask = MASK_SHOT
		}).HitPos
		scrpos = hitpos:ToScreen()
	end
	local size = 0.0175 - math.max(0.01 * ((self.DegreeOfZoom or 0) - 0.5), 0)
	self:DrawCrosshairElement (scrpos.x, scrpos.y, size)
end

function SWEP:DrawCrosshairElement (x,y,size,color)
	if color then
		surface.SetDrawColor (color.r,color.g,color.b,color.a)
	else
		surface.SetDrawColor (255, 255, 255, 150)
		if self.ReloadStartTime then surface.SetDrawColor (255, 255, 255, 50) end
	end
	surface.DrawLine (x - ScrW() * size, y, x - ScrW() * size / 2, y)
	surface.DrawLine (x + ScrW() * size / 2, y, x + ScrW() * size, y)
	surface.DrawLine (x-1, y, x+1, y)
	surface.DrawLine (x, y-1, x, y+1)
	surface.DrawLine (x, y - ScrW() * size, x, y - ScrW() * size / 2)
	surface.DrawLine (x, y + ScrW() * size / 2, x, y + ScrW() * size)
end

lockedViewAng = false
local lockedViewAngOffset = false

local function WeaponUsesStationaryAiming ()
	return LocalPlayer() and ValidEntity(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon().UseLNLAiming
end

local function WeaponStationaryAimingOn ()
	return LocalPlayer():GetActiveWeapon().StationaryAimingOn
end

if SERVER then
	function StationaryAimingThink()
		for _,pl in pairs (player.GetAll()) do
			if pl and ValidEntity(pl:GetActiveWeapon()) and pl:GetActiveWeapon().UseLNLAiming then
				pl:GetActiveWeapon():Thinkie()
			end
		end
	end

	hook.Add ("Think", "LNLTHINK", StationaryAimingThink)
end

function SimilarizeAngles (ang1, ang2)
	if math.abs (ang1.y - ang2.y) > 180 then
		if ang1.y - ang2.y < 0 then
			ang1.y = ang1.y + 360
		else
			ang1.y = ang1.y - 360
		end
	end
end

function StationaryAimingCalcView (pl, origin, angles, view)
	if WeaponUsesStationaryAiming() --[[and lockedViewAng ]]then
		usefulViewAng = lockedViewAng or angles
		local view = {}
		view.origin = origin
		view.angles = usefulViewAng
		local DefPos = (pl:GetActiveWeapon().ViewModelAimPos or Vector (0,0,0)) * pl:GetActiveWeapon().DegreeOfZoom
		
		SimilarizeAngles (angles, usefulViewAng)
		
		--print (GetConVarNumber("fov_desired"))
		fovratio = (LocalPlayer():GetActiveWeapon().FOVToSet or GetConVarNumber("fov_desired") or 75) / LocalPlayer():GetActiveWeapon().ViewModelFOV
		LNL_FOVRATIO = fovratio
		angles = (angles * fovratio) + (usefulViewAng * (1 - fovratio))
		
		local pos = origin
		local Right 	= angles:Right()
		local Up 		= angles:Up()
		local Forward 	= angles:Forward()
		pos = pos + DefPos.x * Right
		pos = pos + DefPos.y * Forward
		pos = pos + DefPos.z * Up
		view.vm_origin = pos
		if pl:GetActiveWeapon().ViewModelFlip then angles.y = usefulViewAng.y + (usefulViewAng.y - angles.y) end
		if pl:GetActiveWeapon().ViewModelAimAng then
			angles:RotateAroundAxis( angles:Right(), 	pl:GetActiveWeapon().ViewModelAimAng.x * pl:GetActiveWeapon().DegreeOfZoom ) 
			angles:RotateAroundAxis( angles:Up(), 		pl:GetActiveWeapon().ViewModelAimAng.y * pl:GetActiveWeapon().DegreeOfZoom ) 
			angles:RotateAroundAxis( angles:Forward(), 	pl:GetActiveWeapon().ViewModelAimAng.z * pl:GetActiveWeapon().DegreeOfZoom ) 
		end
		view.vm_angles = angles
		--print ("Setting a pos.", CurTime())
		return view
	end
end

hook.Add ("CalcView", "LNLCV", StationaryAimingCalcView)

local lastRealViewAng = false
local allowedFromCentreX = 12
local allowedFromCentreY = 8.5

local function StationaryAimingCreateMove (cmd)
	if WeaponUsesStationaryAiming() then
		LocalPlayer():GetActiveWeapon():Thinkie()
		
		if WeaponStationaryAimingOn() then
			
			--sensitivity
			local angles = cmd:GetViewAngles()
			if lastRealViewAng then
				SimilarizeAngles (lastRealViewAng, angles)
				local diff = angles - lastRealViewAng
				diff = diff * (LocalPlayer():GetActiveWeapon().MouseSensitivity or 1) * aimSensitivity:GetFloat()
				angles = lastRealViewAng + diff
			end
			
			lastRealViewAng = angles
			
			if aimTwitchAiming:GetBool() then
				if not lockedViewAng then
					lockedViewAng = cmd:GetViewAngles()
					lockedViewAngOffset = Angle (0,0,0)
				end
			--this.
				SimilarizeAngles (lockedViewAng, angles)
				local ydiff = (angles.y - lockedViewAng.y)
				if ydiff > allowedFromCentreX then
					lockedViewAng.y = angles.y - allowedFromCentreX
				elseif ydiff < -allowedFromCentreX then
					lockedViewAng.y = angles.y + allowedFromCentreX
				end
				local pdiff = (angles.p - lockedViewAng.p)
				if pdiff > allowedFromCentreY then
					lockedViewAng.p = angles.p - allowedFromCentreY
				elseif pdiff < -allowedFromCentreY then
					lockedViewAng.p = angles.p + allowedFromCentreY
				end
			end
			cmd:SetViewAngles (angles)
		elseif lockedViewAng then
			--cmd:SetViewAngles (lockedViewAng)
			--lockedViewAng = false
			--lastRealViewAng = false
			local angles = cmd:GetViewAngles()
			
			if lastRealViewAng then
				SimilarizeAngles (lastRealViewAng, angles)
				local diff = angles - lastRealViewAng
				--diff = diff * (LocalPlayer():GetActiveWeapon().MouseSensitivity or 1)
				lockedViewAng = lockedViewAng + diff
			end
			
			if not returnJourney then
				SimilarizeAngles (lockedViewAng, angles)
				returnJourney = lockedViewAng - angles
				returnJourney = returnJourney * (1/LocalPlayer():GetActiveWeapon().DegreeOfZoom)
			end
			
			if LocalPlayer():GetActiveWeapon().DegreeOfZoom > 0 then
				angles = angles + (returnJourney * (FrameTime() / LocalPlayer():GetActiveWeapon().ZoomTime))
				cmd:SetViewAngles (angles)
				lastRealViewAng = angles
			else
				lockedViewAng = false
				lastRealViewAng = false
				returnJourney = false
			end
		end
		LocalPlayer():SetFOV (LocalPlayer():GetActiveWeapon().FOVToSet or nil)
	else
		if lockedViewAng then
			lockedViewAng = false
			lastRealViewAng = false
			LocalPlayer():SetFOV (nil)
		end
	end
end

hook.Add ("CreateMove", "LNLCM", StationaryAimingCreateMove)

if CLIENT then
	surface.CreateFont( "HL2MP", ScreenScaleH( 60 ), 500, true, true, "HL2SelectIcons" )

	function SWEP:DrawWeaponSelection (x, y, wide, tall, alpha) 
		draw.SimpleText (self.IconLetter, self.IconLetterFont or "CSSelectIcons", x + wide/2, y + tall*0.2, Color (150, 150, 255, 255), TEXT_ALIGN_CENTER) 	 
	end
end