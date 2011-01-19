
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

local function DrawIntern()
	
	ColorModify[ "$pp_colour_mulr" ] 		= math.Approach( ColorModify[ "$pp_colour_mulr" ], 0, FrameTime() )
	ColorModify[ "$pp_colour_mulg" ]		= math.Approach( ColorModify[ "$pp_colour_mulg" ], 0, FrameTime() )
	ColorModify[ "$pp_colour_mulb" ] 		= math.Approach( ColorModify[ "$pp_colour_mulb" ], 0, FrameTime() )
	ColorModify[ "$pp_colour_colour" ] 		= math.Approach( ColorModify[ "$pp_colour_colour" ], 1, FrameTime() )
	ColorModify[ "$pp_colour_brightness" ] 	= math.Approach( ColorModify[ "$pp_colour_brightness" ], 0, FrameTime() )
	ColorModify[ "$pp_colour_addr" ] 		= math.Approach( ColorModify[ "$pp_colour_addr" ], 0, FrameTime() )
	ColorModify[ "$pp_colour_addg" ] 		= math.Approach( ColorModify[ "$pp_colour_addg" ], 0, FrameTime() )
	ColorModify[ "$pp_colour_addb" ] 		= math.Approach( ColorModify[ "$pp_colour_addb" ], 0, FrameTime() )
	
	DrawColorModify( ColorModify )

end

hook.Add( "RenderScreenspaceEffects", "RenderPostProcessing", DrawIntern )