include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self:PhysicsInit( SOLID_NONE );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_BSP );
	
	local min, max = self:WorldSpaceAABB();
	self.Pos = ( min + max ) / 2;
	
end

function ENT:StartTouch( ent )
	
	if( ent:IsPlayer() ) then
		
		ent:Win();
		
	end
	
end
