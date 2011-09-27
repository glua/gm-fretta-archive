if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "M3 Super 90"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "k"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_m3", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "ts_base"
	
SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_Shotgun.Double" )
SWEP.Primary.Pump           = Sound( "Weapon_M3.Pump" )
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 15
SWEP.Primary.Recoil			= 12.5
SWEP.Primary.Cone			= 0.095
SWEP.Primary.Delay			= 0.550

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.AmmoType		= "Buckshot"

SWEP.Primary.ShellType      = SHELL_SHOTGUN

function SWEP:Deploy()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SetVar( "PumpTime", 0 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

	if SERVER then
		self.Owner:SetCurrentAmmo( self.Primary.AmmoType )
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:CanPrimaryAttack()

	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then
		
		self.Weapon:EmitSound( self.Primary.Empty, 100, math.random(90,110) )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return false
		
	end

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		self.Weapon:SetNWBool( "Reloading", false )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
		
		return false
	
	end

	if self.Weapon:Clip1() <= 0 then
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:SetVar( "PumpTime", CurTime() + 0.5 )
	
	if IsFirstTimePredicted() then
	
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		if SERVER then
		
			local scale = 0.50
			
			if self.Owner:KeyDown( IN_DUCK ) then
			
				scale = 0.25
				
			elseif ( self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) ) then
			
				scale = 0.60
				
			end
			
			local pang, yang = math.Rand( -1 * scale, -1 ) * self.Primary.Recoil, math.Rand( -1 * ( scale / 3 ), ( scale / 3 ) ) * self.Primary.Recoil
			self.Owner:ViewPunch( Angle( pang, yang, 0) )
			self.Owner:AddCustomAmmo( self.Primary.AmmoType, -1 )
			
		end
		
	end
	
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	
end

function SWEP:Reload()

	if self.Weapon:GetNWBool( "Reloading", false ) then return end
	
	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then return end
	
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
	end
	
	return true
	
end

function SWEP:PumpIt()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
	self.Weapon:EmitSound( self.Primary.Pump )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if SERVER then
	
		local ed = EffectData()
		ed:SetOrigin( self.Owner:GetShootPos() )
		ed:SetEntity( self.Weapon )
		ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) )
		ed:SetScale( ( self.Primary.ShellType or SHELL_9MM ) )
		util.Effect( "weapon_shell", ed, true, true )
	
	end
	
end

function SWEP:Think()
	
	if self.Weapon:GetVar( "PumpTime", 0 ) != 0 and self.Weapon:GetVar( "PumpTime", 0 ) < CurTime() then
	
		self.Weapon:SetVar( "PumpTime", 0 )
		self.Weapon:PumpIt()
		
	end

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
			self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.6 )
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
		scale = aimcone * 1.2
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		scale = math.Clamp( aimcone / 1.2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 0
	bullet.Force	= math.Round( damage * 2 )							
	bullet.Damage	= math.Round( damage )
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		self:BulletCallback(  attacker, tr, dmginfo, 0 )
	end
	
	self.Owner:FireBullets( bullet )
	
end
