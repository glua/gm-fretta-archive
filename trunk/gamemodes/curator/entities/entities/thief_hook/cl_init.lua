
include('shared.lua')

function ENT:OnRemove()
	
end 

function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
end