if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	SWEP.HoldType			= "ar2"
end

if ( CLIENT ) then
	SWEP.PrintName		= "CSS Scout"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
	killicon.AddFont("ins_scout", "CSKillIcons", "n", Color( 255, 80, 0, 255 ) )
end

SWEP.Base		= "ins_base"
SWEP.Category 		= "BlackOps"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"
SWEP.ViewModelFlip		= true

SWEP.Drawammo = true
SWEP.DrawCrosshair = false

SWEP.Primary.Sound		= Sound( "Weapon_Scout.Single" )
SWEP.Primary.Recoil		= 1.00
SWEP.Primary.DamageMin		= 45
SWEP.Primary.DamageMax		= 74
SWEP.Primary.BulletForce	= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.007
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay		= 1.25
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "smg1"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.CanSprintAndShoot = false

SWEP.IronSightsPos = Vector (5.018, -10.252, 2.5185)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (-0.6619, -10.848, 0.4586)
SWEP.RunArmAngle = Vector (-0.5233, -75.6133, 0)

SWEP.SprayTime = 0.2
SWEP.SprayAccuracy = 0.35

function SWEP:SecondaryAttack()
	if ( !self:CanShootWeapon() ) then return end
	if ( !self:CanPrimaryAttack() ) then return end
	if ( !self:CanSecondaryAttack() ) then return end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )

	if ( CLIENT || SinglePlayer()) then
		self.Weapon:EmitSound(Sound("npc/metropolice/gear"..math.random(1,6)..".wav"),30,math.random(75,100))
	end

	local Scoped = self.Weapon:GetNWBool("Scoped")

	--timer.Simple(0.15, function()
		self:ToggleZoom()
	--end)
end

function SWEP:PrimaryAttack()
	if ( !self:CanShootWeapon() ) then return end
	if ( !self:CanPrimaryAttack() ) then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local Scoped = self.Weapon:GetNWBool("Scoped")
	if Scoped == true then
		self:ToggleZoom()
		self:SetIronsights( false )
		self:ShootBullet( 0, self.Primary.NumShots, self.Primary.Cone/self:GetStanceAccuracyBonus() )
	else
		self:ShootBullet( 0, self.Primary.NumShots, 0.04/self:GetStanceAccuracyBonus() )
	end
	if !self.Owner:IsNPC() then
		self:TakePrimaryAmmo( self.Primary.NumShots )
	end
	
	if IsFirstTimePredicted() and self.Owner:IsValid() then

		self.Weapon:EmitSound(self.Primary.Sound)

 		//local eyeang = self.Owner:EyeAngles()
 		//eyeang.pitch = eyeang.pitch - self.Primary.Recoil

 		//self.Owner:SetEyeAngles( eyeang )

		self.Owner:ViewPunch( Angle( -self.Primary.Recoil, 0, 0 ) )
	end
	
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end

function SWEP:Deploy()

	self:SetIronsights( false )
	local Scoped = self.Weapon:GetNWBool("Scoped")
	if Scoped == true then
		self:ToggleZoom()
	end

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end  

function SWEP:ShootBullet( damage, num_bullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	--[[local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetShootPos() )
		effectdata:SetEntity( self.Weapon )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetNormal( self.Owner:GetAimVector() )
		effectdata:SetAttachment( 1 )
	util.Effect( "gunsmoke", effectdata )]]

	local bullet = {}
	bullet.Num 			= num_bullets
	bullet.Src 			= self.Owner:GetShootPos()
	bullet.Dir 			= self.Owner:GetAimVector()
	bullet.Spread 		= Vector( aimcone, aimcone, 0 )
	bullet.Tracer		= 5
	bullet.Force		= self.Primary.BulletForce
	bullet.Damage		= math.random(self.Primary.DamageMin,self.Primary.DamageMax)
	bullet.AmmoType 	= self.Primary.Ammo
	
	self.Owner:FireBullets( bullet )
end

function SWEP:Reload()
	if self.Owner:GetActiveWeapon():Clip1() == self.Primary.ClipSize then return end
	if self.Reloading || self.Owner:GetAmmoCount(self.Primary.Ammo) == 0 then return end
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		self.data.oldclip = self.Weapon:Clip1()
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
		self.data.newclip = 1
		self:SetIronsights( false )
		local Scoped = self.Weapon:GetNWBool("Scoped")
		if Scoped == true then
			self:ToggleZoom()
		end
	end
end

function SWEP:AdjustMouseSensitivity()

	local scale = 15/100
	local Scoped = self.Weapon:GetNWBool("Scoped")
	if Scoped == false then
		return nil
	end

	return scale
	
end

function SWEP:ToggleZoom()
	if self.Weapon and self.Owner then
		local Scoped = self.Weapon:GetNWBool("Scoped")
		self.Weapon:SetNWBool("Scoped", !Scoped)
		Scoped = self.Weapon:GetNWBool("Scoped")
		if ( SERVER ) then
			self.Owner:DrawViewModel(!Scoped)
		end
		if Scoped == true then
			self.Owner:SetFOV(15,0.25)
		else
			self.Owner:SetFOV(0,0.25)
		end
	end
end

function SWEP:DrawHUD()
	
	local mode = self.Weapon:GetNWBool("Scoped")
	
	if mode == true then
	
		local w = ScrW()
		local h = ScrH()
		local wr = ( h / 3 ) * 4

		surface.SetTexture( surface.GetTextureID( "gmod/scope" ) )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( ( w / 2 ) - wr / 2, 0, wr, h )
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ( w / 2 ) - wr / 2, h )
		surface.DrawRect( ( w / 2 ) + wr / 2, 0, w - ( ( w / 2 ) + wr / 2 ), h )
		surface.DrawLine( 0, h * 0.50, w, h * 0.50 )
		surface.DrawLine( w * 0.50, 0, w * 0.50, h )
	end
	
end