
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_lab/jar01a.mdl" )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionBounds( Vector( -200, -200, -200 ), Vector( 200, 200, 200 ) )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	self.Entity:SetTrigger( true )
	self.Entity:DrawShadow( false )	
	
	local phys = self.Entity:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:EnableCollisions( false )		
	end
	
	self.Entity:EmitSound( Sound("physics/flesh/flesh_bloody_break.wav"), 150, 90 )
	
	self.DieTime = CurTime() + 8
	self.Players = {}
	
end

function ENT:Think() 

	if self.DieTime < CurTime() then 
	
		self.Entity:Remove()
		
	end

end 

function ENT:Touch( ent )

	if ValidEntity( ent ) and ent:IsPlayer() and ent != self.Entity:GetOwner() and ent:Team() == TEAM_ALIVE and not table.HasValue( self.Players, ent ) then
	
		self.Entity:AddPlayer( ent )
		ent:DoPoison( self.Entity:GetOwner() )
	
	end

end

function ENT:AddPlayer( ent )

	table.insert( self.Players, ent )

end