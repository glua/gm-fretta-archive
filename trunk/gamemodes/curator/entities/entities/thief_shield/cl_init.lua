
include('shared.lua')

function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:Draw()
	self:DrawModel()
end
 

function ENT:DrawTranslucent()

	self:Draw()
 
end