if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "M1014 Shotgun"
	SWEP.IconLetter = "B"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_xm1014", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "gta_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.IronSightsPos = Vector( 5.1476, -4.3763, 2.1642 )
SWEP.IronSightsAng = Vector( -0.1387, 0.6955, 0 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound("weapons/shotgun/shotgun_fire6.wav")
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 10
SWEP.Primary.Cone			= 0.100
SWEP.Primary.Delay			= 0.300
SWEP.Primary.ShellType      = SHELL_SHOTGUN

SWEP.Primary.ClipSize		= 8
SWEP.Primary.Automatic		= true

function SWEP:Deploy()

	self.Weapon:SetNWBool( "Reloading", false )

	if SERVER then
		self.Weapon:ToggleIronsights( false )
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:CanPrimaryAttack()

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		self.Weapon:SetNWBool( "Reloading", false )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
		
		return false
	
	end

	if self.Weapon:Clip1() <= 0 and not self.Weapon:GetNWBool( "Reloading", false ) then
	
		self.Weapon:ToggleIronsights( false )
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
		return false
		
	end
	
	if self.Weapon:GetNWBool( "Reloading", false ) then
		return false
	end
	
	return true
	
end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	if SERVER and not self.Weapon:GetNWBool( "Reloading", false ) then
		self.Weapon:ToggleIronsights( !self.Owner:GetNWBool( "Ironsights", false ) )
	end

end

function SWEP:Reload()
	
	if SERVER then
		self.Weapon:ToggleIronsights( false )
	end	
	
	if self.Weapon:Clip1() < self.Primary.ClipSize and not self.Weapon:GetNWBool( "Reloading", false ) then
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
		
	end
	
end

function SWEP:Think()

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		if self.Weapon:GetVar( "ReloadTimer", 0 ) < CurTime() then
			
			// Finsished reload
			if self.Weapon:Clip1() >= self.Primary.ClipSize then
			
				self.Weapon:SetNWBool( "Reloading", false )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
				
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				
				return
				
			end
			
			// Next cycle
			self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
			
		end
	end
end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 2.0
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		scale = math.Clamp( aimcone / 1.2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		self:BulletCallback(  attacker, tr, dmginfo, 0 )
	end
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:DrawHUD()

	if self.Owner:GetNWBool( "Ironsights", false ) then return end

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	local scale = self.Primary.Cone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = self.Primary.Cone * 2.0
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		scale = math.Clamp( self.Primary.Cone / 1.2, 0, 10 )
	end
	
	//scale = math.Clamp( ( 10 + ( scale * ( 260 * (ScrH()/720) ) ) ) * self.CrossScale:GetFloat(), 0, (ScrH()/2) - 100 )
	//self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 )
	
	// CAN'T GET THIS TO WORK NICELY
	
	scale = scale * scalebywidth * self.CrossScale:GetFloat()
	
	local dist = math.abs(self.CrosshairScale - scale)
	self.CrosshairScale = math.Approach(self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05)
	
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)
	
end