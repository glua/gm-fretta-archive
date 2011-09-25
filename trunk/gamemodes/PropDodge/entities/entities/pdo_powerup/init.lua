AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:StartTouch( ent )

	print( "powerup: StartTouch()" )

	if( !ent:IsPlayer() ) then
	
		self.Entity.reverse = false
		return
	
	end
	
	if( !self.Entity.reverse ) then
	
		self.Entity.ontouch( self.Entity, ent )
		
	else
	
		self.Entity.onreverse( self.Entity, ent, self.Entity.revply )
		
	end
	
	self.Entity:Remove()

end

function ENT:PhysicsCollide( physd, physobj )

	if( !physd.HitEntity:IsPlayer() ) then
	
		self.Entity.reverse = false
		return
	
	end

end

function ENT:Initialize()

	print( "pdo_powerup initialized!" )

	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity.reverse = false
	self.Entity.revply = nil
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
end