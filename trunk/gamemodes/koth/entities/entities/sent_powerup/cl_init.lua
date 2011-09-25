include('shared.lua')

ENT.MatFlare = Material( "sprites/light_glow02_add" )
ENT.ModelScale = 0.4

function ENT:Initialize()

	local col = self.Entity:GetNWVector( "Color", Vector(0,0,255) )
	
	self.Col = Color( col.x, col.y, col.z, 255 )

end

function ENT:Think()

	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = self.Col.r
		dlight.g = self.Col.g
		dlight.b = self.Col.b
		dlight.Brightness = 2
		dlight.Decay = 0
		dlight.size = 512
		dlight.DieTime = CurTime() + 0.2
		
	end
	
	local dist = LocalPlayer():GetPos():Distance( self.Entity:GetPos() )
	
	if dist < 150 then
		
		local scale = 1 - ( dist / 150 )
		ColorModify[ "$pp_colour_mulr" ] = scale * 5 * ( self.Col.r / 255 )
		ColorModify[ "$pp_colour_mulg" ] = scale * 5 * ( self.Col.g / 255 )
		ColorModify[ "$pp_colour_mulb" ] = scale * 5 * ( self.Col.b / 255 )
		
	end
	
	self.ModelScale = 0.3 + math.sin( CurTime() * 4 ) * 0.1
	
end

function ENT:Draw()

	self.Entity:SetModelScale( Vector( self.ModelScale, self.ModelScale, self.ModelScale ) )
	self.Entity:DrawModel()
	
	local num = 1
	
	for i=3,15 do
	
		local sin, cos = math.sin( CurTime() * i ) * ( i * 2 ), math.cos( CurTime() * i ) * ( i * 2 )
		
		local pos = Vector( 0, cos, sin )
		if num == 1 then
			pos = Vector( sin, 0, cos )
		elseif num == 2 then
			pos = Vector( sin, cos, 0 )
		end
		
		num = num + 1
		if num > 3 then num = 1 end
		
		render.SetMaterial( self.MatFlare )
		render.DrawSprite( self.Entity:GetPos() + pos, 3, 3, self.Col )
		
	end
	
end

