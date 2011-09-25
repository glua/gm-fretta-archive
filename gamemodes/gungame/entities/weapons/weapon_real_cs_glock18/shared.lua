-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "pistol"
end

if (CLIENT) then
	SWEP.PrintName 		= "GLOCK 18"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "c"

	killicon.AddFont("weapon_real_cs_glock18", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.Instructions 		= "Damage: 12% \nRecoil: 15% \nPrecision: 86% \nType: Semi-Automatic and Burst \n\nChange Mode: E + Right Click"

SWEP.Base 				= "weapon_real_base_pistol"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_glock18.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_Glock.Single")
SWEP.Primary.Recoil 		= 1.5
SWEP.Primary.Damage 		= 12
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.014
SWEP.Primary.ClipSize 		= 19
SWEP.Primary.Delay 		= 0.1
SWEP.Primary.DefaultClip 	= 19
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "pistol"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (4.334, -4.5101, 2.8296)
SWEP.IronSightsAng 		= Vector (0.7354, 0.0593, 0)

SWEP.data 				= {}
SWEP.mode 				= "semi"

SWEP.data.semi 			= {}
SWEP.data.semi.Cone 		= 0.015

SWEP.data.burst 			= {}
SWEP.data.burst.Delay 		= 0.2
SWEP.data.burst.Cone 		= 0.03
SWEP.data.burst.BurstDelay 	= 0.05
SWEP.data.burst.Shots 		= 3
SWEP.data.burst.Counter 	= 0
SWEP.data.burst.Timer 		= 0

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

	if self.mode == "burst" then
		self.data.burst.Timer = CurTime()
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.data.burst.Counter = self.data.burst.Shots - 1
	end

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
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		else
			self.mode = "semi"
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		end
		self.data[self.mode].Init(self)

	elseif SERVER then
	end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.data.init then		
		self.data.init = nil
	end
	if self.mode == "burst" then
		if self.data.burst.Timer + self.data.burst.BurstDelay < CurTime() then
			if self.data.burst.Counter > 0 then
				self.data.burst.Counter = self.data.burst.Counter - 1
				self.data.burst.Timer = CurTime()
				
				if self:CanPrimaryAttack() then
					self.Weapon:EmitSound(self.Primary.Sound)
					if self.Owner:GetFOV() == 0 then
						self:RecoilPower()
					else
						self:RecoilPower()
					end
					self:TakePrimaryAmmo( 1 )
				end
			end
		end
	end

	self:IronSight()
end

/*---------------------------------------------------------
RecoilPower
---------------------------------------------------------*/
function SWEP:RecoilPower()

	if not self.Owner:IsOnGround() then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Put normal recoil when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil), math.Rand(-1,1) * (self.Primary.Recoil), 0))
			-- Punch the screen 1x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil * 2.5, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Recoil * 2.5

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil * 2.5), math.Rand(-1,1) * (self.Primary.Recoil * 2.5), 0))
			-- Punch the screen * 2.5
		end

	elseif self.Owner:KeyDown(IN_FORWARD | IN_BACK | IN_MOVELEFT | IN_MOVERIGHT) then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil / 2, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Put recoil / 2 when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 1.5), math.Rand(-1,1) * (self.Primary.Recoil / 1.5), 0))
			-- Punch the screen 1.5x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil * 1.5, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Recoil * 1.5

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil * 1.5), math.Rand(-1,1) * (self.Primary.Recoil * 1.5), 0))
			-- Punch the screen * 1.5
		end

	elseif self.Owner:Crouching() then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, 0, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Put 0 recoil when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 3), math.Rand(-1,1) * (self.Primary.Recoil / 3), 0))
			-- Punch the screen 3x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil / 2, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Recoil / 2

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 2), math.Rand(-1,1) * (self.Primary.Recoil / 2), 0))
			-- Punch the screen / 2
		end
	else
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil / 6, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Put recoil / 4 when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 2), math.Rand(-1,1) * (self.Primary.Recoil / 2), 0))
			-- Punch the screen 2x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].Cone)
			-- Put normal recoil when you're not in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * self.Primary.Recoil, math.Rand(-1,1) *self.Primary.Recoil, 0))
			-- Punch the screen
		end
	end
end