
// Straight outa GMDM
function SWEP:Recoil( pitch, yaw )

	// On the client it can sometimes process the same usercmd twice
	// This function returns true if it's the first time we're doing this usercmd
	if ( !SinglePlayer() && !IsFirstTimePredicted() ) then return end

	// People shouldn't really be playing in SP
	// But if they are they won't get recoil because the weapons aren't predicted
	// So the clientside stuff never fires the recoil
	if ( SERVER && SinglePlayer() ) then 
	
		// Please don't call SendLua in multiplayer games. This uses a lot of bandwidth
		self:SendLua( "LocalPlayer():GetActiveWeapon():Recoil("..pitch..","..yaw..")" )
		return 
		
	end
	
	self.LastShoot = 0.5
	self.LastShootSize = math.abs(yaw) + math.abs(pitch)
	
	self.RecoilYaw = self.RecoilYaw or 0
	self.RecoilPitch = self.RecoilPitch or 0
	
	self.RecoilYaw = self.RecoilYaw 		+ yaw
	self.RecoilPitch = self.RecoilPitch 	+ pitch

end

function SWEP:DoRecoilThink( pitch, yaw )

	if ( SERVER ) then return end
	if ( ValidEntity( self.Owner ) and self.Owner:IsPlayer() and self.Owner != LocalPlayer() ) then return end
	
	local pitch 	= self.RecoilPitch	or 0
	local yaw 		= self.RecoilYaw  	or 0
	
	pitch = pitch
	yaw = yaw
	
	local pitch_d	= math.Approach( pitch, 0.0, 20.0 * FrameTime() * math.abs(pitch) )
	local yaw_d		= math.Approach( yaw, 0.0, 20.0 * FrameTime() * math.abs(yaw) )
	
	self.RecoilPitch 	= pitch_d
	self.RecoilYaw 		= yaw_d
		
	// Update eye angles
	local eyes = self.Owner:EyeAngles()
		eyes.pitch = eyes.pitch + ( pitch - pitch_d )
		eyes.yaw = eyes.yaw + ( yaw - yaw_d )
		eyes.roll = 0
	self.Owner:SetEyeAngles( eyes )

end