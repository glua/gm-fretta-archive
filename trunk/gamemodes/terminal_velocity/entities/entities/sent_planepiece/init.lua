AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:EnableGravity( false )
	
	end
	
end

function ENT:Think()

end

function ENT:PhysicsCollide( phys, delta )

end

function ENT:OnRemove()
	
end
