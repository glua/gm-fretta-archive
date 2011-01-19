
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.CustomSecondaryAmmo = true

if ( CLIENT ) then

	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/mine" )

end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "#TripMines"			
SWEP.Slot				= 5
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"

SWEP.ConstantAccuracy	= true
SWEP.Primary.Cone		= 0.0;

function SWEP:Initialize( )
	self:GMDMInit()
	self:SetWeaponHoldType( "grenade" )	
end

function SWEP:FirstTimePickup( Owner )
	Owner:AddCustomAmmo( "TripMines", 3 )	
end

function SWEP:Deploy()
	if( self:HasUsableAmmo() == true ) then
		self.Weapon:SendWeaponAnim( ACT_SLAM_TRIPMINE_DRAW )
	else
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_IDLE )
	end
	return true
end

function SWEP:HasUsableAmmo( )
	return self.Owner:GetCustomAmmo( "TripMines" ) > 0
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

function SWEP:PrimaryAttack( )

	if( self:HasUsableAmmo() == false ) then
		self:Reload()
		return
	end
	
	self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_THROW )

	self.Weapon:SetNextSecondaryFire( CurTime( ) + 0.1 )
	self.Weapon:SetNextPrimaryFire( CurTime( ) + 0.1 )
	

	if not self:CanShootWeapon( ) then return end	
	if self.Owner:GetCustomAmmo( "TripMines" ) < 1 then return end


	self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_THROW )
	self:NoteGMDMShot( )
	
	if SERVER then
		timer.Simple( 0.1, self.FinishGrenadeThrow, self )
		self.Owner:TakeCustomAmmo( "TripMines", 1 )
	end
end

function SWEP:Reload( )
	
	if( !SERVER ) then return end -- server side only past this point
	
	-- explode all our tripmines
	local tTripmines = ents.FindByClass( "item_tripmine" );
	local iCount = 0
	
	for k, v in pairs( tTripmines ) do
		if( v:GetNetworkedEntity( "Thrower" ) == self.Owner and v.Laser and v.Laser:IsValid() and v.Laser.Activated == true and v.Laser:GetActiveTime( ) != 0 and v.Laser:GetActiveTime( ) < CurTime( ) ) then
			v.Remote = true;
			v:Explode( true )
			iCount = iCount + 1
		end
	end
	
	if( iCount > 0 ) then
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
	end
	
end


function SWEP:FinishGrenadeThrow( )

	if( !ValidEntity( self.Owner ) ) then return end
	
	local trace = { }
		trace.start = self.Owner:GetShootPos( )
		trace.endpos = self.Owner:GetShootPos( ) + self.Owner:GetAimVector( ) * 64
		trace.mask = MASK_NPCWORLDSTATIC
		trace.filter = self.Owner
		
	local tr = util.TraceLine( trace )
	
	local ent = ents.Create( "item_tripmine" )
	if ValidEntity( ent ) then
	
		ent:SetPos( trace.endpos )
		--ent:SetOwner( self.Owner );
		ent:SetNetworkedEntity( "Thrower", self.Owner );
		ent:Spawn( )
		ent:Activate( )
		
		if tr.Hit then
			ent:StartTripmineMode( tr.HitPos, tr.HitNormal )
		else
			ent:GetPhysicsObject( ):SetVelocity( self.Owner:GetAimVector( ) * 2000 + self.Owner:GetVelocity( ) )
		end
	end
	
	if( self:HasUsableAmmo() == true ) then
		self.Weapon:SendWeaponAnim( ACT_SLAM_TRIPMINE_DRAW )
	else
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_IDLE )
	end
	
	--self:CheckRedundancy()
end

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:SecondaryAttack( )

	if( self:HasUsableAmmo() == false ) then
		self:Reload()
		return
	end
	
	self:PrimaryAttack( )
end


function SWEP:CustomAmmoCount()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	return self.Owner:GetCustomAmmo( "TripMines" )
	
end