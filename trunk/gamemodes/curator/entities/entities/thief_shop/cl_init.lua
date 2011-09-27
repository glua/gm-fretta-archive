
include('shared.lua')
--[[
function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
end]]

function ENT:Draw()
	self:DrawModel()
end
 

function ENT:DrawTranslucent()

	self:Draw()
 
end