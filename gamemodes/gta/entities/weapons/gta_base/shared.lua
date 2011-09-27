if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "BASE SWEP"
	SWEP.IconLetter = "c"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModel	= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"

SWEP.HoldType = "ar2"

SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Deploy         = Sound("weapons/clipempty_rifle.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local IRONSIGHT_TIME = 0.3

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Owner:GetNWBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
	end
	
	if ( bIron ) then 
		self.SwayScale 	= 0.25
		self.BobScale 	= 0.10
	elseif self.Owner:KeyDown( IN_SPEED ) then
		self.SwayScale 	= 1.50
		self.BobScale 	= 1.50
	else
		self.SwayScale 	= 1.00
		self.BobScale 	= 1.00
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if not bIron then 
			Mul = 1 - Mul 
		end
		
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function SWEP:ToggleIronsights( b )

	if self.Owner:GetNWBool( "Ironsights", false ) == b then return end

	self.Owner:SetNWBool( "Ironsights", b )
	
	if not b then
		self.Owner:SetFOV( 0, 0.3 )
	else
		self.Owner:SetFOV( self.IronsightsFOV, 0.3 )
	end

end

function SWEP:Initialize()

	self.Weapon:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Deploy()

	if SERVER then
		self.Weapon:ToggleIronsights( false )
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:Think()	

end

function SWEP:Reload()
	
	if SERVER then
		self.Weapon:ToggleIronsights( false )
	end	

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
end

function SWEP:CanPrimaryAttack()

	if self.Weapon:Clip1() <= 0 then
	
		self.Weapon:ToggleIronsights( false )
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if IsFirstTimePredicted() and ValidEntity( self.Owner ) then
		
		if SERVER then
			
			local scale = 0.50
			if self.Owner:KeyDown(IN_DUCK) then
				scale = 0.25
			elseif self.Owner:KeyDown(IN_SPEED) then
				scale = 0.75
			end
			
			local pang, yang = math.Rand( -1 * scale, 0 ) * self.Primary.Recoil, math.Rand( -1 * ( scale / 3 ), ( scale / 3 ) ) * self.Primary.Recoil
			self.Owner:ViewPunch( Angle( pang, yang, 0) )
			
			self.Weapon:ScareCivilians()
			
			local ed = EffectData()
			ed:SetOrigin( self.Owner:GetShootPos() )
			ed:SetEntity( self.Weapon )
			ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) )
			ed:SetScale( ( self.Primary.ShellType or SHELL_9MM ) )
			util.Effect( "weapon_shell", ed, true, true )
			
		end
		
	end
	
end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	if SERVER then
		self.Weapon:ToggleIronsights( !self.Owner:GetNWBool( "Ironsights", false ) )
	end

end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() != 0 then
		scale = aimcone * 2.5
	elseif self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 2.0
		if self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
			scale = math.Clamp( aimcone * 1.5, 0, 10 )
		end
	elseif self.Owner:KeyDown( IN_DUCK ) or ( self.Owner:KeyDown( IN_WALK ) and self.Owner:GetVelocity():Length() != 0 ) then
		scale = math.Clamp( aimcone / 1.2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= damage * 1.5						
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		self:BulletCallback(  attacker, tr, dmginfo, 0 )
	end
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:BulletCallback( attacker, tr, dmginfo, bounce )

	if( !self or !ValidEntity( self.Weapon ) ) then return end
	
	if tr.Entity:IsValid() and ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() ) and SERVER then
	
		if tr.Entity:IsPlayer() and tr.Entity:Team() == self.Owner:Team() then return end
		
		local ed = EffectData()
		ed:SetOrigin(tr.HitPos)
		ed:SetNormal(tr.HitNormal)
		util.Effect("bodyshot", ed, true, true)
		
	end
		
	self.Weapon:BulletPenetration( attacker, tr, dmginfo, bounce + 1 )
	
end

function SWEP:GetPenetrationDistance( mat_type )

	if ( mat_type == MAT_PLASTIC || mat_type == MAT_WOOD || mat_type == MAT_FLESH || mat_type == MAT_ALIENFLESH || mat_type == MAT_GLASS ) then
		return 64
	end
	
	return 32
	
