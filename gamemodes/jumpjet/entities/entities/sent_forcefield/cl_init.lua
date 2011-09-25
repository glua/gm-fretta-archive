include('shared.lua')

function ENT:Initialize()
	
end

function ENT:Think()

end

local matField = Material( "jumpjet/ring" )

function ENT:Draw()

	if not ValidEntity( self.Entity:GetOwner() ) then return end
	
	local size = 200 + math.sin( CurTime() * 10 ) * 10
	
	render.SetMaterial( matField )
	render.DrawQuadEasy(  self.Entity:GetOwner():GetPos() + Vector(0,0,30), Vector(1,0,0), size, size, Color( 255, 255, 255, 100 ) )
	
end

