if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "UV Flares"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "P"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_flares", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_flare", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "weapon_ts_flares", SWEP.PrintName )

end

SWEP.Base				= "ts_base"
	
SWEP.HoldType = "grenade"

SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"

SWEP.Primary.Toss           = Sound( "WeaponFrag.Throw" )
SWEP.Primary.Delay			= 1.550
SWEP.Primary.ClipSize		= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.AmmoType		= "Flare"

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
		
			self.Weapon:FlareThrow()
		
		end
	
	end

end

function SWEP:FlareThrow()

	self.Owner:EmitSound( self.Primary.Toss )
	
	local ent = ents.Create( "sent_flare" )
	ent:SetPos( self.Owner:GetShootPos() + self.Owner:GetRight() * 5 )
	ent:SetAngles( self.Owner:GetAimVector():Angle() )
	ent:SetOwner( self.Owner )
	ent:Spawn()
		
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	if self.Owner:GetCustomAmmo( self.Primary.AmmoType ) < 1 then
	
		self.Owner:StripWeapon( "weapon_ts_flares" )
	
	end

end

function SWEP:Reload()
	
end

function SWEP:OnRemove()

end
