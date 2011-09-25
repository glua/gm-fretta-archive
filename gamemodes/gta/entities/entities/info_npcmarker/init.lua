
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:DrawShadow( false )

	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	
end

function ENT:Think()
	
end
 
function ENT:OnTakeDamage( dmg )
	
end

function ENT:PhysicsCollide( data, phys )

end
