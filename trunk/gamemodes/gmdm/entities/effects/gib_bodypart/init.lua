/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	// HumanGibs is defined in gamemode shared 
	// (because we need to precache the models on the server before we can use the physics)
	local iCount = table.Count( HumanGibs )
	
	// Use a random model from the gibs collection
	self.Entity:SetModel( HumanGibs[ math.random( iCount ) ] )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMaterial( "models/flesh" )
	
	// Only collide with world/static
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	// Add Velocity
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
	
		phys:Wake()
		phys:SetAngle( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:SetVelocity( data:GetNormal() * math.Rand( 100, 300 ) + VectorRand() * math.Rand( 100, 600 ) )
	
	end
	
	// Gib life time
	self.LifeTime = CurTime() + cl_gmdm_gibstaytime:GetFloat()
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	return self.LifeTime > CurTime()
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	self.Entity:DrawModel()

end

cl_gmdm_gibstaytime = CreateClientConVar( "cl_gmdm_gibstaytime", "20", true, false );

