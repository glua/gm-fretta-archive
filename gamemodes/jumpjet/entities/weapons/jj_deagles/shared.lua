if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Dual Deagles"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "s"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_deagles", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_deagles", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Deploy         = Sound( "weapons/deagle/de_deploy.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/elite/elite_clipout.wav" ), 
								Sound( "weapons/fiveseven/fiveseven_clipin.wav" ),
								Sound( "weapons/elite/elite_leftclipin.wav" ),
								Sound( "weapons/p228/p228_sliderelease.wav" ),
								Sound( "weapons/p228/p228_slidepull.wav" ) }
SWEP.Primary.ReloadTime     = 3.60 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.35 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.015 // how fast does recoil fade away?
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.150 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.420
SWEP.Primary.ShotDelay      = 0.100

SWEP.Primary.ClipSize		= 14
SWEP.Primary.Automatic		= false

function SWEP:Think()

	if self.NextShot and self.NextShot < CurTime() then
	
		self.NextShot = nil
	
		self.Weapon:EmitSound( self.Primary.Sound, 150, math.random(95,105) )
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		self.Weapon:AddRecoil( self.Primary.Recoil )
		self.Weapon:TakeAmmo()
	
	end

	if SERVER then
	
		self.Weapon:TakeRecoil( self.Primary.RecoilFade )
		
	end
		
	if not self.Weapon:IsReloading() then return end
		
	for k,v in pairs( self.ReloadTimes ) do
		
		if v != -1 and v < CurTime() and SERVER then
			
			self.ReloadTimes[k] = -1
				
			self.Owner:EmitSound( self.Primary.ReloadSounds[k], 100, math.random(90,110) )
			
		end
		
	end
		
	if self.ReloadEnd and self.ReloadEnd < CurTime() then
		
		self.Weapon:EndReload()
			
	end
		
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 150, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:AddRecoil( self.Primary.Recoil )
	self.Weapon:TakeAmmo()
	
	self.NextShot = CurTime() + self.Primary.ShotDelay
	
end	

function SWEP:GetTracerOrigin()

	if not self.TopTracer then

		self.TopTracer = true
		return self.Owner:GetShootPos() + self.Owner:GetUp() * 3

	else
	
		self.TopTracer = nil
		return self.Owner:GetShootPos() + self.Owner:GetUp() * -3
	
	end
end
