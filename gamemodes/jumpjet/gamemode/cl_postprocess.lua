
Sharpen = 0
MotionBlur = 0
BlurScale = 0
ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= 0
ColorModify[ "$pp_colour_contrast" ] 	= 1.2
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
		MotionBlur = MotionBlur - 0.1 * FrameTime()
		
	end
	
	local approach = FrameTime() * 0.1
	
	ColorModify[ "$pp_colour_mulr" ] 		= math.Approach( ColorModify[ "$pp_colour_mulr" ], 0, approach * 1.5 )
	ColorModify[ "$pp_colour_mulg" ]		= math.Approach( ColorModify[ "$pp_colour_mulg" ], 0, approach * 1.5 )
	ColorModify[ "$pp_colour_mulb" ] 		= math.Approach( ColorModify[ "$pp_colour_mulb" ], 0, approach * 1.5 )
	ColorModify[ "$pp_colour_colour" ] 		= math.Approach( ColorModify[ "$pp_colour_colour" ], 1, approach )
	ColorModify[ "$pp_colour_brightness" ] 	= math.Approach( ColorModify[ "$pp_colour_brightness" ], 0, approach )
	ColorModify[ "$pp_colour_addr" ] 		= math.Approach( ColorModify[ "$pp_colour_addr" ], 0, approach )
	ColorModify[ "$pp_colour_addg" ] 		= math.Approach( ColorModify[ "$pp_colour_addg" ], 0, approach )
	ColorModify[ "$pp_colour_addb" ] 		= math.Approach( ColorModify[ "$pp_colour_addb" ], 0, approach )
	
	DrawColorModify( ColorModify )
	
	if not LocalPlayer():Alive() then
	
		Sharpen = math.Approach( Sharpen, 0, 0.01 )
		MotionBlur = math.Approach( MotionBlur, 0, 0.01 )
		BlurScale = math.Approach( BlurScale, 0, 0.01 )
		
	end

end
hook.Add( "RenderScreenspaceEffects", "RenderPostProcessing", DrawInternal )

function GM:GetMotionBlurValues( x, y, fwd, spin ) 

	fwd = BlurScale
	
	if LocalPlayer():GetNWInt( "Focus", 450 ) > 450 then
	
		spin = 0.5
		
	end

	return x, y, fwd, spin

end
