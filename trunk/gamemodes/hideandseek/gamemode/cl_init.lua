
include( 'shared.lua' )
include( 'cl_scores.lua' )

function DrawBlind()
	if !LocalPlayer():GetNWBool( "isblind" ) then return end
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, ScrW(), ScrH() )
end
hook.Add( "HUDPaint", "DrawBlind", DrawBlind )


function GM:HUDDrawTargetID()

end


