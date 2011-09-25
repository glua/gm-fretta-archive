if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.HoldType			= "pistol"

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Pistola"
	SWEP.IconLetter = "-"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "kh_pistola", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Firemodes = { "Single Shot", "Slug Rounds" }

SWEP.SprintPos = Vector( 4.2936, -12.6991, -17.0856 )
SWEP.SprintAng = Vector( 58.7527, -5.4729, 1.8818 )

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Reload         = Sound( "weapons/pistol/pistol_reload1.wav" )
SWEP.Primary.ModeChange		= Sound( "weapons/ar2/ar2_empty.wav" )
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.130
SWEP.Primary.Recoil         = 2.5

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound        = Sound( "Weapon_357.Single" )
SWEP.Secondary.ModeChange	= Sound( "weapons/pistol/pistol_empty.wav" )
SWEP.Secondary.Damage		= 12
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.030
SWEP.Secondary.Delay        = 0.420

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self.Weapon:GetFiremode() == 1 then

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		
	else

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )

		self.Weapon:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
		self.Weapon:ShootSlugBullet( self.Secondary.Damage, self.Secondary.NumShots, self.Secondary.Cone )
		
	
	end
	
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:Recoil( )
	
end

function SWEP:ShootSlugBullet( damage, numbullets, aimcone )

	self.ReloadPlay = false

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
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		if ValidEntity( tr.Entity ) then
			if tr.Entity:IsPlayer() and SERVER then
				tr.Entity:SetVelocity( tr.Entity:GetVelocity() + Vector(0,0,250) + attacker:GetAimVector() * 500 )
			end
		end
	end
	
	self.Owner:FireBullets( bullet )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

function SWEP:OnModeChange( mode )

	self.Weapon:SetClip1( 0 )
	
	self.Weapon:EmitSound( self.Primary.Reload )
	self.Weapon:DefaultReload( ACT_VM_RELOAD )

end 