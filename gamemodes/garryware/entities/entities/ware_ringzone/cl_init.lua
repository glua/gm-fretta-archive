include('shared.lua')

ENT.Circle = Material("sprites/sent_ball")
ENT.Color  = Color(185,220,255,255)
ENT.Size   = 128

ENT.SizeRB = 1024

ENT.A_RBWS = Vector(0,0,0)
ENT.B_RBWS = Vector(0,0,0)

ENT.NWVector = Vector(0,0,0)

function ENT:Initialize()
	if (CLIENT) then
		GC_VectorCopy(self.A_RBWS, self.Entity:GetPos())
		self.A_RBWS.x = self.A_RBWS.x - self.SizeRB
		self.A_RBWS.y = self.A_RBWS.y - self.SizeRB
		
		GC_VectorCopy(self.B_RBWS, self.Entity:GetPos())
		self.B_RBWS.x = self.B_RBWS.x + self.SizeRB
		self.B_RBWS.y = self.B_RBWS.y + self.SizeRB
		
		self.Entity:SetRenderBoundsWS(self.A_RBWS, self.B_RBWS)
	end
end

function ENT:Draw()
	self.NWVector = self:GetNWVector("dcolor")

	self.Color = Color(self.NWVector.x, self.NWVector.y, self.NWVector.z, 255)
	self.Size = self:GetNWInt("zsize", 64)
	
	render.SetMaterial( self.Circle )
	render.DrawQuadEasy( self:GetPos(), self:GetUp(), self.Size, self.Size, self.Color )
end
