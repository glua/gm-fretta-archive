-- CAN THE SHOTGUN DESTROY DOORS WITH THE BUCKSHOT ROUNDS? 1 = YES, 0 = NO
SWEP.DestroyDoor = 1
--------------------------------------------------------------------------

-- Read the weapon_real_base if you really want to know what each action does

/*---------------------------------------------------------*/
local HitImpact = function(attacker, tr, dmginfo)

	local hit = EffectData()
	hit:SetOrigin(tr.HitPos)
	hit:SetNormal(tr.HitNormal)
	hit:SetScale(20)
	util.Effect("effect_hit", hit)

	return true
end
/*---------------------------------------------------------*/

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "shotgun"
end

if (CLIENT) then
	SWEP.PrintName 		= "BENELLI M3 SUPER 90"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "k"

	killicon.AddFont("weapon_real_cs_pumpshotgun", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_grenade" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "rg_shelleject_shotgun" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models

SWEP.EjectDelay			= 0.53
/*-------------------------------------------------------*/

local DoorSound = Sound("physics/wood/wood_box_impact_hard3.wav")
local ShotgunReloading
ShotgunReloading = false

SWEP.Instructions 		= "Buckshot Damage (Per buckshot lead): 9% \nSlug Damage (Per slug): 88% \nRecoil: 50% \nBuckshot Precision: 55% \nSlug Precision: 85% \nType: Pump-Action \n\nChange Mode: E + Right Click"

SWEP.Base 				= "weapon_real_base_pistol"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel 			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil 		= 5
SWEP.Primary.Damage 		= 9
SWEP.Primary.NumShots 		= 12
SWEP.Primary.Cone 		= 0.045
SWEP.Primary.ClipSize 		= 8
SWEP.Primary.Delay 		= 0.95
SWEP.Primary.DefaultClip 	= 8
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "buckshot"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (5.7431, -1.6786, 3.3682)
SWEP.IronSightsAng 		= Vector (0.0634, -0.0235, 0)

SWEP.data 				= {}
SWEP.mode 				= "burst"	-- Start with the buckshot rounds

SWEP.data.burst 			= {}		-- Buckshot Rounds
SWEP.data.burst.Cone 		= 0.045	-- Cone of the buckshot rounds
SWEP.data.burst.NumShots 	= 12		-- 12 little leads
SWEP.data.burst.Damage 		= 9		-- Damage of a lead

SWEP.data.semi 			= {}		-- Slug Rounds
SWEP.data.semi.Cone 		= 0.015	-- Cone of the slug rounds
SWEP.data.semi.NumShots 	= 1		-- 1 big lead
SWEP.data.semi.Damage 		= 88		-- Damage of the big lead

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 2 then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire

	self.Reloadaftershoot = CurTime() + self.Primary.Delay
	-- Set the reload after shoot to be not able to reload when firering

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	-- Set next secondary fire after your fire delay

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	-- Set next primary fire after your fire delay

	self.Weapon:EmitSound(self.Primary.Sound)
	-- Emit the gun sound when you fire

	self:RecoilPower()

	self:TakePrimaryAmmo(1)
	-- Take 1 ammo in you clip

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:KeyDown(IN_USE) then
		if self.mode == "semi" then
			self.mode = "burst"
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Buckshot Rounds" )
			self.Weapon:SetNextSecondaryFire(CurTime() + 1)
			self.Weapon:SetNextPrimaryFire(CurTime() + 1)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			timer.Simple(0.3, function() self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) end)
		else
			self.mode = "semi"
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Slug Rounds" )
			self.Weapon:SetNextSecondaryFire(CurTime() + 1)
			self.Weapon:SetNextPrimaryFire(CurTime() + 1)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			timer.Simple(0.3, function() self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) end)
		end
		self.data[self.mode].Init(self)

	elseif SERVER then
		end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	-- Set the deploy animation when deploying

	self:SetIronsights( false )
	-- Set the ironsight mod to false

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	-- Set the next primary fire to 1 second after deploying

	ShotgunReloading = false
	self.Weapon:SetNetworkedBool( "reloading", false)

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	-- Set the deploy animation when deploying

	self:SetIronsights( false )
	-- Set the ironsight mod to false

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	-- Set the next primary fire to 1 second after deploying

	self.Reloadaftershoot = CurTime() + 1

	return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end

	if (self.Weapon:GetNWBool("reloading", false)) or ShotgunReloading then return end

	if (self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
			ShotgunReloading = true
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		timer.Simple(0.3, function()
			ShotgunReloading = false
			self.Weapon:SetNetworkedBool("reloading", true)
			self.Weapon:SetVar("reloadtimer", CurTime() + 1)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		end)
	end

	self.Owner:SetFOV( 0, 0.15 )
	-- Zoom = 0

	self:SetIronsights(false)
	-- Set the ironsight to false
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.Weapon:Clip1() > self.Primary.ClipSize then
		self.Weapon:SetClip1(self.Primary.ClipSize)
	end

	if self.Weapon:GetNetworkedBool( "reloading") == true then
	
		if self.Weapon:GetNetworkedInt( "reloadtimer") < CurTime() then
			if self.unavailable then return end

			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
				self.Weapon:SetNetworkedBool( "reloading", false)
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			else
			
			self.Weapon:SetNetworkedInt( "reloadtimer", CurTime() + 0.45 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)

				if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0) then
					self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
					self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
				else
					self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
					self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
				end
			end
		end
	end

	self:IronSight()

	if self.Owner:KeyPressed(IN_ATTACK) and (self.Weapon:GetNWBool("reloading", true)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:SetNetworkedBool( "reloading", false)
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
	end
end

/*---------------------------------------------------------
RecoilPower | Shotgun
---------------------------------------------------------*/
function SWEP:RecoilPower()

	if not self.Owner:IsOnGround() then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.data[self.mode].Damage, self.Primary.Recoil, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Put normal recoil when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil), math.Rand(-1,1) * (self.Primary.Recoil), 0))
			-- Punch the screen 1x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.data[self.mode].Damage, self.Primary.Recoil * 2.5, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Recoil * 2.5

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil * 2.5), math.Rand(-1,1) * (self.Primary.Recoil * 2.5), 0))
			-- Punch the screen * 2.5
		end

	elseif self.Owner:KeyDown(IN_FORWARD | IN_BACK | IN_MOVELEFT | IN_MOVERIGHT) then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.data[self.mode].Damage, self.Primary.Recoil / 2, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Put recoil / 2 when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 1.5), math.Rand(-1,1) * (self.Primary.Recoil / 1.5), 0))
			-- Punch the screen 1.5x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.data[self.mode].Damage, self.Primary.Recoil * 1.5, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Recoil * 1.5

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil * 1.5), math.Rand(-1,1) * (self.Primary.Recoil * 1.5), 0))
			-- Punch the screen * 1.5
		end

	elseif self.Owner:Crouching() then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.data[self.mode].Damage, 0, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Put 0 recoil when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 3), math.Rand(-1,1) * (self.Primary.Recoil / 3), 0))
			-- Punch the screen 3x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.data[self.mode].Damage, self.Primary.Recoil / 2, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Recoil / 2

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 2), math.Rand(-1,1) * (self.Primary.Recoil / 2), 0))
			-- Punch the screen / 2
		end
	else
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.data[self.mode].Damage, self.Primary.Recoil / 6, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Put recoil / 4 when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 2), math.Rand(-1,1) * (self.Primary.Recoil / 2), 0))
			-- Punch the screen 2x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.data[self.mode].Damage, self.Primary.Recoil, self.data[self.mode].NumShots, self.data[self.mode].Cone)
			-- Put normal recoil when you're not in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * self.Primary.Recoil, math.Rand(-1,1) *self.Primary.Recoil, 0))
			-- Punch the screen
		end
	end
