if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "SMG"
	SWEP.IconLetter = "/"
	SWEP.Slot = 0
	SWEP.Slotpos = 1
	
	killicon.AddFont( "kh_smg", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"

SWEP.HoldType			= "smg"

SWEP.ViewModel	= "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Firemodes = { "Automatic Fire", "Magazine Discharge" }

SWEP.SprintPos = Vector( -2.5363, -10.2105, -4.0824 )
SWEP.SprintAng = Vector( 31.4104, 1.2127, -0.8824 )

SWEP.Primary.Sound			= Sound( "Weapon_Alyx_Gun.NPC_Single" )
SWEP.Primary.Reload         = Sound( "weapons/smg1/smg1_reload.wav" )
SWEP.Primary.ModeChange		= Sound( "weapons/smg1/switch_single.wav" )
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.085
SWEP.Primary.Recoil         = 3.5

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true

SWEP.Secondary.Sound        = Sound( "Weapon_Alyx_Gun.NPC_Single" )
SWEP.Secondary.Reload       = Sound( "weapons/smg1/smg1_reload.wav" )
SWEP.Secondary.ModeChange	= Sound( "weapons/smg1/switch_burst.wav" )
SWEP.Secondary.Damage		= 6
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.070
SWEP.Secondary.Delay        = 0.050

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self.Weapon:GetFiremode() == 1 then

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,100) )
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, ACT_VM_PRIMARYATTACK )
		self.Weapon:TakePrimaryAmmo( 1 )
		self.Weapon:Recoil()
		
	elseif not self.Discharge then
	
		self.Discharge = 0
	
	end
	
end

function SWEP:Deploy()

	self.Discharge = nil

	if SERVER then
		self.Weapon:SetFiremode( 1 )
		self.Weapon:SetViewModelPosition()
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
	
end  

function SWEP:Think()

	if self.Owner:KeyDown( IN_SPEED ) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	if self.Discharge and self.Discharge < CurTime() then
	
		if self.Owner:KeyDown( IN_SPEED ) then
			self.Weapon:SetClip1( 0 )
			self.Weapon:ProperReload()
			self.Discharge = nil
			return
		end
	
		if self.Weapon:Clip1() < 1 then
			self.Weapon:ProperReload()
			self.Discharge = nil
			return
		end
	
		self.Discharge = CurTime() + self.Secondary.Delay 

		self.Weapon:EmitSound( self.Secondary.Sound, 100, math.random(105,115) )
		self.Weapon:ShootBullets( self.Secondary.Damage, self.Secondary.NumShots, self.Secondary.Cone, ACT_VM_RECOIL3 )
		self.Weapon:TakePrimaryAmmo( 2 )
		self.Weapon:Recoil()
	
		return
		
	end
end

function SWEP:ShootBullets( damage, numbullets, aimcone, act )

	self.ReloadPlay = false

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() != 0 then
		scale = aimcone * 2.5
	elseif self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 2.0
		if self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
			scale = math.Clamp( aimcone * 1.5, 0, 10 )
		end
	elseif self.Owner:KeyDown( IN_DUCK ) or ( self.Owner:KeyDown( IN_WALK ) and self.Owner:GetVelocity():Length() != 0 ) then
		scale = math.Clamp( aimcone / 1.25, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= damage * 2							
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		
	end
	
	self.Owner:FireBullets( bullet )
	
	self.Weapon:SendWeaponAnim( act ) 						// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

function SWEP:Reload()

	self.Weapon:ProperReload()
	
end

function SWEP:ProperReload()

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
	if not self.ReloadPlay then
		self.Discharge = nil
		self.ReloadPlay = true
		self.Weapon:EmitSound( self.Primary.Reload )
	end
	
end
