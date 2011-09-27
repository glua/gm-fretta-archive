include ('shared.lua')

ENT.GlowMat = Material("effects/yellowflare")

util.PrecacheModel ("models/crossbow_bolt.mdl")

function ENT:Draw()
	self:UpdateColor ()
	
	self:SetModel ("models/crossbow_bolt.mdl")
	self.Entity:DrawModel()
	
	render.SetMaterial (self.GlowMat)
	render.DrawSprite (self.Entity:GetPos(), 4, 4, self.Color)
end