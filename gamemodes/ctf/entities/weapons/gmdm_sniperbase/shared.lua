
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 55
	
	SWEP.ScopeTexture		= surface.GetTextureID( "weapons/scopes/scope2" );
	
	killicon.Add( "gmdm_sniperbase", "d_spring", Color( 150, 150, 150 ) )
end

SWEP.Base						= "gmdm_csbase";
SWEP.Author						= "SteveUK";
SWEP.Contact					= "stephen.swires@gmail.com";
SWEP.Purpose					= "CCTF Weapon";
SWEP.Instructions				= "To defeat the cyberdemon, shoot at it until it dies.";

SWEP.Category					= "Combat CTF";

SWEP.HoldType					= "ar2"

SWEP.IsCSWeapon					= false;
SWEP.ViewModel					= "models/weapons/v_springfield.mdl"
SWEP.WorldModel					= "models/weapons/w_springfield.mdl"

if( CLIENT and SWEP.IsCSWeapon == true ) then
	SWEP.ViewModelFlip		= true;
	SWEP.CSMuzzleFlashes	= true;
else
	SWEP.ViewModelFlip		= false;
	SWEP.CSMuzzleFlashes	= false;
end

SWEP.Primary.Sound				= Sound( "Weapon_AK47.Single" );
SWEP.Primary.Recoil				= 0.75;
SWEP.Primary.Damage				= 21;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.1;
SWEP.Primary.Delay				= 1.5;

SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 6;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Ammo				= "smg1";

SWEP.HasIronsights				= true; -- HVA Specific


SWEP.IronSightsPos = Vector (-5.2661, -2.4802, 1.019)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.ScopeTime	 = 0.35

SWEP.IronsightsFOV				= 25; -- HVA Specific
SWEP.IronsightAccuracy			= 9; -- what to divide spread by to increase accuracy
SWEP.StopIronsightsAfterShot	= true
SWEP.IronsightFOVSpeed			= 0.75
SWEP.IronsightDelayFOV			= true;

-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.8;
SWEP.RunSpeed					= 0.7;
SWEP.IronsightWalkSpeed			= 0.2;
SWEP.IronsightRunSpeed			= 0.1;

SWEP.LastAttack = 0;


SWEP.RunArmOffset = Vector (10.3605, 0.0137, -0.5843)
SWEP.RunArmAngle = Vector (-5.2527, 40.9672, 1.4453)

if( CLIENT ) then

	function SWEP:DrawHUD()
		self:DrawCrosshairHUD()
		
		local bIron = self.Weapon:GetNetworkedBool( "Ironsights", false )	
		local fIronTime = self.fIronTime or 0
		
		if( bIron && CurTime() > fIronTime + self.ScopeTime ) then
			local w = (ScrH()/3)*4
			surface.SetDrawColor( 255, 255, 255, 255 );
			surface.SetTexture( self.ScopeTexture );
			surface.DrawTexturedRect( ( ScrW() / 2 ) - w/2, 0, w, ScrH() );
			
			surface.SetDrawColor( 0, 0, 0, 255 );
			surface.DrawRect( 0, 0, ( ScrW() / 2 ) - w/2, ScrH() )
			surface.DrawRect( ( ScrW() / 2 ) + w/2, 0, ScrW() - ( ( ScrW() / 2 ) + w/2 ), ScrH() )
		end	
	end
	
end

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	--if( !self:CanShootWeapon() ) then return self.BaseClass.GetViewModelPosition( pos, ang )	 end

	local SCOPE_TIME = self.ScopeTime;
	
	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )	

	local vel = self.Owner:GetVelocity()
				
	if( self.LastOffset and !bIron ) then
		if( vel.z == 0 and self.LastOffset != 0 ) then
			if( !self.LastRestoreOffset ) then
				self.LastRestoreOffset = self.LastOffset;
			end
			
			local offset = math.Approach( self.LastRestoreOffset, 0, -0.5);
			pos.z = pos.z - offset
			
			self.LastRestoreOffset = offset
			
			if( offset == 0 ) then
				self.LastOffset = 0;
				self.LastRestoreOffset = nil;
			end
		else
			local offset = math.Clamp( vel.z / 50, -3, 2 )
			pos.z = pos.z - offset
				
			self.LastOffset = offset
			self.LastOffTime = CurTime()		
		end
	else
		self.LastOffset = 0;
	end
	
	local DashDelta = 0
	
	// If we're running, or have just stopped running, lerp between the 
	if ( self.Owner:KeyDown( IN_SPEED ) ) then
		
		if (!self.DashStartTime) then
			self.DashStartTime = CurTime()
		end
		
		DashDelta = math.Clamp( ((CurTime() - self.DashStartTime) / 0.1) ^ 1.2, 0, 1 )
		
	else
	
		if ( self.DashStartTime ) then
			self.DashEndTime = CurTime()
		end
	
		if ( self.DashEndTime ) then
		
			DashDelta = math.Clamp( ((CurTime() - self.DashEndTime) / 0.1) ^ 1.2, 0, 1 )
			DashDelta = 1 - DashDelta
			if ( DashDelta == 0 ) then self.DashEndTime = nil end
		
		end
	
		self.DashStartTime = nil
	
	end
	
	if ( DashDelta ) then
	
		local Down = ang:Up() * -1
		local Right = ang:Right()
		local Forward = ang:Forward()
	
		local bUseVector = false
		
		if( !self.RunArmAngle.pitch ) then
			bUseVector = true
		end
		
		// Rotate the viewmodel to self.RunArmAngle
		if( bUseVector == true ) then -- using ironsights designer probably so make it support that
			ang:RotateAroundAxis( ang:Right(), 		self.RunArmAngle.x * DashDelta )
			ang:RotateAroundAxis( ang:Up(), 		self.RunArmAngle.y * DashDelta )
			ang:RotateAroundAxis( ang:Forward(), 	self.RunArmAngle.z * DashDelta )
			
			pos = pos + self.RunArmOffset.x * ang:Right() * DashDelta 
			pos = pos + self.RunArmOffset.y * ang:Forward() * DashDelta 
			pos = pos + self.RunArmOffset.z * ang:Up() * DashDelta 
		else
			ang:RotateAroundAxis( Right,	self.RunArmAngle.pitch * DashDelta )
			ang:RotateAroundAxis( Down,  	self.RunArmAngle.yaw   * DashDelta )
			ang:RotateAroundAxis( Forward,  self.RunArmAngle.roll  * DashDelta )

			// Offset the viewmodel to self.RunArmOffset
			pos = pos + ( Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z ) * DashDelta			
		end
		
		if( self.DashEndTime ) then
			return pos, ang
		end
	
	end


	if( !self.IronSightsPos or !self.HasIronsights ) then return pos, ang end
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if( bIron && CurTime() > fIronTime + SCOPE_TIME ) then
		local returnpos = pos + Vector( 0,0,-20)
		return returnpos, ang;
	end
	
	if ( !bIron && fIronTime < CurTime() - SCOPE_TIME ) then 
		return pos, ang
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - SCOPE_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / SCOPE_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	
	return pos, ang

	
end
