
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()

end

function ENT:Think()
 	
end

function ENT:Draw()

	self.Entity:DrawModel()
	
end