// This ent is the same as func_extractionpoint but is proximity based rather than using a Brush.

ENT.Type = "point";
ENT.Distance = 600;
ENT.NextThinkTime = 0;

function ENT:KeyValue( k, v )

	if( k == "Distance" ) then
		self.Distance = tonumber( v );
	end
	
end

function ENT:Initialize()
	SetGlobalEntity( "ExtractPoint", self.Entity );
	SetGlobalVector( "ExPoint_Pos", self:GetPos() + Vector( 0, 0, 76 ) );
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Think()

	if( CurTime() >= self.NextThinkTime ) then

		local breen = GetGlobalEntity( "Breen" );
		
		if( IsValid( breen ) and breen:Alive() ) then
			local origin = self:GetPos();
			local bb_dist = self.Distance;
			
			local mins = Vector( origin.x - bb_dist, origin.y - bb_dist, origin.z - bb_dist );
			local maxs = Vector( origin.x + bb_dist, origin.y + bb_dist, origin.z + bb_dist );
			
			local entities = ents.FindInBox( mins, maxs );
			
			for k, v in pairs( entities ) do
				if( ValidEntity( v ) and v == breen ) then
					GAMEMODE:Evacuated();
				end
			end
		end
		
		self.NextThinkTime = CurTime() + 0.5;
	end
	
end