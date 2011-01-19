include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( table.Random( GIB_MODELS ) );
	self:SetMaterial( "models/flesh" );
	self:SetColor( 79, 234, 255, 255 );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	
	local phy = self:GetPhysicsObject();
	phy:Wake();
	
	if( player.GetAll()[1] ) then
		
		construct.SetPhysProp( player.GetAll()[1], self, 0, nil, { GravityToggle = 1, Material = "ice" } );
		
	else
		
		self:Remove();
		
	end
	
	self:Fire( "addoutput", "minhealthdmg 999999", 0 );
	
end

function ENT:PhysicsCollide( data, phys )
	
	if( data.DeltaTime > 0.2 ) then
		
		self:EmitSound( Sound( "physics/glass/glass_sheet_impact_hard" .. tostring( math.random( 1, 3 ) ) .. ".wav" ) );
		
	end
	
end
