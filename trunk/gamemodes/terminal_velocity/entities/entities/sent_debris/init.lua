AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:ApplyForceCenter( VectorRand() * 5000 )
		phys:AddAngleVelocity( Angle( math.random( -1000,1000 ), math.random( -1000, 1000 ), math.random( -1000, 1000 ) ) )
	
	end
	
	self.RemoveTime = CurTime() + 30
	
end

function ENT:Think()

	if self.RemoveTime < CurTime() then 
	
		self.Entity:Remove()
	
	end

end

function ENT:PhysicsCollide( phys, delta )

end

function ENT:OnRemove()
	
end
