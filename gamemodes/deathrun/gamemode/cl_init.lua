include( 'shared.lua' )
include( 'cl_hud.lua' )

WalkTimer = 0
VelSmooth = 0
// Wobble Effect
function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()

	VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.1
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01

	if ( ply:GetGroundEntity() != NULL ) then 
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.001
	end

	return self.BaseClass:CalcView( ply, origin, angle, fov )
end