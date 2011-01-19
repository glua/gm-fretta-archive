
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:DrawShadow( false )
	
	// Make the bbox short so we can jump over it
	// Note that we need a physics object to make it call triggers
	self.Entity:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	self.Entity:PhysicsInitBox( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions( false )		
	end
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	
	self:SetActiveTime( 0 )
	self:DropToFloor( )
	
end

/*---------------------------------------------------------
   Name: OnRemove
---------------------------------------------------------*/
function ENT:KeyValue( key, value )
	if ( key == "item" ) then
		self:SetPickupType( value )
	end
end


/*---------------------------------------------------------
   Name: Touch
---------------------------------------------------------*/
function ENT:Touch( entity )

	if ( self:GetActiveTime() > CurTime() ) then return end
	if (!entity:IsPlayer()) then return end
	
	entity:Give( self:GetPickupName() );
	self:DoAmmoGive( entity );
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetEntity( entity )
	util.Effect( "pickup", effectdata, true, true ) // Allow override, Ignore prediction
	
	local RespawnTime = 5
	
	self:SetActiveTime( CurTime() + RespawnTime )
	
	local f = function ( pos )
	
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "itemrespawn", effectdata )
	
	end
	
	timer.Simple( RespawnTime, f, self.Entity:GetPos() )	

end

