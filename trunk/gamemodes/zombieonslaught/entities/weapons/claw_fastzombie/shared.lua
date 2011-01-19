
if SERVER then

	AddCSLuaFile("shared.lua")
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel = "models/Zed/weapons/v_wretch.mdl"

SWEP.Primary.Voice          = Sound("npc/fast_zombie/leap1.wav")
SWEP.Primary.Sound			= Sound("npc/zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/zombie/claw_strike1.wav")
SWEP.Primary.Jump           = Sound("npc/fast_zombie/fz_scream1.wav")
SWEP.Primary.Damage			= 30
SWEP.Primary.HitForce       = 500
SWEP.Primary.Delay			= 1.10
SWEP.Primary.FreezeTime     = 0.30
SWEP.Primary.Automatic		= false

SWEP.Secondary.Automatic = true

function SWEP:Deploy()

	if SERVER then
		self.Owner:DrawWorldModel( false )
	end
	
	self.Weapon:SetVar( "NextHit", 0 )
	self.Weapon:SetVar( "NextJump", 0 )
	
	return true
	
end  

function SWEP:SecondaryAttack()

	if not self.Owner.m_bClimb and SERVER then
		self.Owner.m_bClimb = true
		self.Owner:Notice( "Press the sprint key to jump", 8, 0, 100, 255 )
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.25 )
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	if tr.HitPos:Distance( self.Owner:GetShootPos() ) < 100 then
	
		self.Owner:SetAnimation( PLAYER_SUPERJUMP )
	
		if SERVER then
		
			self.Owner:EmitSound( table.Random( GAMEMODE.Climbing ), 100, math.random(90,110) )
			self.Owner:SetVelocity( Vector( 0, 0, 250 ) )
			
		end
	end
end

function SWEP:Think()	

	if self.Weapon:GetVar( "NextHit", 0 ) > 0 and self.Weapon:GetVar( "NextHit", 0 ) < CurTime() then
	
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
		self.Weapon:SetVar( "NextHit", 0 )
		self.Weapon:MeleeTrace( self.Primary.Damage )
		
		if SERVER then
			self.Owner:SetMoveType( MOVETYPE_WALK )
		end
	
	end
	
	if self.Owner:KeyDown( IN_SPEED ) and SERVER then
	
		if self.Weapon:GetVar( "NextJump", 0 ) < CurTime() then
		
			if not self.Owner.m_bJump then
				self.Owner.m_bJump = true
				self.Owner:Notice( "Use your secondary attack to climb walls", 8, 0, 100, 255 )
			end
		
			self.Weapon:SetVar( "NextJump", CurTime() + 3 )
			
			if self.Owner:OnGround() then
			
				local vel = self.Owner:GetForward() * 500
				vel.z = math.Clamp( vel.z, 100, 500 )
			
				self.Owner:SetVelocity( vel + Vector(0,0,250) )
				self.Owner:EmitSound( self.Primary.Jump, 100, math.random(90,100) )
				
			end
		end
	end
end