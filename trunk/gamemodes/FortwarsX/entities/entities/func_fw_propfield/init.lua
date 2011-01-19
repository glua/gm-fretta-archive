
ENT.Base = "base_brush"
ENT.Type = "brush"
 
function ENT:KeyValue( key, value )
	if ( key == "team" ) then
		self.Entity:SetNWInt( "Team", value )
	end
end

function ENT:Touch( ent )
	
	if ( ent:GetClass() != "fw_prop" ) then return end
	
	local owner = ent:GetNWEntity( "Owner" )
	if ( !ValidEntity( owner ) ) then return end
	
	local tm = tonumber( self.Entity:GetNWInt( "Team" ) )
	local etm = tonumber( owner:Team() )
	
	if ( etm != tm ) then
		ent:TakeDamage( ent:GetNWInt( "HP", 9999999 ) )
	end
	
end