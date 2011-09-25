
ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
end
 
function ENT:KeyValue( key, value )

	if ( key == "string" ) then self.Entity:SetNWString( "String", value ) end
	
end

function ENT:StartTouch( ent )
	
	if ( !ent:IsPlayer() or ent:Team() != TEAM_RUNNER or !ent:Alive() ) then return end

	umsg.Start( "Help", ent )
		umsg.String( self.Entity:GetNWString( "String", "" ) )
	umsg.End()
	
end