
function EFFECT:Init( data )

	self.LifeTime = CurTime() + 20
	self.Ent = data:GetEntity()
	
	if self.Ent:GetPos():Distance( LocalPlayer():GetPos() ) < 10 then
	
		ColorModify[ "$pp_colour_addr" ] = 0.3
	
	end
	
	self.Entity:SetParent( self.Ent )
	
end

function EFFECT:Think( )

	if not ValidEntity( self.Ent ) or not self.Ent:Alive() then return false end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	local pos = self.Ent:GetPos() + Vector( 0, 0, 50 )
	
	if self.Ent:KeyDown( IN_DUCK ) then
		pos = pos + Vector( 0, 0, -30 )
	end
	
	if dlight then//and self.Ent != LocalPlayer() then
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 0
		dlight.b = 0
		dlight.Brightness = 4
		dlight.Decay = 0
		dlight.size = 256
		dlight.DieTime = CurTime() + 0.1
	end

	return self.LifeTime > CurTime() 
	
end

function EFFECT:Render()

end
