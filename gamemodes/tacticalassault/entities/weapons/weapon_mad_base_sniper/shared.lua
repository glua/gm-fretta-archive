// Variables that are used on both client and server
// The scope code is based on the Realistic Weapons Base made by Teta Bonita

SWEP.Base				= "weapon_mad_base"
SWEP.HoldType				= "ar2"

SWEP.ShellEffect			= "effect_mad_shell_rifle"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 1

SWEP.Pistol				= false
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= true

SWEP.Penetration			= true
SWEP.Ricochet			= true

local sndZoomIn 		= Sound("Weapon_AR2.Special1")
local sndZoomOut 		= Sound("Weapon_AR2.Special2")
local sndCycleZoom 	= Sound("Default.Zoom")

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

	util.PrecacheSound("weapons/sniper/sniper_zoomin.wav")
	util.PrecacheSound("weapons/sniper/sniper_zoomout.wav")
	util.PrecacheSound("weapons/zoom.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Initialize()
   Desc: Called when the weapon is first loaded.
---------------------------------------------------------*/
function SWEP:Initialize()

	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)

		// Fucking NPCs
		self:SetNPCMinBurst(30)
		self:SetNPCMaxBurst(30)
		self:SetNPCFireRate(self.Primary.Delay)
	end

	if (CLIENT) then
		local iScreenWidth 	= surface.ScreenWidth()
		local iScreenHeight 	= surface.ScreenHeight()
		
		self.ScopeTable 		= {}
		self.ScopeTable.l 	= iScreenHeight * self.ScopeScale
		self.ScopeTable.x1 	= 0.5 * (iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 	= 0.5 * (iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 	= self.ScopeTable.x1
		self.ScopeTable.y2 	= 0.5 * (iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 	= 0.5 * (iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 	= self.ScopeTable.y2
		self.ScopeTable.x4 	= self.ScopeTable.x3
		self.ScopeTable.y4 	= self.ScopeTable.y1
				
		self.ParaScopeTable 	= {}
		self.ParaScopeTable.x 	= 0.5 * iScreenWidth - self.ScopeTable.l
		self.ParaScopeTable.y 	= 0.5 * iScreenHeight - self.ScopeTable.l
		self.ParaScopeTable.w 	= 2 * self.ScopeTable.l
		self.ParaScopeTable.h 	= 2 * self.ScopeTable.l
		
		self.ScopeTable.l 	= (iScreenHeight + 1) * self.ScopeScale

		self.QuadTable 		= {}
		self.QuadTable.x1 	= 0
		self.QuadTable.y1 	= 0
		self.QuadTable.w1 	= iScreenWidth
		self.QuadTable.h1 	= 0.5 * iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 	= 0
		self.QuadTable.y2 	= 0.5 * iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 	= self.QuadTable.w1
		self.QuadTable.h2 	= self.QuadTable.h1
		self.QuadTable.x3 	= 0
		self.QuadTable.y3 	= 0
		self.QuadTable.w3 	= 0.5 * iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 	= iScreenHeight
		self.QuadTable.x4 	= 0.5 * iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 	= 0
		self.QuadTable.w4 	= self.QuadTable.w3
		self.QuadTable.h4 	= self.QuadTable.h3

		self.LensTable 		= {}
		self.LensTable.x 		= self.QuadTable.w3
		self.LensTable.y 		= self.QuadTable.h1
		self.LensTable.w 		= 2 * self.ScopeTable.l
		self.LensTable.h 		= 2 * self.ScopeTable.l

		self.CrossHairTable 	= {}
		self.CrossHairTable.x11 = 0
		self.CrossHairTable.y11 = 0.5 * iScreenHeight
		self.CrossHairTable.x12 = iScreenWidth
		self.CrossHairTable.y12 = self.CrossHairTable.y11
		self.CrossHairTable.x21 = 0.5 * iScreenWidth
		self.CrossHairTable.y21 = 0
		self.CrossHairTable.x22 = 0.5 * iScreenWidth
		self.CrossHairTable.y22 = iScreenHeight
	end

	self.ScopeZooms 			= self.ScopeZooms or {5}
	self.CurScopeZoom			= 1

	self:ResetVariables()
end

/*---------------------------------------------------------
   Name: SWEP:ResetVariables()
   Desc: Reset all varibles.
---------------------------------------------------------*/
function SWEP:ResetVariables()

	self.bLastIron = false
	self.Weapon:SetDTBool(1, false)
	
	self.CurScopeZoom 		= 1
	self.fLastScopeZoom 		= 1
	self.bLastScope 			= false

	self.Weapon:SetDTBool(2, false)
	self.Weapon:SetNetworkedFloat("ScopeZoom", self.ScopeZooms[1])
	
	if (self.Owner) then
		self.OwnerIsNPC 		= self.Owner:IsNPC()
	end
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	// When the weapon is already doing an animation, just return end because we don't want to interrupt it
	if (self.ActionDelay > CurTime()) then return end 

	// Need to call the default reload before the real reload animation (don't try to understand my reason)
	self.Weapon:DefaultReload(ACT_VM_RELOAD)

	if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
		self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration())
	end

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self:SetIronsights(false)
		self:ReloadAnimation()

		self:ResetVariables()

		if not (CLIENT) then
			self.Owner:DrawViewModel(true)
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if (not self:CanPrimaryAttack()) then return end

	self.ActionDelay = (CurTime() + self.Primary.Delay + 0.05)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	// If the burst mode is activated, it's going to shoot the three bullets (or more if you're dumb and put 4 or 5 bullets for your burst mode)
	if self.Weapon:GetNetworkedBool("Burst") then
		self.BurstTimer 	= CurTime()
		self.BurstCounter = self.BurstShots - 1
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	end

	if (not self.Owner:IsNPC()) and (self.BoltActionSniper) and (self.Weapon:GetDTBool(1)) then
		self:ResetVariables()
		self.ScopeAfterShoot = true

		timer.Simple(self.Primary.Delay, function()
			if not self.Owner then return end

			if (self.ScopeAfterShoot) and (self.Weapon:Clip1() > 0) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
				self:SetIronsights(true)
			end
		end)
	end

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo(1)

	self:ShootBulletInformation()
end

/*---------------------------------------------------------
   Name: function SimilarizeAngles()
---------------------------------------------------------*/
local LastViewAng = false

local function SimilarizeAngles(ang1, ang2)

	ang1.y = math.fmod (ang1.y, 360)
	ang2.y = math.fmod (ang2.y, 360)

	if math.abs (ang1.y - ang2.y) > 180 then
		if ang1.y - ang2.y < 0 then
			ang1.y = ang1.y + 360
		else
			ang1.y = ang1.y - 360
		end
	end
end

/*---------------------------------------------------------
   Name: function ReduceScopeSensitivity()
---------------------------------------------------------*/
local function ReduceScopeSensitivity(uCmd)

	if LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() then
		local newAng = uCmd:GetViewAngles()

		if LastViewAng then
			SimilarizeAngles (LastViewAng, newAng)

			local diff = newAng - LastViewAng

			diff = diff * (LocalPlayer():GetActiveWeapon().MouseSensitivity or 1)
			uCmd:SetViewAngles (LastViewAng + diff)
		end
	end

	LastViewAng = uCmd:GetViewAngles()
end 
hook.Add ("CreateMove", "ReduceScopeSensitivity", ReduceScopeSensitivity)

/*---------------------------------------------------------
   Name: SWEP:SetIronsights()
---------------------------------------------------------*/
local IRONSIGHT_TIME = 0.2

function SWEP:SetIronsights(b)

	if (CLIENT) then return end

	if (self.Weapon) then
		self.Weapon:SetDTBool(1, b)
	end
	
	if (b) then
		timer.Simple(IRONSIGHT_TIME, self.SetScope, self, true, player)
	else
		self:SetScope(false, player)
	end
end

/*---------------------------------------------------------
   Name: SWEP:SetScope()
---------------------------------------------------------*/
function SWEP:SetScope(b, player)

	if CLIENT || !ValidEntity(self.Weapon) then return end

	local PlaySound = b ~= self.Weapon:GetDTBool(2) // Only play zoom sounds when chaning in/out of scope mode
	self.CurScopeZoom = 1 // Just in case
	self.Weapon:SetNetworkedFloat("ScopeZoom", self.ScopeZooms[self.CurScopeZoom])

	if (b) then 
		if (PlaySound) then
			self.Weapon:EmitSound(sndZoomIn)
		end
	else
		if PlaySound then
			self.Weapon:EmitSound(sndZoomOut)
		end
	end
	
	// Send the scope state to the client, so it can adjust the player's fov/HUD accordingly
	self.Weapon:SetDTBool(2, b) 
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	self:SecondThink()

	if self.IdleDelay < CurTime() and self.IdleApply and self.Weapon:Clip1() > 0 then
		local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

		if self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
			if self.Weapon:GetNetworkedBool("Suppressor") then
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
			else
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			end

			if self.AllowPlaybackRate and not self.Weapon:GetDTBool(1) then
				self.Owner:GetViewModel():SetPlaybackRate(1)
			else
				self.Owner:GetViewModel():SetPlaybackRate(0)
			end	
		end

		self.IdleApply = false
	elseif self.Weapon:Clip1() <= 0 then
		self.IdleApply = false
	end

	if (self.Weapon:GetDTBool(1) or self.Weapon:GetDTBool(2)) and self.Owner:KeyDown(IN_SPEED) then
		self:ResetVariables()
		self.Owner:SetFOV(0, 0.2)
	end

	if (self.BoltActionSniper) and (self.Owner:KeyPressed(IN_ATTACK2) or self.Owner:KeyPressed(IN_RELOAD)) then
		self.ScopeAfterShoot = false
	end

	if self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0) then
		if (self.BoltActionSniper) then
			self.ScopeAfterShoot = false
		end

		if self.Rifle or self.Sniper or self.Shotgun then
			if (SERVER) then
				self:SetWeaponHoldType("passive")
			end
		elseif self.Pistol then
			if (SERVER) then
				self:SetWeaponHoldType("normal")
			end
		end
	else
		if (SERVER) then
			self:SetWeaponHoldType(self.HoldType)
		end
	end

	if self.Weapon:GetNetworkedBool("Burst") then
		if self.BurstTimer + self.BurstDelay < CurTime() then
			if self.BurstCounter > 0 then
				self.BurstCounter = self.BurstCounter - 1
				self.BurstTimer = CurTime()
				
				if self:CanPrimaryAttack() then
					self.Weapon:EmitSound(self.Primary.Sound)
					self:ShootBulletInformation()
					self:TakePrimaryAmmo(1)
				end
			end
		end
	end

	if (CLIENT) and (self.Weapon:GetDTBool(2)) then
		self.MouseSensitivity = self.Owner:GetFOV() / 60
	else
		self.MouseSensitivity = 1
	end

	if not (CLIENT) and (self.Weapon:GetDTBool(2)) and (self.Weapon:GetDTBool(1)) then
		self.Owner:DrawViewModel(false)
	elseif not (CLIENT) then
		self.Owner:DrawViewModel(true)
	end

	self:NextThink(CurTime())
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
   Desc: Weapon wants to holster.
	   Return true to allow the weapon to holster.
---------------------------------------------------------*/
function SWEP:Holster()

	self:ResetVariables()

	return true
end

/*---------------------------------------------------------
   Name: SWEP:OnRemove()
   Desc: Called just before entity is deleted.
---------------------------------------------------------*/
function SWEP:OnRemove()

	self:ResetVariables()

	return true
end

/*---------------------------------------------------------
   Name: SWEP:OwnerChanged()
   Desc: When weapon is dropped or picked up by a new player.
---------------------------------------------------------*/
function SWEP:OwnerChanged()

	self:ResetVariables()

	return true
end