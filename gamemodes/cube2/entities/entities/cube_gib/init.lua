include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( table.Random( GIB_MODELS ) );
	self:SetMaterial( "models/flesh" );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	
	local phy = self:GetPhysicsObject();
	phy:Wake();
	
	self:Fire( "addoutput", "minhealthdmg 999999", 0 );
	
	umsg.Start( "msgGibDrops" );
		umsg.Short( self:EntIndex() );
	umsg.End();
	
end

function ENT:PhysicsCollide( data, phys )
	
	if( data.DeltaTime > 0.2 ) then
		
		self:EmitSound( Sound( "Bounce.Flesh" ) );
		
	end
	
end
