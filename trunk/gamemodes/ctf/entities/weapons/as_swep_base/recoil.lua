SWEP.PitchRecoilAccumulator = 0.0;
SWEP.YawRecoilAccumulator = 0.0;
SWEP.RecoilTimeRemaining = 0.0;

SWEP.RecoilMultiplier = 0.75; // just so i don't have to edit every single swep
SWEP.IronsightedRecoilMultiplier = 0.6;

function SWEP:Recoil( npitch, nyaw )

	// On the client it can sometimes process the same usercmd twice
	// This function returns true if it's the first time we're doing this usercmd
	if( !IsFirstTimePredicted() ) then return end

	local rangle = Angle();
	rangle.pitch = npitch * self.RecoilMultiplier;
	rangle.yaw = nyaw * self.RecoilMultiplier;
	
	// give a recoil bonus if ironsighted
	if( self.Weapon:GetNetworkedBool( "Ironsights" ) == true ) then
		rangle.pitch = rangle.pitch * self.IronsightedRecoilMultiplier;
		rangle.yaw = rangle.yaw * self.IronsightedRecoilMultiplier;		
	end
	
	if( rangle.pitch < 0 ) then
		rangle.pitch = rangle.pitch * -1;
	end
	
	self.RecoilTimeRemaining = self.RecoilTimeRemaining + 0.1;
	self.YawRecoilAccumulator = self.YawRecoilAccumulator + rangle.yaw;
	self.PitchRecoilAccumulator = self.YawRecoilAccumulator + rangle.pitch;
	
end

function SWEP:DoRecoilThink( ucmd )
	
	local viewAngles = ucmd:GetViewAngles();
	local rpitch, ryaw = self:GetRecoilToAddThisFrame();
	
	if( rpitch > 0 ) then
		viewAngles.pitch = viewAngles.pitch - rpitch;
		viewAngles.yaw = viewAngles.yaw + ryaw;
	end
	
	ucmd:SetViewAngles( viewAngles );
	
end


// returns pitch, yaw
function SWEP:GetRecoilToAddThisFrame()

	if( self.RecoilTimeRemaining < 0 ) then
		return 0, 0;
	end
	
	local timeRemaining = math.min( self.RecoilTimeRemaining, FrameTime() );
	local recoilProportion = timeRemaining / 0.1;
	
	local pitchRecoil = self.PitchRecoilAccumulator * recoilProportion;
	local yawRecoil = self.YawRecoilAccumulator * recoilProportion;
	
	self.RecoilTimeRemaining = self.RecoilTimeRemaining - FrameTime();
	
	return pitchRecoil, yawRecoil;
	
end

if( CLIENT ) then
	function DoRecoilThink( ucmd )
		if( ValidEntity( LocalPlayer() ) ) then
			local wpn = LocalPlayer():GetActiveWeapon();
			
			if( ValidEntity( wpn ) && wpn.DoRecoilThink ) then
				wpn:DoRecoilThink( ucmd )
			end
		end
	end

	hook.Add( "CreateMove", "ASRecoil", DoRecoilThink );
end