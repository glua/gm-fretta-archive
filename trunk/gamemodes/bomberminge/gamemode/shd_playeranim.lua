local AnimTranslateTable = {}
AnimTranslateTable[ PLAYER_RELOAD ] 	= ACT_HL2MP_GESTURE_RELOAD
AnimTranslateTable[ PLAYER_JUMP ] 		= ACT_HL2MP_JUMP
AnimTranslateTable[ PLAYER_ATTACK1 ] 	= ACT_HL2MP_GESTURE_RANGE_ATTACK

function GM:CalcMainActivity(ply, velocity)	
	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1
	
	if self:HandlePlayerDriving( ply ) ||
		self:HandlePlayerJumping( ply ) ||
		self:HandlePlayerDucking( ply, velocity ) ||
		self:HandlePlayerSwimming( ply ) then
		
	else
		local len2d = velocity:Length2D()
		
		if len2d > 150 then
			ply.CalcIdeal = ACT_MP_RUN
		elseif len2d > 0 then
			ply.CalcIdeal = ACT_MP_WALK
		end
	end
	
	// a bit of a hack because we're missing ACTs for a couple holdtypes
	local weapon = ply:GetActiveWeapon()
	
	if ply.CalcIdeal == ACT_MP_CROUCH_IDLE &&
		IsValid(weapon) &&
		( weapon:GetHoldType() == "knife" || weapon:GetHoldType() == "melee2" ) then
		
		ply.CalcSeqOverride = ply:LookupSequence("cidle_" .. weapon._InternalHoldType)
	end
	
	return ply.CalcIdeal, ply.CalcSeqOverride
end

function GM:UpdateAnimation(ply, velocity, maxseqgroundspeed)
	local len2d = velocity:Length2D()
	local rate = 1.0
	
	if len2d > 0.5 then
			rate =  ( len2d / maxseqgroundspeed )
	end
	
	rate = math.min(rate, 2)
	
	ply:SetPlaybackRate( rate )
	
	if ( ply:InVehicle() ) then
		local Vehicle =  ply:GetVehicle()
		
		// We only need to do this clientside..
		if ( CLIENT ) then
			//
			// This is used for the 'rollercoaster' arms
			//
			local Velocity = Vehicle:GetVelocity()
			ply:SetPoseParameter( "vertical_velocity", Velocity.z * 0.01 ) 

			// Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
			steer = steer * 2 - 1 // convert from 0..1 to -1..1
			ply:SetPoseParameter( "vehicle_steer", steer  ) 
		end
	end
	
	if CLIENT then
		if ply:GetNWBool("Grabbing") then
			ply:SetPoseParameter("aim_pitch", -90)
			ply:SetPoseParameter("head_pitch", -90)
		end
		
		ply:SetPoseParameter("aim_yaw", 0)
		ply:SetPoseParameter("body_yaw", 0)
		ply:SetPoseParameter("spine_yaw", 0)
	end
end
