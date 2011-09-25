include('shared.lua')

local matShine = Material( "effects/yellowflare" )

function ENT:Initialize()

	self.SpriteTime = CurTime() + 5
	
end

function ENT:Think()

end

function ENT:Draw()

	self.Entity:DrawModel()
	
	if self.SpriteTime < CurTime() then return end
	
	local size = 20 * ( ( self.SpriteTime - CurTime() ) / 5 )
	
	render.SetMaterial( matShine )
	render.DrawSprite( self.Entity:GetPos() + self.Entity:GetForward() * 5, size, size, Color( 255, 255, 255, 255 ) )
	
end

