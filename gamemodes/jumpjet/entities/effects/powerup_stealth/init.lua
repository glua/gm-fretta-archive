
function EFFECT:Init( data )

	self.Ent = data:GetEntity()
	
	if not ValidEntity( self.Ent ) then return end
	
end

function EFFECT:Think( )

	if not ValidEntity( self.Ent ) or not self.Ent:Alive() then 
	
		return false 
		
	end
	
	if self.Ent == LocalPlayer() then
	
		ColorModify[ "$pp_colour_addb" ] = 0.15
	
	end

	return true
	
end

function EFFECT:Render()

end
