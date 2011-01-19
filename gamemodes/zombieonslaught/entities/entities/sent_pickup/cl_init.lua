
include('shared.lua')

function ENT:Initialize()

end

ENT.GlowMat = Material("effects/blueflare1")

function ENT:Draw()

	if LocalPlayer():Team() == TEAM_DEAD then return end

	self.Entity:DrawModel()
	
	local center = self.Entity:LocalToWorld( self.Entity:OBBCenter() )

	local color = Color( 50, 255, 50, 255 )
	local maxsize = self.Entity:BoundingRadius() * 5
	local size = TimedSin( 0.8, 0, maxsize, 0 )
	
	render.SetMaterial( self.GlowMat )
	render.DrawSprite( center, size + 10, size + 10, color )
	
end

