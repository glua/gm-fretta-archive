include( 'shared.lua' )

/*---------------------------------------------------------
   Name: gamemode:GetMotionBlurSettings()
   Desc: Allows you to edit the motion blur values
---------------------------------------------------------*/
function GM:GetMotionBlurValues( x, y, fwd, spin )

	local EyeAngles = LocalPlayer():EyeAngles()
	
	local Velocity = LocalPlayer():GetVelocity()
	fwd = ( Velocity:Dot( EyeAngles:Forward() ) - 100 ) / 20000
	
	fwd = math.Clamp( fwd, 0, 1 )
	
	y = ( Velocity:Dot( EyeAngles:Up() ) ) / 20000
	
	return x, y, fwd, spin
	
end


