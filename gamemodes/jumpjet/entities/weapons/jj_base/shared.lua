if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Weight	  = 1
	SWEP.HoldType = "pistol"

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false

	SWEP.ViewModelFOV		= 10
	
	SWEP.PrintName = "Base"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "f"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall*0.2, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
	surface.CreateFont( "HL2MP", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons" )

end

SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.ReloadSounds   = { Sound( "weapons/elite/elite_clipout.wav" ) }
SWEP.Primary.ReloadTime     = 1.0  //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 1.0  //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.010 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false

SWEP.Secondary.Automatic	= false
SWEP.Secondary.ClipSize		= -1

SWEP.CrosshairScale = 1

function SWEP:Initialize()
	
	if SERVER then
		self:SetWeaponHoldType( self.HoldType )
	end
	
end

function SWEP:Deploy()

	if SERVER then
		self.Owner:EmitSound( self.Primary.Deploy )
	end
	
	return true
	
end 

function SWEP:Holster()

	if self.Weapon:IsReloading() then
	
		self.ReloadEnd = nil
		self.ReloadTimes = nil
	
	end

	return true

end 

function SWEP:InitiateReload()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.ReloadTime + 0.4 )
	
	self.ReloadTimes = {-1}
	self.ReloadEnd = CurTime() + self.Primary.ReloadTime + 0.3
	
	if CLIENT then return end

	local numsounds = #self.Primary.ReloadSounds
	local timechunk = self.Primary.ReloadTime / numsounds
	
	for i=1,numsounds do
	
		self.ReloadTimes[i] = CurTime() + ( timechunk * ( i - 1 ) )
	
	end
	
end

function SWEP:IsReloading()

	return self.ReloadTimes != nil

end

function SWEP:EndReload()

	self.ReloadTimes = nil
	self.ReloadEnd = nil
	
	self.Weapon:SetClip1( self.Primary.ClipSize )

end

function SWEP:CanPrimaryAttack()

	if self.Weapon:Clip1() <= 0 and not self.Weapon:IsReloading() then
		
		self.Weapon:InitiateReload()
		
		return false
		
	end
	
	if self.Reloading then
		return false
	end
	
	return true
	
end

function SWEP:SecondaryAttack()
	
end

function SWEP:Think()

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

function SWEP:Reload()

	if self.Weapon:Clip1() == self.Primary.ClipSize or self.Weapon:IsReloading() then return end
	
	self.Weapon:InitiateReload()
	
	return
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 150, math.random(95,105) )
	
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:AddRecoil( self.Primary.Recoil )
	self.Weapon:TakeAmmo()
	
end	

function SWEP:TakeAmmo()

	self.Weapon:TakePrimaryAmmo( 1 )

end

function SWEP:ShootEffects()
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				

end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() != 0 then
		scale = aimcone * 1.50
	elseif self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 1.25
		if self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
			scale = aimcone
		end
	elseif self.Owner:KeyDown( IN_DUCK ) or ( self.Owner:KeyDown( IN_WALK ) and self.Owner:GetVelocity():Length() != 0 ) then
		scale = math.Clamp( aimcone * 0.75, 0, 10 )
	end
	
	scale = math.Clamp( scale + self.Weapon:GetRecoil(), 0, 100 )
	
	for i=1,numbullets do
	
		local ang = self.Owner:GetAimVector():Angle()
		ang.p = ang.p + math.Rand( -scale, scale )
	
		local bullet = {}
		bullet.Num 		= 1
		bullet.Src 		= self.Owner:GetShootPos()
		bullet.Dir 		= ang:Forward()
		bullet.Spread 	= Vector( 0, 0, 0 )		
		bullet.Tracer	= 1
		bullet.Force	= 20							
		bullet.Damage	= damage
		bullet.AmmoType = "Pistol"
		bullet.TracerName 	= "bullet_tracer" 
		bullet.Callback = function ( attacker, tr, dmginfo )
			self.Weapon:BulletCallback( attacker, tr, dmginfo, 0 )
		end

		self.Owner:FireBullets( bullet )
	
	end
	
	self.Weapon:ShootEffects()
	
end

function SWEP:BulletCallback( attacker, tr, dmginfo, bounce )

	if not ValidEntity( self.Weapon ) then return end
	if tr.HitSky or tr.MatType == MAT_FLESH or bounce > 3 then return end
	
	local chance = math.random(1,2)
	local effect = "hit_metal"
	
	if tr.MatType == MAT_TILE or tr.MatType == MAT_SAND or tr.MatType == MAT_DIRT or tr.MatType == MAT_CONCRETE then
		chance = math.random(1,3)
		effect = "hit_smoke"
	elseif tr.MatType == MAT_WOOD or tr.MatType == MAT_PLASTIC then
		chance = math.random(1,5)
		effect = "hit_grass"
	elseif tr.MatType == MAT_GRASS or tr.MatType == MAT_FOLIAGE then
		chance = math.random(1,10)
		effect = "hit_grass"
	elseif tr.MatType == MAT_GLASS then
		chance = math.random(1,4)
		effect = "hit_glass"
	end
	
	if tr.HitNormal:Dot( tr.Normal ) < -0.3 or chance != 1 then return end
	
	local ed = EffectData()
	ed:SetOrigin( tr.HitPos )
	ed:SetNormal( tr.HitNormal )
	util.Effect( effect, ed )
	
	// Bounce vector
	local dot = tr.HitNormal:Dot( tr.Normal * -1 )
	local dir = ( 2 * tr.HitNormal * dot ) + tr.Normal
	
	local bullet = {}
	bullet.Num 		= 1
	bullet.Src 		= tr.HitPos
	bullet.Dir 		= dir:Normalize()
	bullet.Spread 	= Vector(0,0,0)		
	bullet.Tracer	= 1
	bullet.Force	= 20							
	bullet.Damage	= dmginfo:GetDamage() * 0.50
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "ricochet_tracer" 
	bullet.Callback = function ( attacker, tr, dmginfo )
		self.Weapon:BulletCallback( attacker, tr, dmginfo, bounce + 1 )
	end
	
	timer.Simple( 0.05, function( attacker, bullet ) if not ValidEntity( attacker ) then return end attacker:FireBullets( bullet ) end, attacker, bullet )
	
	if SERVER then
	
		WorldSound( table.Random( GAMEMODE.Ricochet ), tr.HitPos, 100, math.random(90,120) )
	
	end
	
end

function SWEP:GetTracerOrigin()

	return self.Owner:GetShootPos()

end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )

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
	
	scale = ( scale + ( self.Weapon:GetRecoil() * 0.75 ) ) 

	local dist = math.abs( self.CrosshairScale - scale )
	self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05 )

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

function SWEP:DrawCorner( x1, y1, x2, y2, x3, y3 )

	surface.DrawLine( x1, y1, x2, y2 )
	surface.DrawLine( x2, y2, x3, y3 )
	
end

function SWEP:AddRecoil( t )
	self:SetNetworkedFloat( "Recoil", math.Clamp(self:GetRecoil() + t, 0, self.Primary.Cone * 50)  )
end

function SWEP:TakeRecoil( t )
	self:SetNetworkedFloat( "Recoil", math.Clamp(self:GetRecoil() - t, 0, 100) )
end

function SWEP:GetRecoil()
return self:GetNetworkedFloat( "Recoil", 0 ) end

