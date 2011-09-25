

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Famas"			
	SWEP.Author				= "Carnag3"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "t"
	
	killicon.AddFont( "weapon_famas", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_famas.mdl"
SWEP.ViewModelFlip 		= false
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_Famas.Single" )
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 5
SWEP.Primary.NumShots		= 3
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 18
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= 36
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "CombineCannon"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( -4.5, -3.2, 1.0 )

function SWEP:PrimaryAttack()
-- ive stolen this from the cs base because i want to use the primary fire function but not overwrite what the base does, i tried hook.Add but with no success! 
	
	if self.Weapon:GetNetworkedBool("Ironsights") == true then -- less recoil in ironsight
		self.Primary.Recoil = 0.5
	else
		self.Primary.Recoil = 2
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if ( !self:CanPrimaryAttack() ) then return end
	
	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )
	
	// Shoot the bullet
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	if ( self.Owner:IsNPC() ) then return end
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end