
Sharpen = 0
MotionBlur = 0
ViewWobble = 0
DisorientTime = 0
ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= 0
ColorModify[ "$pp_colour_contrast" ] 	= 1
ColorModify[ "$pp_colour_colour" ] 		= 1
ColorModify[ "$pp_colour_mulr" ] 		= 0
ColorModify[ "$pp_colour_mulg" ] 		= 1
ColorModify[ "$pp_colour_mulb" ] 		= 1

local function DrawInternal()

	if ( Sharpen > 0 ) then
		DrawSharpen( Sharpen, 0.5 )
		Sharpen = math.Approach( Sharpen, 0, FrameTime() * 0.5 )
	end

	if ( MotionBlur > 0 ) then
		DrawMotionBlur( 1 - MotionBlur, 1.0, 0.0 )
		MotionBlur = math.Approach( MotionBlur, 0, FrameTime() * 0.025 )
	end
	
	local approach = FrameTime() * 0.05
	
	ColorModify[ "$pp_colour_mulr" ] 		= math.Approach( ColorModify[ "$pp_colour_mulr" ], 0, approach )
	ColorModify[ "$pp_colour_mulg" ]		= math.Approach( ColorModify[ "$pp_colour_mulg" ], 0, approach )
	ColorModify[ "$pp_colour_mulb" ] 		= math.Approach( ColorModify[ "$pp_colour_mulb" ], 0, approach )
	ColorModify[ "$pp_colour_colour" ] 		= math.Approach( ColorModify[ "$pp_colour_colour" ], 1, approach )
	ColorModify[ "$pp_colour_contrast" ] 	= math.Approach( ColorModify[ "$pp_colour_contrast" ], 1, approach )
	ColorModify[ "$pp_colour_brightness" ] 	= math.Approach( ColorModify[ "$pp_colour_brightness" ], 0, approach )
	ColorModify[ "$pp_colour_addr" ] 		= math.Approach( ColorModify[ "$pp_colour_addr" ], 0, approach )
	ColorModify[ "$pp_colour_addg" ] 		= math.Approach( ColorModify[ "$pp_colour_addg" ], 0, approach )
	ColorModify[ "$pp_colour_addb" ] 		= math.Approach( ColorModify[ "$pp_colour_addb" ], 0, approach )
	
	DrawColorModify( ColorModify )
	
	if LocalPlayer():Team() == TEAM_STALKER then 
	
		if LocalPlayer():Alive() then
		
			ColorModify[ "$pp_colour_addr" ]		= .10
			ColorModify[ "$pp_colour_addg" ]		= .05
			
			if LocalPlayer():GetNWBool( "StalkerEsp", false ) then
			
				ColorModify[ "$pp_colour_mulr" ] 		= .35
				ColorModify[ "$pp_colour_mulg" ] 		= .20
				ColorModify[ "$pp_colour_brightness" ] 	= -0.15
				ColorModify[ "$pp_colour_contrast" ]	= 1.0
			
			else
			
				ColorModify[ "$pp_colour_mulr" ] 		= .25
				ColorModify[ "$pp_colour_mulg" ] 		= .05
				ColorModify[ "$pp_colour_brightness" ] 	= -0.05
				ColorModify[ "$pp_colour_contrast" ]	= 1.5
				
			end
			
			if LocalPlayer():GetNWInt( "Poison", 0 ) > 0 then
			
				ColorModify[ "$pp_colour_addb" ]		= .10
				ColorModify[ "$pp_colour_mulb" ]		= .15
				MotionBlur = 0.7
				Sharpen = 5.5
				
			else
			
				ColorModify[ "$pp_colour_colour" ]		= math.Approach( ColorModify[ "$pp_colour_colour" ], .90, FrameTime() * 0.1 )
				
			end
			
		else
		
			// dead player
			ColorModify[ "$pp_colour_brightness" ] 	= -.20
			ColorModify[ "$pp_colour_addr" ]		= .25
			ColorModify[ "$pp_colour_mulr" ] 		= .30
			ColorModify[ "$pp_colour_addg" ]		= .05
			
		end
		
	end

end
hook.Add( "RenderScreenspaceEffects", "RenderPostProcessing", DrawInternal )

function GM:GetMotionBlurValues( y, x, fwd, spin ) 

	if LocalPlayer():Alive() and LocalPlayer():Health() <= 25 and LocalPlayer():Team() == TEAM_HUMAN then
	
		local scale = LocalPlayer():Health() / 25
		fwd = 0.5 - ( scale * 0.5 )
		ViewWobble = 0.5 - 0.5 * scale
		
	end
	
	if LocalPlayer():Alive() and LocalPlayer():Health() <= 50 and LocalPlayer():Team() == TEAM_STALKER then
	
		local scale = LocalPlayer():Health() / 50
		fwd = 1 - scale
		ViewWobble = 0.5 - 0.5 * scale
		
	end
	
	if DisorientTime > CurTime() then
	
		if not LocalPlayer():Alive() then 
			DisorientTime = 0
		end
	
		local scale = ( DisorientTime - CurTime() ) / 20
		local newx, newy = RotateAroundCoord( 0, 0, 1.0, scale * 0.05 )
		
		return newy, newx, fwd, spin
	
	end

	return y, x, fwd, spin

end

function RotateAroundCoord( x, y, speed, dist )

	local newx = x + math.sin( CurTime() * speed ) * dist
	local newy = y + math.cos( CurTime() * speed ) * dist

	return newx, newy

end

WalkTimer = 0
VelSmooth = 0

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.5 + vel:Length() * 0.1
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1
	
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01
	
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
