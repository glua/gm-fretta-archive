// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: LaserTag rifle.

AddCSLuaFile("shared.lua")

SWEP.Author			= "Fuzzylightning"
SWEP.Contact		= "Fuzzylightning@gmail.com"
SWEP.Purpose		= "42"
SWEP.Instructions	= ""

if CLIENT then
	SWEP.PrintName			= "Laser Infantry Assault Rifle"
	SWEP.Slot				= 0				// Slot in the weapon selection menu
	SWEP.SlotPos			= 10			// Position in the slot
	SWEP.DrawAmmo			= false			// Should draw the default HL2 ammo counter
	SWEP.DrawCrosshair		= false 		// Should draw the default crosshair
	SWEP.DrawWeaponInfoBox	= false			// Should draw the weapon info box
	SWEP.BounceWeaponIcon   = false			// Should the weapon icon bounce?
	SWEP.SwayScale			= 1.0			// The scale of the viewmodel sway
	SWEP.BobScale			= 1.0			// The scale of the viewmodel bob
	SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )
	
	// Materials for drawing the custom reticule.
	SWEP.MatReticule 		= surface.GetTextureID("LaserTag/HUD/hud_reticule")
	SWEP.MatRetCorner 		= surface.GetTextureID("LaserTag/HUD/hud_retcorner")
	SWEP.RetRotation 		= 0
	SWEP.RetRotationRate 	= -1
	SWEP.RetAlpha		 	= 200
	SWEP.RetScale		 	= 0.02 // 2% of screen width.
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_smg1.mdl"
SWEP.WorldModel		= "models/weapons/w_smg1.mdl"
SWEP.AnimPrefix		= "python"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= -1				// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

SWEP.Settings = {
	Damage = 20, 						// Shield damage per hit.
	HSMulti = 3, 						// How much to multiply damage by for headshots.
	Refire = 0.25, 						// Refire rate. (Second delay between shots.)
	LasersPerFire = 1, 					// How many lasers to fire each time we shoot.
	LaserSize = 20, 					// Size of the laser beam(s).
	Spread = Vector(0.015,0.015,0.015),	// Spread of lasers.
	Punch = Angle(-2.5,0,0)				// View punch from primary fire.
}
SWEP.BaseSettings = table.Copy(SWEP.Settings) // Backup of default settings for the SWEP. Convenience for Powerups.

function SWEP:Initialize()
	util.PrecacheSound("ambient/levels/labs/electric_explosion1.wav")
	self:SetWeaponHoldType("smg")
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	// Delay the next shot (we do this first so if there is an error we don't get continuous fire)
	self:SetNextPrimaryFire(CurTime() + self.Settings.Refire)
	
	// Play fire sounds.
	
	//self.Weapon:EmitSound("weapons/ar2/npc_ar2_altfire.wav",100,200) //100,255)
	//self.Weapon:EmitSound("npc/waste_scanner/grenade_fire.wav",100,200) //100,255)
	//self.Weapon:EmitSound("npc/strider/fire.wav",100,255)
	//self.Weapon:EmitSound("ambient/machines/teleport1.wav",100,255)
	//self.Weapon:EmitSound("ambient/levels/labs/electric_explosion1.wav",100,25)
	self.Weapon:EmitSound("ambient/levels/labs/electric_explosion1.wav",80,255)
	//self.Weapon:EmitSound("ambient/levels/citadel/weapon_disintegrate4.wav",100,80)
	
	// Setup shoot position and angle.
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	
	// Fire
	self:ShootBullet(self.Settings.Damage, self.Settings.LasersPerFire, pos, ang, self.Settings.Spread)
	self.Owner:ViewPunch(self.Settings.Punch)
end
SWEP.BasePrimaryAtack = SWEP.PrimaryAttack // Backup the function, convenience for when Powerups override, alter or otherwise toy with the order of events.

function SWEP:GetRandomOffset(spread)
	return Vector(math.Rand(-spread.x,spread.x),math.Rand(-spread.y,spread.y),math.Rand(-spread.z,spread.z))
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Settings.Refire)
end
SWEP.BaseSecondaryAttack = SWEP.SecondaryAttack