end

/*---------------------------------------------------------
ShootBullet
---------------------------------------------------------*/
function SWEP:CSShootBullet(dmg, recoil, numbul, cone)

	numbul 		= numbul or 1
	cone 			= cone or 0.01

	local bullet 	= {}
	bullet.Num  	= numbul
	bullet.Src 		= self.Owner:GetShootPos()       					-- Source
	bullet.Dir 		= self.Owner:GetAimVector()      					-- Dir of bullet
	bullet.Spread 	= Vector(cone, cone, 0)     						-- Aim Cone
	bullet.Tracer 	= 1       									-- Show a tracer on every x bullets
	bullet.Force 	= 0.5 * dmg     								-- Amount of force to give to phys objects
	bullet.Damage 	= dmg										-- Amount of damage to give to the bullets
	bullet.Callback 	= HitImpact
-- 	bullet.Callback	= function ( a, b, c ) BulletPenetration( 0, a, b, c ) end 	-- CALL THE FUNCTION BULLETPENETRATION

	self.Owner:FireBullets(bullet)					-- Fire the bullets
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)      	-- View model animation
	self.Owner:MuzzleFlash()        					-- Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

	local fx 		= EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(self.MuzzleAttachment)
	util.Effect(self.MuzzleEffect,fx)					-- Additional muzzle effects
	
	timer.Simple( self.EjectDelay, function()
		if  not IsFirstTimePredicted() then 
			return
		end

			local fx 	= EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetNormal(self.Owner:GetAimVector())
			fx:SetAttachment(self.ShellEjectAttachment)

			util.Effect(self.ShellEffect,fx)				-- Shell ejection
	end)

	if ((SinglePlayer() and SERVER) or (not SinglePlayer() and CLIENT)) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end

 	local trace = self.Owner:GetEyeTrace();

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 250 or self.DestroyDoor == 0 then return end

	if trace.Entity:GetClass() == "prop_door_rotating" and self.mode == "burst" and (SERVER) then

		trace.Entity:Fire("open", "", 0.001)
		trace.Entity:Fire("unlock", "", 0.001)

		local pos = trace.Entity:GetPos()
		local ang = trace.Entity:GetAngles()
		local model = trace.Entity:GetModel()
		local skin = trace.Entity:GetSkin()

		local smoke = EffectData()
			smoke:SetOrigin(pos)
			util.Effect("effect_smokedoor", smoke)

		trace.Entity:SetNotSolid(true)
		trace.Entity:SetNoDraw(true)

		local function ResetDoor(door, fakedoor)
			door:SetNotSolid(false)
			door:SetNoDraw(false)
			fakedoor:Remove()
		end

		local norm = (pos - self.Owner:GetPos()):Normalize()
		local push = 10000 * norm
		local ent = ents.Create("prop_physics")

		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetModel(model)

		if(skin) then
			ent:SetSkin(skin)
		end

		ent:Spawn()

		timer.Simple(0.01, ent.SetVelocity, ent, push)               
		timer.Simple(0.01, ent:GetPhysicsObject().ApplyForceCenter, ent:GetPhysicsObject(), push)
		timer.Simple(25, ResetDoor, trace.Entity, ent)
	end
end