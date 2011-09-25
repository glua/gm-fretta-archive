if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "shotgun"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Sawed Off Shotgun"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "k"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_shotgun", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_shotgun", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_annabelle.mdl"

SWEP.Primary.Sound			= Sound( "weapons/shotgun/shotgun_fire6.wav" )
SWEP.Primary.Deploy         = Sound( "weapons/m249/m249_coverdown.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/shotgun/shotgun_empty.wav" ), 
								Sound( "weapons/shotgun/shotgun_reload3.wav" ), 
								Sound( "weapons/tmp/tmp_clipin.wav" ) }
SWEP.Primary.ReloadTime     = 1.90 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.40 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.005 // how fast does recoil fade away?
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 12
SWEP.Primary.Cone			= 4.800 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.350

SWEP.Primary.ClipSize		= 2
SWEP.Primary.Automatic		= false

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