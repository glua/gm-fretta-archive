
ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
end
 
function ENT:KeyValue( key, value )
end

function ENT:StartTouch( ent )

	if ( ent:IsPlayer() and ent:Team() == TEAM_RUNNER ) then
	
		ent:SetGroundEntity( NULL )
		//ent:SetVelocity( ( ent:GetVelocity() - Vector( 0, 0, ent:GetVelocity().z ) ) + ( vector_up * 1000 ) )
		ent:SetVelocity( vector_up * 1000 )
		ent:EmitSound( "gmaster/launch.wav" )
		
		local efdata = EffectData()
		efdata:SetEntity( ent )
		efdata:SetOrigin( ent:GetPos() ) //Needed to make clients actually see the effect
		util.Effect( "player_launch", efdata, true, true ) 
		
	end
	
end