end

function SWEP:GetPenetrationDamageLoss( mat_type, distance, damage )

	if ( mat_type == MAT_GLASS || mat_type == MAT_FLESH || mat_type == MAT_ALIENFLESH ) then
		return damage
	elseif ( mat_type == MAT_PLASTIC  || mat_type == MAT_WOOD ) then
		return damage - distance
	elseif( mat_type == MAT_TILE || mat_type == MAT_SAND || mat_type == MAT_DIRT ) then
		return damage - ( distance * 1.2 )
	end
	
	return damage - ( distance * 1.8 )
	
end

function SWEP:BulletPenetration( attacker, tr, dmginfo, bounce )

	if ( !self or !ValidEntity( self.Weapon ) ) then return end
	
	// Don't go through more than 3 times
	if ( bounce > 3 ) then return false end
	
	// Direction (and length) that we are gonna penetrate
	local PeneDir = tr.Normal * self:GetPenetrationDistance( tr.MatType )
		
	local PeneTrace = {}
	   PeneTrace.endpos = tr.HitPos
	   PeneTrace.start = tr.HitPos + PeneDir
	   PeneTrace.mask = MASK_SHOT
	   PeneTrace.filter = { self.Owner }
	   
	local PeneTrace = util.TraceLine( PeneTrace ) 
	
	// Bullet didn't penetrate.
	if ( PeneTrace.StartSolid || PeneTrace.Fraction >= 1.0 || tr.Fraction <= 0.0 ) then return false end
	
	local distance = ( PeneTrace.HitPos - tr.HitPos ):Length()
	local new_damage = self:GetPenetrationDamageLoss( tr.MatType, distance, dmginfo:GetDamage() )
	
	if new_damage > 0 then
	
		local bullet = 
		{	
			Num 		= 1,
			Src 		= PeneTrace.HitPos,
			Dir 		= tr.Normal,	
			Spread 		= Vector( 0, 0, 0 ),
			Tracer		= 0,
			Force		= 5,
			Damage		= new_damage,
			AmmoType 	= "Pistol",
		}
		
		bullet.Callback = function( a, b, c ) if ( self.BulletCallback ) then return self:BulletCallback( a, b, c, bounce + 1 ) end end
		
		local effectdata = EffectData()
		effectdata:SetOrigin( PeneTrace.HitPos );
		effectdata:SetNormal( PeneTrace.Normal );
		util.Effect( "Impact", effectdata ) 
		
		timer.Simple( 0.05, attacker.FireBullets, attacker, bullet, true )
		
	end
end

function SWEP:ScareCivilians()

	for k,v in pairs( ents.FindByClass( "npc*" ) ) do
		if v:GetPos():Distance( self.Owner:GetPos() ) < 1000 then
			v:Panic()
		end
	end

end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )
	SWEP.CrossScale = CreateClientConVar( "crosshair_scale", 1, true, false )

end

SWEP.CrosshairScale = 1

function SWEP:DrawHUD()

	if self.Owner:GetNWBool( "Ironsights", false ) then return end

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	local scale = self.Primary.Cone
	
	if self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() != 0 then
		scale = self.Primary.Cone * 2.5
	elseif self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = self.Primary.Cone * 2.0
		if self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
			scale = math.Clamp( self.Primary.Cone * 1.5, 0, 10 )
		end
	elseif self.Owner:KeyDown( IN_DUCK ) or ( self.Owner:KeyDown( IN_WALK ) and self.Owner:GetVelocity():Length() != 0 ) then
		scale = math.Clamp( self.Primary.Cone / 1.2, 0, 10 )
	end
	
	//scale = math.Clamp( ( 10 + ( scale * ( 260 * (ScrH()/720) ) ) ) * self.CrossScale:GetFloat(), 0, (ScrH()/2) - 100 )
	//self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 )
	
	// CAN'T GET THIS TO WORK NICELY
	
	scale = scale * scalebywidth * self.CrossScale:GetFloat()
	
	local dist = math.abs( self.CrosshairScale - scale )
	self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05 )
	
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)
	
end
