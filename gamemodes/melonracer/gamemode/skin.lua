local SKIN = {}

surface.CreateFont( "coolvetica", 20, 500, true, true, "MelonScores" )
surface.CreateFont( "coolvetica", 12, 500, true, true, "MelonScoresHead" )

function SKIN:PaintListViewLine( panel )
	// Don't draw the alt-line background color
end

function SKIN:SchemeListViewLine( panel )
	for k, pnl in pairs( panel.Columns ) do
		pnl:SetFont( "MelonScores" )
		//if ( panel.m_bAlt ) then
		//	pnl:SetTextColor( Color( 255, 0, 0, 255 ) )
		//end
	end
end

function SKIN:SchemeListViewColumn( panel )
	panel.Header:SetFont( "MelonScoresHead" )
end

derma.DefineSkin( "melonracer", "", SKIN )