include('shared.lua')

ENT.Icon = Material("ware/nonc/ware_file")
ENT.Color  = Color(255,255,255,255)
ENT.Color2  = Color(0,0,0,255)
ENT.Size   = 28

ENT.A_RBWS = Vector(0,0,0)
ENT.B_RBWS = Vector(0,0,0)

function ENT:Initialize()
	if (CLIENT) then
		GC_VectorCopy(self.A_RBWS, self.Entity:GetPos())
		self.A_RBWS.x = self.A_RBWS.x - 128
		self.A_RBWS.y = self.A_RBWS.y - 128
		
		GC_VectorCopy(self.B_RBWS, self.Entity:GetPos())
		self.B_RBWS.x = self.B_RBWS.x + 128
		self.B_RBWS.y = self.B_RBWS.y + 128
		
		self.Entity:SetRenderBoundsWS(self.A_RBWS, self.B_RBWS)
	end
end

function ENT:Draw()		
	render.SetMaterial( self.Icon )
	render.DrawSprite( self:GetPos(), self.Size*1.1, self.Size*1.1, self.Color2 )
	render.DrawSprite( self:GetPos(), self.Size, self.Size, self.Color )
end
