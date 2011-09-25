if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "smg"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Immolator"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "C"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_flamer", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_flame", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_flame_immobile", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_irifle.mdl"

SWEP.Primary.Sound			= Sound( "doors/doormove3.wav" )
SWEP.Primary.Deploy         = Sound( "weapons/slam/mine_mode.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/smg1/smg1_reload.wav" ), 
								Sound( "doors/doormove2.wav" ), 
								Sound( "weapons/slam/mine_mode.wav" ) }
SWEP.Primary.ReloadTime     = 5.20 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.10 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.010 // how fast does recoil fade away?
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.250 //default spread without factoring in the firing
SWEP.Primary.Delay			= 1.300

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end
	
	if SERVER then
	
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(120,130) )
		self.Weapon:ShootFire()
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:AddRecoil( self.Primary.Recoil )
	self.Weapon:TakeAmmo()
	self.Weapon:ShootEffects()
	
end	

function SWEP:ShootFire()

	local random = ( self.Owner:GetAimVector() + VectorRand() * 0.1 ):Normalize()
	random.x = 0

	local flame = ents.Create( "sent_plasmabomb" )
	flame:SetPos( self.Owner:GetShootPos() )
	flame:SetAngles( ( random ):Angle() )
	flame:SetOwner( self.Owner )
	flame:Spawn()

end