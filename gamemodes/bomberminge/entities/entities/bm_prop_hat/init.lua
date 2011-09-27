include("shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	if not ValidEntity(self.Owner) then
		self:Remove()
		return
	end
	
	self:SetModel("models/props_junk/watermelon01.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetMultiModel("hat")
	self:SetPos(self.Owner:GetPos())
	self:SetParent(self.Owner)
	self:AttachToEntity(self.Owner, "ValveBiped.Bip01_Head1")
end