/*---------------------------------------------------------
   Name: SWEP:ShootBullet()
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootBullet(damage,bullets,pos,ang,spread)
	//if not SERVER then return end
	
	// Frustratingly we have to calculate the offset for each bullet outside of the major code otherwise the generated offsets aren't random.
	// This took 5 hours to figure out, and I still don't understand precisely why it happens but it does. I assume it's something to do with prediction.
	local vOffset = {}
	for i=1,bullets do vOffset[i] = self:GetRandomOffset(spread) end
	
	for i=1,bullets do
		local adjang = ang + vOffset[i]
		
		local trace = util.TraceLine({
			start = pos,
			endpos = pos+(adjang*8000),
			filter = self.Owner
		})
		
		if SERVER then GAMEMODE:RecordStatShot(self.Owner) end
		
		if trace.HitNonWorld and trace.Entity:IsValid() and trace.Entity:IsPlayer() then
			if SERVER then self:OnHitPlayer(trace,damage) end
		else
			if SERVER then
				local bullet = {}
				bullet.Num 		= 1								// # of bullets
				bullet.Src 		= pos							// ShootPos
				bullet.Dir 		= adjang						// Bullet Direction
				bullet.Spread 	= Vector(0,0,0)					// Aim Cone (We have our own)
				bullet.Tracer	= 0								// Show tracer anim every x bullets.
				bullet.Force	= 2								// Force to apply to physics objects.
				bullet.Damage	= 15							// Damage to give.
				bullet.AmmoType = "Pistol"						// Self explanatory.
				
				self.Owner:FireBullets(bullet)
			end
			
			self:Scorch(trace)
		end
		
		self:ShootEffects()
		self:LaserTracer(pos,trace.HitPos)
	end
end
SWEP.BaseShootBullet = SWEP.ShootBullet

/*---------------------------------------------------------
   Name: SWEP:OnHitPlayer()
   Desc: What to do when we hit a player.
---------------------------------------------------------*/
function SWEP:OnHitPlayer(trace,dmg)
	// Check if we got a headshot.
	if trace.HitGroup == HITGROUP_HEAD then
		dmg = dmg * self.Settings.HSMulti
		GAMEMODE:RecordStatHeadshot(self.Owner)
	end
	

	// Apply damage
	local cl = trace.Entity:GetPlayerClass()
	cl:DamageShield(trace.Entity,dmg,self.Owner)
end

/*---------------------------------------------------------
   Name: SWEP:OnSplashPlayer()
   Desc: What to do when we hit a player with splash damage
   e.g. a rocket/bomb.
---------------------------------------------------------*/
function SWEP:OnSplashPlayer(ply,dmg)
	// Apply damage
	local cl = ply:GetPlayerClass()
	cl:DamageShield(ply,dmg,self.Owner)
end

/*---------------------------------------------------------
   Name: SWEP:Scorch()
   Desc: Create the scorch decal on the surface we hit.
---------------------------------------------------------*/
function SWEP:Scorch(trace)
	local n1 = trace.HitPos + trace.HitNormal
	local n2 = trace.HitPos - trace.HitNormal
	util.Decal("FadingScorch",n1,n2)
end


/*---------------------------------------------------------
   Name: SWEP:LaserTracer(Source of laser, End of laser)
   Desc: Create the laser tracer effect.
---------------------------------------------------------*/
function SWEP:LaserTracer(startpos,endpos)
	if not SERVER then return end
	
	local fx = EffectData()
		fx:SetStart(startpos)
		fx:SetOrigin(endpos)
		fx:SetMagnitude(self.Settings.LaserSize)
		fx:SetEntity(self)
		fx:SetAttachment(self:LookupAttachment("muzzle"))
	util.Effect("LaserTracer",fx,true,true)
end


/*---------------------------------------------------------
   Name: SWEP:ShootEffects()
   Desc: Show crappy shoot effects and animations.
---------------------------------------------------------*/
function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)					// 3rd Person Animation
end


/*---------------------------------------------------------
   Name: SWEP:Rotate()
   Desc: Slowly rotate the targeting reticule.
---------------------------------------------------------*/
function SWEP:Rotate()
	self.RetRotation = self.RetRotation + self.RetRotationRate
	
	if self.RetRotation < 0 then self.RetRotation = 360 + self.RetRotationRate end
	if self.RetRotation >= 360 then self.RetRotation = 0 + self.RetRotationRate end
end

/*---------------------------------------------------------
   Name: SWEP:DrawHUD()
   Desc: Draw HUD effects.
---------------------------------------------------------*/
function SWEP:DrawHUD()
	local col = team.GetColor(self.Owner:Team())
	local size = ScrW() * self.RetScale
	
	// Setup reticule center.
	surface.SetTexture(self.MatReticule)
	surface.SetDrawColor(col.r,col.g,col.b,self.RetAlpha)
	surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2, size, size, math.Round(self.RetRotation))
	
	surface.SetTexture(self.MatRetCorner)
	surface.DrawTexturedRectRotated(ScrW()/2 - size/2, ScrH()/2 - size/2, size/3, size/3, 0) 		// Top left.
	surface.DrawTexturedRectRotated(ScrW()/2 - size/2, ScrH()/2 + size/2, size/3, size/3, 90) 		// Bottom left.
	surface.DrawTexturedRectRotated(ScrW()/2 + size/2, ScrH()/2 + size/2, size/3, size/3, 180) 		// Bottom right.
	surface.DrawTexturedRectRotated(ScrW()/2 + size/2, ScrH()/2 - size/2, size/3, size/3, 270) 		// Top right.
	
	self:Rotate()
end
