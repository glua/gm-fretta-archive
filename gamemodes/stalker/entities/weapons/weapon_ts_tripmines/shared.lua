if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "slam"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Tripmine Alarms"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "Q"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	RegisterName( "weapon_ts_tripmines", SWEP.PrintName )

end

SWEP.Base				= "ts_base"

SWEP.ViewModel			= "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Primary.Toss           = Sound( "WeaponFrag.Throw" )
SWEP.Primary.Delay			= 1.550
SWEP.Primary.ClipSize		= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.AmmoType		= "Tripmine"

SWEP.ThrowTime = -1

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	self.ThrowTime = CurTime() + 0.35
	
	if CLIENT then return end
	
	self.Owner:AddCustomAmmo( self.Primary.AmmoType, -1 )
	
end

function SWEP:Think()	

	if self.ThrowTime != -1 and self.ThrowTime < CurTime() then
	
		self.ThrowTime = -1
	
		if SERVER then
		
			self.Weapon:TripmineThrow()
		
		end
	
	end

end

function SWEP:TripmineThrow()

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 60
	trace.mask = MASK_NPCWORLDSTATIC
	trace.filter = self.Owner
		
	local tr = util.TraceLine( trace )
	
	local ent = ents.Create( "sent_tripmine" )
	ent:SetPos( trace.endpos )
	ent:Spawn()
		
	if tr.Hit then
		
		ent:StartTripmineMode( tr.HitPos + tr.HitNormal, tr.HitNormal )
		
	else
		
		local phys = ent:GetPhysicsObject()
		
		if ValidEntity( phys ) then
		
			phys:SetVelocity( self.Owner:GetAimVector() * 1000 + self.Owner:GetVelocity() )
			
		end
		
		self.Owner:EmitSound( self.Primary.Toss ) 
			
	end
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	if self.Owner:GetCustomAmmo( self.Primary.AmmoType ) < 1 then
	
		self.Owner:StripWeapon( "weapon_ts_tripmines" )
	
	end

end

function SWEP:Reload()
	
end

function SWEP:OnRemove()

end
