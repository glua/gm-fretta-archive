
local matBlurEdges		= Material( "bluredges" )
local tex_MotionBlur	= render.GetMoBlurTex0()

ColorModify = {}

function ResetPostProcess()

	Sharpen = 1

	MotionBlur = 0

	ColorModify[ "$pp_colour_addr" ] 		= 0
	ColorModify[ "$pp_colour_addg" ] 		= 0
	ColorModify[ "$pp_colour_addb" ] 		= 0
	ColorModify[ "$pp_colour_brightness" ] 	= 0
	ColorModify[ "$pp_colour_contrast" ] 	= 1.0
	ColorModify[ "$pp_colour_colour" ] 		= 1.1
	ColorModify[ "$pp_colour_mulr" ] 		= 0
	ColorModify[ "$pp_colour_mulg" ] 		= 1
	ColorModify[ "$pp_colour_mulb" ] 		= 1
	
end

ResetPostProcess()

Sharpen = 0

function GM:PostProcessing()
	ColorModify[ "$pp_colour_mulr" ] 	= math.Approach( ColorModify[ "$pp_colour_mulr" ], 0, FrameTime() * 0.3 )
	ColorModify[ "$pp_colour_mulg" ]	= math.Approach( ColorModify[ "$pp_colour_mulg" ], 0, FrameTime() * 0.3 )
	ColorModify[ "$pp_colour_mulb" ] 	= math.Approach( ColorModify[ "$pp_colour_mulb" ], 0, FrameTime() * 0.3 )
	ColorModify[ "$pp_colour_colour" ] 	= math.Approach( ColorModify[ "$pp_colour_colour" ], 1.1, FrameTime() * 0.3 )
	ColorModify[ "$pp_colour_addr" ] 	= math.Approach( ColorModify[ "$pp_colour_addr" ], 0.00, FrameTime() * 0.3 )
	ColorModify[ "$pp_colour_addg" ] 	= math.Approach( ColorModify[ "$pp_colour_addg" ], 0.00, FrameTime() * 0.3 )
	ColorModify[ "$pp_colour_addb" ] 	= math.Approach( ColorModify[ "$pp_colour_addb" ], 0.00, FrameTime() * 0.3 )
	ColorModify[ "$pp_colour_brightness" ] 	= math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.00, FrameTime() * 0.6 )
end

local function DrawInternal()

	-- we don't need blur in source 2007
	--if (MotionBlur > 0) then
		--DrawMotionBlur( 1 - MotionBlur, 1.0, 0.0 )
		--MotionBlur = math.Approach( MotionBlur, 0, 0.3 * FrameTime() )
	--end
	
	GAMEMODE:PostProcessing();
	
	if( GetGlobalBool( "Interval", false ) == true ) then
		ColorModify[ "$pp_colour_colour" ] 	= math.Approach( ColorModify[ "$pp_colour_colour" ], 0, FrameTime() )
		--ColorModify[ "$pp_colour_brightness" ] 	= math.Approach( ColorModify[ "$pp_colour_colour" ], -0.3, FrameTime() * 1 )
	end
	
	DrawColorModify( ColorModify )
	
	//DrawSharpen( Sharpen, 0.25 )
	//Sharpen = math.Approach( Sharpen, 1, FrameTime() * 10000 )

end

hook.Add( "RenderScreenspaceEffects", "RenderPostProcessing", DrawInternal )