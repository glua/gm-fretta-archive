if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "ar2"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "AWP"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "r"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_awp", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_awp", SWEP.PrintName )

end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_AWP.Single" )
SWEP.Primary.Deploy         = Sound( "weapons/awp/awp_bolt.wav" )
SWEP.Primary.ReloadSounds   = { Sound( "weapons/g3sg1/g3sg1_slide.wav" ), 
								Sound( "weapons/scout/scout_clipout.wav" ), 
								Sound( "weapons/sg550/sg550_clipin.wav" ), 
								Sound( "weapons/scout/scout_bolt.wav" ) }
SWEP.Primary.Scope          = Sound( "weapons/zoom.wav" )
SWEP.Primary.ReloadTime     = 4.20 //since there is no view model we do the reload manually       
SWEP.Primary.Recoil			= 0.85 //how much spread to add each frame we are firing
SWEP.Primary.RecoilFade     = 0.003 // how fast does recoil fade away?
SWEP.Primary.Damage			= 175
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.050 
SWEP.Primary.Delay			= 1.800

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= true

SWEP.ZoomFocus = 850
SWEP.CurrFocus = 450
SWEP.ZoomAdd = 10

function SWEP:OnRemove()

	self.Weapon:SetNWBool( "Zoom", false )

	if SERVER then
	
		self.Owner:SetFocus()
	
	end

end

function SWEP:ResetFocus()

	if SERVER then
	
		self.Owner:SetFocus()
		self.Owner:EmitSound( self.Primary.Scope, 100, 120 )
		
	end
	
	self.Weapon:SetNWBool( "Zoom", false )

end

function SWEP:Holster()

	if self.Weapon:IsReloading() then
	
		self.ReloadEnd = nil
		self.ReloadTimes = nil
	
	end

	self.Weapon:SetNWBool( "Zoom", false )

	if SERVER then
	
		self.Owner:SetFocus()
	
	end

	return true

end

function SWEP:SecondaryAttack()
	
	if self.Owner:OnGround() and ( self.Owner:KeyDown( IN_DUCK ) or self.Owner:GetVelocity():Length() == 0 ) and not self.Weapon:GetNWBool( "Zoom", false ) then
	
		self.ZoomAdd = 5
		self.Weapon:SetNWBool( "Zoom", true )
		self.Weapon:EmitSound( self.Primary.Scope )
		return
	
	elseif self.Weapon:GetNWBool( "Zoom", false ) then

		self.Weapon:ResetFocus()
		
	end
	
end

function SWEP:Think()

	if SERVER then
	
		self.Weapon:TakeRecoil( self.Primary.RecoilFade )
		
		if self.Weapon:GetNWBool( "Zoom", false ) then
		
			self.ZoomAdd = self.ZoomAdd * 1.2
			self.CurrFocus = math.Approach( self.CurrFocus, self.ZoomFocus, self.ZoomAdd )
			self.Owner:SetFocus( self.CurrFocus )
			
			if self.Weapon:IsReloading() or !self.Owner:OnGround() or self.Owner:GetVelocity():Length() != 0 then
				
				self.Weapon:ResetFocus()
				
			end
		
		end
		
	end
		
	if not self.Weapon:IsReloading() then return end
		
	for k,v in pairs( self.ReloadTimes ) do
		
		if v != -1 and v < CurTime() and SERVER then
			
			self.ReloadTimes[k] = -1
				
			self.Owner:EmitSound( self.Primary.ReloadSounds[k], 100, math.random(90,110) )
			
		end
		
	end
		
	if self.ReloadEnd and self.ReloadEnd < CurTime() then
		
		self.Weapon:EndReload()
			
	end
		
end