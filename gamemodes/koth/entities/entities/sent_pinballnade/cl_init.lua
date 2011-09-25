include('shared.lua')

function ENT:Initialize()
	
	self.Refract = 0
	
end

function ENT:Think()

end

local matFlare = Material( "effects/yellowflare" )
local matRefraction	= Material( "refract_ring" )

function ENT:Draw()

	self.Entity:DrawModel()
	
	if not ValidEntity( self.Entity:GetOwner() ) then return end
	
	self.Refract = self.Refract + 1.001 * FrameTime()
	
	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	
	render.DrawSprite( self.Entity:LocalToWorld( self.Entity:OBBCenter() ), 20, 20, Color( 255, 255, 255, 255 ) )
	
	local color = team.GetColor( self.Entity:GetOwner():Team() )
	local vel = self.Entity:GetVelocity()	
	
	render.SetMaterial( matFlare )
	
	if ( vel:Length() > 1 ) then
	
		for i = 1, 10 do
		
			local col = Color( color.r, color.g, color.b, 200 / i )
			render.DrawSprite( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + vel * ( i * -0.005 ), 15 - i, 15 - i, col )
		
		end
	
	end
	
end

