if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "shotgun"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Grenade Launcher"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "O"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_m79", "HL2MPTypeDeath", "7", Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_m79", "HL2MPTypeDeath", "7", Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_m79", SWEP.PrintName )
	
end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Primary.Sound			= Sound( "weapons/mortar/mortar_fire1.wav" )
SWEP.Primary.Deploy         = Sound( "weapons/p90/p90_clipin.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/mac10/mac10_clipout.wav" ), 
								Sound( "weapons/p90/p90_cliprelease.wav" ), 
								Sound( "weapons/awp/awp_clipin.wav" ) }
SWEP.Primary.ReloadTime     = 2.90 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.25 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.250 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.250

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end
	
	if SERVER then
	
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self.Weapon:LaunchNade()
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:AddRecoil( self.Primary.Recoil )
	self.Weapon:TakeAmmo()
	self.Weapon:ShootEffects()
	
end	

function SWEP:LaunchNade()

	local random = ( self.Owner:GetAimVector() + VectorRand() * 0.01 ):Normalize()
	random.x = 0

	local nade = ents.Create( "sent_m79" )
	nade:SetPos( self.Owner:GetShootPos() )
	nade:SetAngles( ( random ):Angle() )
	nade:SetOwner( self.Owner )
	nade:Spawn()

end