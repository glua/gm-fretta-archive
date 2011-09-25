
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.HoldType			= "grenade"

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	
	SWEP.PrintName = "Bouncing Betsies"
	SWEP.Slot = 0
	SWEP.Slotpos = 5
	SWEP.IconLetter = "4"
	
	killicon.AddFont( "kh_betsy", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_betsy", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_pinballnade", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"

SWEP.ViewModel	= "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"

SWEP.Firemodes = { "Bouncing Betsy", "Pinball Grenade" }

SWEP.SprintPos = Vector( -9.5707, -0.5182, -0.2598 )
SWEP.SprintAng = Vector( 2.0666, -15.7335, -20.6764 )

SWEP.Primary.Sound			= Sound( "weapons/iceaxe/iceaxe_swing1.wav" )
SWEP.Primary.Reload         = Sound( "weapons/slam/mine_mode.wav" )
SWEP.Primary.ModeChange		= Sound( "weapons/357/357_reload1.wav" )
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 2.800

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= false

SWEP.Secondary.ModeChange	= Sound( "npc/turret_floor/click1.wav" )
SWEP.Secondary.Damage		= 1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.025
SWEP.Secondary.Delay        = 2.900

SWEP.Load = nil
SWEP.ModeLoad = nil

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self.Weapon:GetFiremode() == 1 then

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(80,100) )
		self.Weapon:TakePrimaryAmmo( 1 )
		
		self.Load = CurTime() + self.Primary.Delay
		
		if SERVER then
			self.Weapon:TossBetsy( "sent_betsy" )
		end
		
	else

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )

		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(80,100) )
		self.Weapon:TakePrimaryAmmo( 1 )
		
		self.Load = CurTime() + self.Secondary.Delay
		
		if SERVER then
			self.Weapon:TossBetsy( "sent_pinballnade" )
		end
		
	end
end

function SWEP:Think()	

	if self.Owner:KeyDown( IN_SPEED ) then
		self.LastRunFrame = CurTime() + 0.3
	end

	if self.Load and self.Load < CurTime() then
	
		if self.Weapon:Clip1() == 0 then
		
			self.Weapon:SetClip1( 1 )
			self.Weapon:EmitSound( self.Primary.Reload, 100, 110 )
		
			self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
			
		end
		
		self.Load = nil
		
	elseif self.ModeLoad and self.ModeLoad < CurTime() then
	
		self.Weapon:SetClip1( 1 )
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		
		if self.Weapon:GetFiremode() == 1 then
			self.Weapon:EmitSound( self.Primary.ModeChange )
		else
			self.Weapon:EmitSound( self.Secondary.ModeChange )
		end 
		
		self.ModeLoad = nil
		
	end
end

function SWEP:TossBetsy( name )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	
	local bets = ents.Create( name )
	bets:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 25 )
	bets:SetAngles( self.Owner:GetAngles() )
	bets:SetOwner( self.Owner )
	bets:Spawn()
	
end

function SWEP:SecondaryAttack()

	if not self:CanPrimaryAttack() then return end

	self.Weapon:SetNextSecondaryFire( CurTime() + 3 )
	
	if self.Weapon:GetFiremode() == 1 then
		self.Weapon:SetFiremode( 2 )
	else
		self.Weapon:SetFiremode( 1 )
	end
	
	self.Weapon:SetClip1( 0 )
	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	
	self.ModeLoad = CurTime() + 0.5

end

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown( IN_SPEED ) or self.LastRunFrame > CurTime() or self.Weapon:Clip1() <= 0 then
		return false
	end
	
	return true
	
end

function SWEP:Reload()
	
end
