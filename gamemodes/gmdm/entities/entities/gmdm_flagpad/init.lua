AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Team = TEAM_UNASSIGNED;

function ENT:Initialize()

	self.Entity:SetModel( "models/props_lab/tpplug.mdl" );
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	
	self.Entity:SetCollisionBounds( Vector( -16, -16, 0 ), Vector( 16, 16, 76 ) )
	self.Entity:PhysicsInitBox( Vector( -16, -16, 0 ), Vector( 16, 32, 16 ) )

	self.Entity:GetPhysicsObject():EnableGravity(false)
	
	self.Entity:DrawShadow( false )

end

function ENT:SpawnFlag()

end

function ENT:KeyValue( key, value )
	if ( key == "team" ) then
		self.Team = tonumber( value );
	end
end

function ENT:Touch( entity )

end
