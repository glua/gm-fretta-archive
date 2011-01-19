include( 'shared.lua' )
include( 'admin.lua' )
include( 'cl_postprocess.lua' )
include( 'cl_hud.lua' )

WalkTimer = 0
VelSmooth = 0
ViewWobble = 0

DieAng = Angle(0,0,0)

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
	
	// follow your killer
	if not LocalPlayer():Alive() then
	
		if not ValidEntity( ply:GetNWEntity( "TargetEnt", ply ) ) or ply:GetNWEntity( "TargetEnt", ply ) == ply then
			return self.BaseClass:CalcView( ply, origin, angle, fov )
		end
	
		local ent = ply:GetNWEntity( "TargetEnt", ply )
	
		if not DieTime then
	
			DieTime = CurTime() + 1
			DiePlay = true
			DiePos = ply:GetPos() + Vector(0,0,50)
			
			DieAng = ( ent:GetShootPos() - (ply:GetPos() + Vector(0,0,50) ) ):Normalize():Angle()
			
		elseif DieTime < CurTime() then
		
			if DiePlay then
				ply:EmitSound( Sound( "weapons/physcannon/physcannon_drop.wav" ) )
				DiePlay = false
			end
		
			local dist = DiePos:Distance( ent:GetShootPos() )
			
			if dist < 100 then 
				return { origin = DiePos, angles = DieAng, fov = fov }
			end
			
			local ang = ( ent:GetShootPos() - DiePos ):Normalize():Angle()
			
			DieAng.p = math.NormalizeAngle( math.ApproachAngle( DieAng.p, ang.p, FrameTime() * 100 ) )
			DieAng.y = math.NormalizeAngle( math.ApproachAngle( DieAng.y, ang.y, FrameTime() * 100 ) )
			DieAng.r = math.NormalizeAngle( math.ApproachAngle( DieAng.r, ang.r, FrameTime() * 100 ) )
			
			DiePos = DiePos + DieAng:Forward() * ( ( dist / 2 ) * FrameTime() )
			
			return { origin = DiePos, angles = DieAng, fov = fov }
			
		end	
	
	else
	
		DieTime = nil
	
	end
	
	return self.BaseClass:CalcView( ply, origin, angle, fov )
	
end