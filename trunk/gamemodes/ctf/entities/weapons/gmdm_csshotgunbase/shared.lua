if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true; -- HVA Specific

SWEP.AllowRicochet				= true;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronsightsFOV				= 65; -- HVA Specific

SWEP.ReloadDelay				= 0.3;
SWEP.ReloadThenPump				= true;

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 0.8;
SWEP.IronsightRunSpeed			= 0.6;


SWEP.RunArmOffset = Vector (-4.6589, -6.1164, 1.5132)
SWEP.RunArmAngle = Vector (-1.9077, -60.5299, -5.7275)



function SWEP:Reload( )	
	if( self.Weapon:GetNetworkedBool( "reload", false ) == false and self.Owner:GetAmmoCount( self.Primary.Ammo ) >= 0 and self.Weapon:Clip1() < self.Primary.ClipSize ) then
		self:SetIronsights( false )
		self.Weapon:SetNetworkedBool( "reload", true );
		self.Weapon:SetNetworkedFloat( "nextreload", CurTime() );
	end
end

function SWEP:Think( )

	if( self.Weapon:GetNetworkedBool( "Ironsights" ) == true and self.Owner:KeyDown( IN_SPEED ) ) then
		self:SetIronsights( false );
	elseif( self.Owner and self.Owner:IsPlayer() and self.Owner:KeyPressed( IN_ATTACK ) and self.Weapon:GetNetworkedBool( "reload", false ) == true ) then
		self.Weapon:SetNetworkedBool( "finishreload", true ); -- reload interrupt
		self.Weapon:SetNextPrimaryFire( CurTime() + self.ReloadDelay );
	elseif( self.Weapon:GetNetworkedBool( "finishreload", false ) == true and CurTime() >= self.Weapon:GetNetworkedFloat( "nextreload", 0 ) ) then
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
		self.Weapon:SetNetworkedBool( "reload", false );
		self.Weapon:SetNetworkedBool( "finishreload", false );
		self.Weapon:SetNextPrimaryFire( CurTime() + self.ReloadDelay );
	elseif( self.Weapon:GetNetworkedBool( "reload", false ) == true and CurTime() >= self.Weapon:GetNetworkedFloat( "nextreload", 0 ) ) then
		if( self.Weapon:Clip1() >= self.Primary.ClipSize ) then
			self.Weapon:SetNetworkedBool( "reload", false );
			return;
		end
		
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
		self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		
		self.Weapon:SetNetworkedFloat( "nextreload", CurTime() + self.ReloadDelay );
		
		if( self.Weapon:Clip1() >= self.Primary.ClipSize ) then
			if( self.ReloadThenPump == true ) then
				self.Weapon:SetNetworkedBool( "finishreload", true );
				self.Weapon:SetNextPrimaryFire( CurTime() + self.ReloadDelay );
			else
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
			end
		end
	end
	
end
