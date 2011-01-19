include('shared.lua')

util.PrecacheModel("models/crossbow_bolt.mdl")

function ENT:Initialize()

end

function ENT:Think()

end

ENT.GlowMat = Material("effects/blueflare1")

function ENT:Draw()

	self:SetModel( "models/crossbow_bolt.mdl" )
	self.Entity:DrawModel()
	
	render.SetMaterial( self.GlowMat )
	render.DrawSprite( self.Entity:GetPos(), 5, 5, Color( 255, 0, 0, 255 ) ) 
	
end

