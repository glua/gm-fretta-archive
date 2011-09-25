	
ENT.Type 		= "anim"

AddCSLuaFile( "shared.lua" )


function ENT:Initialize()

	self.Entity:SetModel("models/roller.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end	
end

