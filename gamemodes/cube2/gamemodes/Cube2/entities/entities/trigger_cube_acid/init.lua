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

function ENT:AcceptInput( input )
	
	if( input == "Trigger" ) then
		
		local ents = ents.FindInBox( self.Min, self.Max );
		
		for _, v in pairs( ents ) do
			
			if( v:IsPlayer() and v:Alive() and not v.CanDieAcid ) then
				
				v.CanDieAcid = true;
				v:AcidDeath( self, self.CamPos, self.CamAng );
				
			end
			
		end
		
	end
	
end
