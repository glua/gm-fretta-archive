if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "rpg"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "RPG"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "3"
	
	SWEP.IconFont = "HL2SelectIcons"
	
	killicon.AddFont( "jj_rpg", "HL2MPTypeDeath", "3", Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_rpg", "HL2MPTypeDeath", "3", Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_rpg", SWEP.PrintName )
	
end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Sound			= Sound( "weapons/stinger_fire1.wav" )
SWEP.Primary.Deploy         = Sound( "weapons/smg1/switch_single.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/smg1/switch_burst.wav" ), 
								Sound( "weapons/pinpull.wav" ), 
								Sound( "weapons/ump45/ump45_clipin.wav" ), 
								Sound( "weapons/357/357_reload4.wav" ) }
SWEP.Primary.ReloadTime     = 6.50 //since there is no view model we do the reload manually  
SWEP.Primary.Recoil			= 0.65 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.300 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() or !self.Owner:OnGround() or self.Owner:GetVelocity():Length() != 0 then return end
	
	if not self.Owner:KeyDown( IN_DUCK ) then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Owner:EmitSound( self.Primary.Deploy, 100, 120 )
		return
	
	end
	
	if SERVER then
	
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self.Weapon:LaunchRPG()
		
	end
	
	self.Weapon:AddRecoil( self.Primary.Recoil )
	self.Weapon:TakeAmmo()
	self.Weapon:ShootEffects()
	
end	

function SWEP:LaunchRPG()

	local random = ( self.Owner:GetAimVector() + VectorRand() * 0.02 ):Normalize()
	random.x = 0

	local rpg = ents.Create( "sent_rpg" )
	rpg:SetPos( self.Owner:GetShootPos() )
	rpg:SetAngles( ( random ):Angle() )
	rpg:SetOwner( self.Owner )
	rpg:Spawn()

end