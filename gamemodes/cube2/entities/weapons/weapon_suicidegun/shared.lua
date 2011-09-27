SWEP.Author					= "Disseminate"
SWEP.Contact				= ""
SWEP.Purpose				= "To end your life."
SWEP.Instructions			= "Left click to take your own life."
SWEP.Category				= "Cube"

SWEP.Base					= "weapon_base"
SWEP.HoldType				= "pistol"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/v_357.mdl"
SWEP.WorldModel				= "models/weapons/w_357.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShootSound 			= Sound( "Weapon_357.Single" );
SWEP.IronSightsPos 			= Vector( -2.9547, -28.7916, 0.9214 );
SWEP.IronSightsAng 			= Vector( 95.4548, -9.2427, 0 );

function SWEP:Initialize()
	
	self:SetWeaponHoldType( self.HoldType )
	self.Ironsights = false;
	
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	
	self.Ironsights = true;
	
	if( SERVER ) then
		
		timer.Simple( 1, self.Shoot, self );
		
	end
	
end

function SWEP:SecondaryAttack()
end

function SWEP:GetViewModelPosition( pos, ang )
	
	local IRONSIGHT_TIME = 0.5;
	
	local bIron = self.Ironsights;
	
	if( bIron != self.bLastIron ) then
		
		self.bLastIron = bIron;
		self.fIronTime = CurTime();
		
	end
	
	local fIronTime = self.fIronTime or 0;

	if( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then
		
		return pos, ang;
		
	end
	
	local Mul = 1.0;
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( ( CurTime() - fIronTime ) / IRONSIGHT_TIME, 0, 1 );
		
		if( !bIron ) then
			
			Mul = 1 - Mul;
			
		end
	
	end

	local Offset = self.IronSightsPos;
	
	if( self.IronSightsAng ) then
	
		ang = ang * 1;
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul );
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul );
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul );
		
	end
	
	local Right 	= ang:Right();
	local Up 		= ang:Up();
	local Forward 	= ang:Forward();
	
	pos = pos + Offset.x * Right * Mul;
	pos = pos + Offset.y * Forward * Mul;
	pos = pos + Offset.z * Up * Mul;

	return pos, ang;
	
end

function SWEP:Shoot()
	
	local pos = self.Owner:GetPos();
	
	WorldSound( self.ShootSound, self:GetPos() ); -- So the sound doesn't cut after I die
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	
	self.Owner:TakeDamage( 200, self, self );
	
end
