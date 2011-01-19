
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:DrawShadow( false )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
	
	end
	
	self.DieTime = CurTime() + 5
	
end

function ENT:Think()

	if self.DieTime < CurTime() or not ValidEntity( self.Entity:GetOwner() ) or not self.Entity:GetOwner():Alive() then
	
		self.Entity:Remove()
	
	end

end

function ENT:OnRemove()

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

