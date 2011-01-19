include('shared.lua')

function ENT:Initialize()
	
end

function ENT:OnRemove()

end

function ENT:Think()
	
end

local matFlare = Material( "effects/blueflare1" )

function ENT:Draw()

	self.Entity:DrawModel()
	
	local size = 5
	
	render.SetMaterial( matFlare )
	render.DrawSprite( self.Entity:GetPos() + self.Entity:GetUp() * size, size, size, Color( 150, 150, 255, 50 ) ) 
	
end

