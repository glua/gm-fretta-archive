if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "shotgun"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "SPAS 12"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "k"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_spas12", "HL2MPTypeDeath", "0", Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_spas12", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Primary.Sound			= Sound( "weapons/shotgun/shotgun_fire7.wav" )
SWEP.Primary.Deploy         = Sound( "Weapon_Shotgun.Special1" )
SWEP.Primary.Reload         = Sound( "weapons/shotgun/shotgun_reload1.wav" )
SWEP.Primary.ReloadTime     = 0.50 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.35 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.005 // how fast does recoil fade away?
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 11
SWEP.Primary.Cone			= 4.300 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.480

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false

function SWEP:Deploy()

	self.Weapon:SetNWInt( "Pump", -1 )
	self.Weapon:SetNWInt( "Reloading", -1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )

	if SERVER then
		self.Owner:EmitSound( self.Primary.Deploy )
	end
	
	return true
	
end  

function SWEP:CanPrimaryAttack()

	if self.Weapon:Clip1() <= 0 and self.Weapon:GetNWInt( "Reloading", 0 ) == -1 then
	
		self.Weapon:SetNWInt( "Reloading", CurTime() + 0.5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.6 )
		
		return false
		
	end
	
	if self.Weapon:GetNWInt( "Reloading", 0 ) != -1 then
	
		self.Weapon:SetNWInt( "Reloading", -1 )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.ReloadTime )
		
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end
	
	if SERVER then
	
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
	end

	self.Weapon:SetNWInt( "Pump", CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:AddRecoil( self.Primary.Recoil )
	self.Weapon:TakeAmmo()
	
end	

function SWEP:Think()

	if SERVER then
		self.Weapon:TakeRecoil( self.Primary.RecoilFade )
	end
	
	if self.Weapon:GetNWInt( "Pump", 0 ) != -1 and self.Weapon:GetNWInt( "Pump", 0 ) < CurTime() then 
	
		self.Weapon:SetNWInt( "Pump", -1 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:EmitSound( self.Primary.Deploy, 100, math.random(90,110) )
		
	end
	
	if self.Weapon:GetNWInt( "Reloading", 0 ) == -1 then return end
	
	if self.Weapon:GetNWInt( "Reloading", 0 ) < CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize then
	
		self.Weapon:SetNWInt( "Reloading", CurTime() + self.Primary.ReloadTime )
		self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		self.Weapon:EmitSound( self.Primary.Reload, 100, math.random(90,110) )
		
		return
	
	elseif self.Weapon:GetNWInt( "Reloading", 0 ) < CurTime() and self.Weapon:Clip1() == self.Primary.ClipSize then
	
		self.Weapon:SetNWInt( "Reloading", -1 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.25 )
	
	end
	
end

function SWEP:Reload()

	if self.Weapon:Clip1() == self.Primary.ClipSize or self.Weapon:GetNWInt( "Reloading", 0 ) != -1 then return end
	
	self.Weapon:SetNWInt( "Reloading", CurTime() + 0.2 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.6 )
	self.Owner:SetAnimation( PLAYER_RELOAD )
	
	return true
	
end

function SWEP:DrawHUD()

	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	local scale = self.Primary.Cone
	
	if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() != 0 then
		scale = self.Primary.Cone * 1.50
	elseif self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = self.Primary.Cone * 1.25
		if self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
			scale = self.Primary.Cone
		end
	elseif self.Owner:KeyDown( IN_DUCK ) or ( self.Owner:KeyDown( IN_WALK ) and self.Owner:GetVelocity():Length() != 0 ) then
		scale = math.Clamp( self.Primary.Cone * 0.75, 0, 10 )
	end
	
	scale = ( scale + self.Weapon:GetRecoil() ) 

	local dist = math.abs( self.CrosshairScale - scale )
	self.CrosshairScale = math.Approach( self.CrosshairScale, scale / 5, FrameTime() * 2 + dist * 0.05 )

	local x = ScreenPos.x
	local y = ScreenPos.y
	local gap = 3 + 30 * self.CrosshairScale
	local length = 3 + gap + 20 * self.CrosshairScale
	local edge = 3 + 15 * self.CrosshairScale
	local pad = 3 + 5 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	
	self.Weapon:DrawCorner( x - pad - edge, y - pad, x - pad - edge, y - pad - edge, x - pad, y - pad - edge )
	self.Weapon:DrawCorner( x + pad + edge, y - pad, x + pad + edge, y - pad - edge, x + pad, y - pad - edge )
	self.Weapon:DrawCorner( x + pad + edge, y + pad, x + pad + edge, y + pad + edge, x + pad, y + pad + edge )
	self.Weapon:DrawCorner( x - pad - edge, y + pad, x - pad - edge, y + pad + edge, x - pad, y + pad + edge )
	
	if ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() and tr.Entity:Team() != self.Owner:Team() then
	
		surface.SetDrawColor( 255, 0, 0, 255 )
	
	end
	
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
	
end