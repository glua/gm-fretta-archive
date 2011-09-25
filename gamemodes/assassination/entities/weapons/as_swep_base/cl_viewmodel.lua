SWEP.VelocityEffect = true;

function SWEP:CalcViewModelEffects( pos, ang )
	--if( !self:CanShootWeapon() ) then return self.BaseClass.GetViewModelPosition( pos, ang )	 end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )	
	
	local vel = self.Owner:GetVelocity()
			
	if( self.VelocityEffect ) then -- Z offset is affected by velocity
		if( self.LastOffset and !bIron ) then
			if( vel.z == 0 and self.LastOffset != 0 ) then
				if( !self.LastRestoreOffset ) then
					self.LastRestoreOffset = self.LastOffset;
				end
				
				local offset = math.Approach( self.LastRestoreOffset, 0, -0.85);
				pos.z = pos.z - offset
				
				self.LastRestoreOffset = offset
				
				if( offset == 0 ) then
					self.LastOffset = 0;
					self.LastRestoreOffset = nil;
				end
			else
				local offset = math.Clamp( vel.z / 90, -3, 1.5 )
				local vellen = vel:Length();
				
				pos.z = pos.z - offset - ( vellen / 200 )
					
				self.LastOffset = offset
				self.LastOffTime = CurTime()		
				self.LastRestoreOffset = self.LastOffset;
			end
		else
			self.LastOffset = 0;
		end
	end

	
	local DashDelta = 0
	
	// If we're running, or have just stopped running, lerp between the 
	if ( self.Weapon:GetNetworkedBool( "RunningAnims", false ) ) then
		
		if (!self.DashStartTime) then
			self.DashStartTime = CurTime()
		end
		
		DashDelta = math.Clamp( ((CurTime() - self.DashStartTime) / 0.2) ^ 1.2, 0, 1 )
		
	else
	
		if ( self.DashStartTime ) then
			self.DashEndTime = CurTime()
		end
	
		if ( self.DashEndTime ) then
		
			DashDelta = math.Clamp( ((CurTime() - self.DashEndTime) / 0.2) ^ 1.2, 0, 1 )
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
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - self.IronsightTime ) then 
		return pos, ang
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - self.IronsightTime ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / self.IronsightTime, 0, 1 )
		
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
	
	// Different sway scales depending on what we're doing
	if ( bIron ) then 
		self.SwayScale 	= 0.1
		self.BobScale 	= 0.1
	elseif( self.Weapon:GetNetworkedBool( "RunningAnims", false ) == true ) then
		self.SwayScale 	= 2.0
		self.BobScale 	= 2.5		
	else
		self.SwayScale 	= 1.5
		self.BobScale 	= 1.0
	end
	
	return pos, ang
end

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )
	return self:CalcViewModelEffects( pos, ang );
end
