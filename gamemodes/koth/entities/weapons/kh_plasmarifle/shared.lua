if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	
	SWEP.PrintName = "Plasma Rifle"
	SWEP.IconLetter = "2"
	SWEP.Slot = 0
	SWEP.Slotpos = 3
	
	killicon.AddFont( "kh_plasmarifle", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_plasma", "HL2MPTypeDeath", "8", Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"

SWEP.HoldType			= "ar2"
	
SWEP.ViewModel	= "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"

SWEP.Firemodes = { "Plasma Bomb", "Energy Beam" }

SWEP.SprintPos = Vector( 6.4052, -2.85, 3.048 )
SWEP.SprintAng = Vector( -19.1447, 37.0746, -6.773 )

SWEP.Primary.Sound			= Sound( "weapons/airboat/airboat_gun_energy1.wav" )
SWEP.Primary.Reload         = Sound( "weapons/ar2/ar2_reload_rotate.wav" )
SWEP.Primary.ModeChange		= Sound( "weapons/ar2/ar2_empty.wav" )
SWEP.Primary.Damage			= 90
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 2.100
SWEP.Primary.Recoil         = 5.5

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound		= Sound( "weapons/physcannon/energy_sing_flyby1.wav" )
SWEP.Secondary.Reload       = Sound( "weapons/physcannon/physcannon_charge.wav" )
SWEP.Secondary.ModeChange	= Sound( "weapons/ar2/ar2_reload_rotate.wav" )
SWEP.Secondary.Damage		= 80
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.035
SWEP.Secondary.Delay        = 2.750

SWEP.Load = nil

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Load = CurTime() + .3
	
	if self.Weapon:GetFiremode() == 1 then

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		if SERVER then
			self.Weapon:FirePalsma() 
		end
		
	else

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self.Weapon:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
		self.Weapon:ShootBullets( self.Secondary.Damage, self.Secondary.NumShots, self.Secondary.Cone )
	
	end
	
	self.Weapon:Recoil()
	self.Weapon:TakePrimaryAmmo( 1 )
	
end

function SWEP:Think()	

	if self.Owner:KeyDown( IN_SPEED ) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	if not self.Load then return end
	
	if self.Load < CurTime() then
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		self.Load = nil
	end

end

local function RicochetCallback( damage, attacker, tr, dmginfo )
	
	local hitplayer
	
	if ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() then
		hitplayer = tr.Entity
	end
	
	if not tr.HitSky and not hitplayer and damage >= 20 then
		 
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "laser_bounce", ed, true )
			
		WorldSound( "weapons/physcannon/energy_bounce2.wav", tr.HitPos, 100, math.random(110,130) )
			
	elseif tr.HitSky or damage < 20 or hitplayer then
		
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "laser_disintegrate", ed, true )
		
		WorldSound( "weapons/physcannon/energy_disintegrate4.wav", tr.HitPos, 100, math.random(110,130) )
		
		return
		
	end
	
	if CLIENT then return end
	
	local Dot = tr.HitNormal:Dot( tr.Normal * -1 )
	
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= ( 2 * tr.HitNormal * Dot ) + tr.Normal, 
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "laser_tracer",
		Force		= damage ^ 2,
		Damage		= damage,
		AmmoType 	= "Pistol" 
	}
	
	// Continue bouncing on the server only
	if (SERVER) then
		bullet.Callback    = function( a, b, c ) RicochetCallback( damage - 5, a, b, c ) end
	end
	
	timer.Simple( 0.08, attacker.FireBullets, attacker, bullet )

	return false 
	
end

function SWEP:ShootBullets( damage, numbullets, aimcone )

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
	bullet.Tracer	= 1	
	bullet.Force	= damage ^ 2						
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "laser_tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		RicochetCallback( self.Secondary.Damage, attacker, tr, dmginfo )
	end
	
	self.Owner:FireBullets( bullet )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

function SWEP:FirePalsma()
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local ball = ents.Create( "sent_plasma" )
	ball:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 25 )
	ball:SetAngles( self.Owner:GetAngles() )
	ball:SetOwner( self.Owner )
	ball:Spawn()
	
end

function SWEP:Reload()

end
