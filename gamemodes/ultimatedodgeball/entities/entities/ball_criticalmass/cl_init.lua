
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local matRefraction	= Material( "effects/strider_pinch_dudv" )

function ENT:Initialize()
	self.Refract = 0
	self.Size = 120
	self.Entity:SetRenderBounds( Vector()*-512, Vector()*512 )
end

function ENT:Draw()

	self.Entity:DrawModel()
	
	local size = math.Clamp(TimedSin(0.8,50,200,0),50,200)
	render.SetMaterial( Material("effects/blueflare1") )
    render.DrawSprite( self.Entity:GetPos(), size, size, Color(0, 0, 0, 250) ) 
	
	self.Refract = self.Refract + 1.001 * FrameTime()
	
	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	
	size = math.Clamp(TimedSin(0.8,150,300,0),150,300)
	render.DrawSprite( self.Entity:GetPos(), size, size )
	
end
	