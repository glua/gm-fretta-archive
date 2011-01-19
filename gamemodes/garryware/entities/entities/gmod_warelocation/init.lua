ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

function ENT:Initialize()
	self.Entity:PhysicsInitBox(Vector(-1,-1,-1), Vector(1,1,1))
	self.Entity:SetCollisionBounds(Vector(-1,-1,-1), Vector(1,1,1))
	self.Entity:SetNoDraw(true)
	self.Entity:SetMoveType(MOVETYPE_NONE)
end
