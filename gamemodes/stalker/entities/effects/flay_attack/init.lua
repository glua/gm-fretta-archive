
function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	
	if LocalPlayer():GetPos():Distance( self.Pos ) > 50 or LocalPlayer():Team() == TEAM_HUMAN then return end
	
	ViewWobble = 0.75
	Sharpen = 5.5
	MotionBlur = 0.5
	ColorModify[ "$pp_colour_colour" ] = -1.0
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end