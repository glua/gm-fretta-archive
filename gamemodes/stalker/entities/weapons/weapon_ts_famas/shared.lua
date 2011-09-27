if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.ViewModelFlip = false
	SWEP.PrintName = "FAMAS G2"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "t"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_famas", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ts_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel		= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_famas.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_galil.Single" )
SWEP.Primary.Damage			= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 4.0
SWEP.Primary.Cone			= 0.038
SWEP.Primary.Delay			= 0.480
SWEP.Primary.Burst			= 0.080

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "Burst"

SWEP.Primary.ShellType      = SHELL_762NATO

SWEP.Bursts = 3
SWEP.NextBurst = -1

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end
	
	self.Bursts = 1
	self.NextBurst = CurTime() + self.Primary.Burst
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if IsFirstTimePredicted() then
	
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		if SERVER then
		
			local scale = 0.50
			if self.Owner:KeyDown(IN_DUCK) then
				scale = 0.25
			elseif self.Owner:KeyDown(IN_SPEED) then
				scale = 0.75
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

function SWEP:Reload()
	
	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then return end
	
	if self.NextBurst != -1 then return end

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
end

function SWEP:Think()	

	if self.NextBurst != -1 and self.NextBurst < CurTime() then
	
		self.Weapon:BurstShot()
		
		if self.Bursts != 3 then
			
			self.NextBurst = CurTime() + self.Primary.Burst
			
		else
		
			self.NextBurst = -1
		
		end
	
	end

end

function SWEP:BurstShot()

	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then
		
		self.Weapon:EmitSound( self.Primary.Empty, 100, math.random(100,110) )
		
		self.Bursts = self.Bursts + 1
		
		return 
		
	end

	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if IsFirstTimePredicted() then
	
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		if SERVER then
		
			local scale = 0.50
			if self.Owner:KeyDown(IN_DUCK) then
				scale = 0.25
			elseif self.Owner:KeyDown(IN_SPEED) then
				scale = 0.75
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
	
	self.Bursts = self.Bursts + 1

end