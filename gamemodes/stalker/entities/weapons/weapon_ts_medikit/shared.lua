if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "slam"

end

if ( CLIENT ) then
	
	SWEP.ViewModelFlip = false
	SWEP.PrintName = "Medikit"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "F"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	RegisterName( "weapon_ts_medikit", SWEP.PrintName )

end

SWEP.Base				= "ts_base"

SWEP.ViewModel		= "models/weapons/v_c4.mdl"
SWEP.WorldModel		= "models/weapons/w_c4.mdl"

SWEP.Primary.Deny           = Sound( "HL1/fvox/buzz.wav" )
SWEP.Primary.Heal           = Sound( "items/smallmedkit1.wav" )
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay          = 0.500

function SWEP:PrimaryAttack()

	if self.Owner:Health() > 75 then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:EmitSound( self.Primary.Deny )
		return
	
	end
	
	self.Weapon:EmitSound( self.Primary.Heal )
	
	if CLIENT then return end
	
	self.Owner:SetHealth( self.Owner:Health() + 25 )
	self.Owner:StripWeapon( "weapon_ts_medikit" )
	
end

function SWEP:Think()	

end

function SWEP:Reload()
	
end

function SWEP:OnRemove()

end
