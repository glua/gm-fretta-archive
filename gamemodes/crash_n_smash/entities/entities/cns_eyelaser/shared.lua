
ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Clavus"
ENT.Purpose			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:GetHitPos()

	return self:GetNWVector( "hitpos", self.Entity:GetPos() )

end

function ENT:SetHitPos( pos )

	self:SetNWVector( "hitpos", pos )

end