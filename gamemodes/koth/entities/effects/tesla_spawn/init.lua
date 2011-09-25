
function EFFECT:Init( d )

	self.Pos = d:GetOrigin()
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Pos
		dlight.r = 200
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 3
		dlight.Decay = 2048
		dlight.size = 512 * math.Rand( 0.5, 1.0 )
		dlight.DieTime = CurTime() + 1
		
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end