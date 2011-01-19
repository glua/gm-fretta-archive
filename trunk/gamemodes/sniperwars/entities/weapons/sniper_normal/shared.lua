if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Sniper Rifle"
	SWEP.IconLetter = "r"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "sniper_normal", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "sniper_base"

SWEP.ViewModel	= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"

SWEP.SprintPos = Vector(-2.4134, -2.7816, 0.4499)
SWEP.SprintAng = Vector(-4.2748, -48.8937, -0.0962)

SWEP.ScopePos = Vector(5.3144, -5.1664, 1.6497)
SWEP.ScopeAng = Vector(-0.0817, -3.7401, 0.351)

SWEP.ZoomModes = { 0, 35, 5 }
SWEP.ZoomSpeeds = { 0.25, 0.30, 0.30 }

SWEP.Primary.Sound			= Sound("npc/sniper/echo1.wav")
SWEP.Primary.Recoil			= 3.8
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.Delay			= 1.250

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 1, "line_tracer" )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if SERVER then
	
		self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
		
		if self.Weapon:GetZoomMode() != 1 then
			self.Weapon:SetZoomMode(1)
			self.Weapon:SetNWBool("ReverseAnim",true)
			self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
			self.Owner:DrawViewModel( true )
		end	
		
	end

end


