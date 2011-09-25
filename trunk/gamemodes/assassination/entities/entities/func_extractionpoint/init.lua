// When Breen touches this, he's got away
ENT.Type = "brush";

function ENT:StartTouch( ent )
	
	if( ValidEntity( ent ) && ent:IsPlayer() ) then
		local breen = GetGlobalEntity( "Breen" );
			
		if( IsValid( breen ) and breen:Alive() and ent == breen ) then
			GAMEMODE:Evacuated();
		end
	end

end

function ENT:Initialize()
	SetGlobalEntity( "ExtractPoint", self.Entity );
	SetGlobalVector( "ExPoint_Pos", self:LocalToWorld( self:OBBCenter() ) );
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
