
include('shared.lua')

function ENT:Initialize()

end

function ENT:OnRemove()

end

function ENT:Think()

end

function ENT:Draw()

	if ValidEntity( self.Entity:GetOwner() ) and self.Entity:GetOwner() == LocalPlayer() then return end

	self.Entity:DrawModel()
	
end
	