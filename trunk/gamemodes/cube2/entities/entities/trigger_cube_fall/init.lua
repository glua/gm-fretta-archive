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
	
end

function ENT:KeyValue( key, val )
	
	if( key == "camname" ) then
		
		timer.Simple( 5, function()
			
			self.CamPos = CubeCams[val].Pos;
			self.CamAng = CubeCams[val].Ang;
			
		end );
		
	end
	
end

function ENT:Think()
	
	local myEnts = ents.FindInBox( self.Min, self.Max );
	
	for _, v in pairs( myEnts ) do
		
		if( v:IsPlayer() and v:Alive() ) then
			
			v:SetCameraPos( self.CamPos, self.CamAng );
			
			if( not v:GetRagdollEntity() ) then
				
				umsg.Start( "ImFalling", v );
				umsg.End();
				
				v.Falling = true;
				v:CreateRagdoll();
				v:SetNoDraw( true );
				v:GetActiveWeapon():SetNoDraw( true );
				
			end
			
		elseif( v:GetClass() == "cube_boot" ) then
			
			v:Remove();
			
		end
		
	end
	
end
