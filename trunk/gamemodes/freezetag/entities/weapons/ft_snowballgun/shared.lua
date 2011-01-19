
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.HoldType			= "rpg"

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	
	SWEP.PrintName = "Snowball Cannon"
	SWEP.IconLetter = "3"
	SWEP.Slot = 0
	SWEP.Slotpos = 2
	
	killicon.AddFont( "sent_snowball", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ft_base"

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Sound			= Sound( "weapons/grenade_launcher1.wav" )
SWEP.Primary.Reload			= Sound( "Popcan.ImpactSoft" )
SWEP.Primary.Damage			= 10
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 1.800

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	self.AnimTime = CurTime() + 0.2
	
	if IsFirstTimePredicted() and ValidEntity( self.Owner ) then
		
		if SERVER then
		
			local scale = 0.50
			if self.Owner:KeyDown(IN_DUCK) then
				scale = 0.25
			elseif self.Owner:KeyDown(IN_SPEED) then
				scale = 0.75
			end
			
			local pang, yang = math.Rand( -1 * scale, 0 ) * self.Primary.Recoil, math.Rand( -1 * ( scale / 3 ), ( scale / 3 ) ) * self.Primary.Recoil
			self.Owner:ViewPunch( Angle( pang, yang, 0) )
			self.Weapon:Snowball()
			
		end
		
	end
	
end

function SWEP:Think()	

	if !self.AnimTime then return end
	
	if self.AnimTime < CurTime() then
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		self.AnimTime = nil
	end

end

function SWEP:Snowball()
	
	local snow = ents.Create( "sent_snowball" )
	snow:SetPos( self.Owner:GetShootPos() )
	snow:SetAngles( self.Owner:GetAimVector():Angle() )
	snow:SetOwner( self.Owner )
	snow:Spawn()
	
end
