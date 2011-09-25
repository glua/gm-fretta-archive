include( 'shared.lua' )
include( 'cl_hud.lua' )

--Wobble view thing..

WalkTimer = 0
VelSmooth = 0
ViewWobble = 0

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.5 + vel:Length() * 0.1
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1
	
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.005
	
	// motion sickness
	if ViewWobble > 0 then
		angle.roll = angle.roll + math.sin(CurTime() * 2.5) * (ViewWobble * 15)
		ViewWobble = ViewWobble - 0.1 * FrameTime()
	end
	
	// make their view tilt when they strafe
	if ply:GetGroundEntity() != NULL then	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.3 ) * VelSmooth * 0.001
	end

	
	return self.BaseClass:CalcView( ply, origin, angle, fov )
	
end