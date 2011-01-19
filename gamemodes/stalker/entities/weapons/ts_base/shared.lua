if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "ar2"
	
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

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Empty          = Sound( "weapons/clipempty_rifle.wav" )
SWEP.Primary.Laser          = Sound( "items/nvg_on.wav" )
SWEP.Primary.LaserOff       = Sound( "items/nvg_off.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.AmmoType		= "Pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:GetViewModelPosition( pos, ang )

	self.SwayScale 	= 1.00
	self.BobScale 	= 1.00

	return pos, ang
	
end

function SWEP:Initialize()

	if SERVER then
	
		self.Weapon:SetWeaponHoldType( self.HoldType )
		
	end
	
end

function SWEP:Deploy()

	if SERVER then
	
		self.Owner:SetCurrentAmmo( self.Primary.AmmoType )
		
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:OnRemove()

	if !self.HasBeenRemoved and SERVER and self.Owner:Health() < 100 then
	
		self.HasBeenRemoved = true

		local ed = EffectData()
		ed:SetOrigin( self.Owner:GetPos() + Vector(0,0,40) )
		ed:SetAngle( self.Weapon:GetAngles() )
		ed:SetScale( ( self.Primary.ShellType or SHELL_9MM ) )
		util.Effect( "weapon_drop", ed, true, true )
		
	end

end

function SWEP:Think()	

end

function SWEP:Reload()
	
	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then return end

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
end

function SWEP:CanPrimaryAttack()

	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then
		
		self.Weapon:EmitSound( self.Primary.Empty, 100, math.random(100,110) )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return false
		
	end

	if self.Weapon:Clip1() <= 0 then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if IsFirstTimePredicted() then
	
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		if SERVER then
		
			local scale = 0.50
			
			if self.Owner:KeyDown( IN_DUCK ) then
			
				scale = 0.25
				
			elseif ( self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) ) then
			
				scale = 0.60
				
			end
			
			local pang, yang = math.Rand( -1 * scale, 0 ) * self.Primary.Recoil, math.Rand( -1 * ( scale / 3 ), ( scale / 3 ) ) * self.Primary.Recoil
			self.Owner:ViewPunch( Angle( pang, yang, 0) )
			self.Owner:AddCustomAmmo( self.Primary.AmmoType, -1 )
			
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

end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		scale = math.Clamp( aimcone / 2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 0
	bullet.Force	= math.Round( damage * 1.5 )							
	bullet.Damage	= math.Round( damage )
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		self:BulletCallback(  attacker, tr, dmginfo, 0 )
	end
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:BulletCallback( attacker, tr, dmginfo, bounce )

	if( !self or !ValidEntity( self.Weapon ) ) then return end
	
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

function SWEP:DrawHUD()
	
end
