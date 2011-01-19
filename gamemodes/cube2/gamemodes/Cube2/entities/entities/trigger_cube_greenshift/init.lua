include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self:PhysicsInit( SOLID_NONE );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_NONE );
	
	local min, max = self:WorldSpaceAABB();
	self.Pos = ( min + max ) / 2;
	self.Min = min;
	self.Max = max;
	
	table.insert( CU_Spawnpoints, self.Pos );
	table.insert( CUBESHIFT.green, self );
	
end

function ENT:Think()
	
	
	
end
