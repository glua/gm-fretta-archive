
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
	ColorModify[ "$pp_colour_brightness" ] 	= 0
end

local function DrawInternal()

	GAMEMODE:PostProcessing();
	
	if( GetGlobalBool( "Interval", false ) == true or ( LocalPlayer() and !LocalPlayer():Alive() ) ) then
		ColorModify[ "$pp_colour_colour" ] 	= math.Approach( ColorModify[ "$pp_colour_colour" ], 0, FrameTime() )
		DrawSharpen( 1, 0.25 )
	end
	
	DrawColorModify( ColorModify )

end

hook.Add( "RenderScreenspaceEffects", "RenderPostProcessing", DrawInternal )