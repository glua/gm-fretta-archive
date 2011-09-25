
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

// Global to track the number of active fires
NUM_FIRES 		= 0
MAX_NUM_FIRES 	= 128

function ENT:RemoveMe()

	if (!self.Entity) then return end
	if (self.Entity == NULL) then return end

	self.Entity:Remove()

end


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:DrawShadow( false )

	// Make the bbox short so we can jump over it
	// Note that we need a physics object to make it call triggers
	self.Entity:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	self.Entity:PhysicsInitBox( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions( false )		
	end
	
	local Time = mathx.Rand( 9, 10 )
	timer.Simple( Time, self.RemoveMe, self )
	
	self.Entity:SetNetworkedFloat( 0, CurTime() + Time )
	
	NUM_FIRES = NUM_FIRES + 1
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	
end

/*---------------------------------------------------------
   Name: OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
	NUM_FIRES = NUM_FIRES - 1
end


/*---------------------------------------------------------
   Name: Touch
---------------------------------------------------------*/
function ENT:Touch( entity )
	entity:Ignite(5,20)
end

include('shared.lua')