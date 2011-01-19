
function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	
	if LocalPlayer():GetPos():Distance( self.Pos ) > 50 or LocalPlayer():Team() == TEAM_STALKER then return end

	DisorientTime = CurTime() + 10
	ViewWobble = 0.5
	MotionBlur = 0.5
	Sharpen = 6.5
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end