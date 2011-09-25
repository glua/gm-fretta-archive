AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );

include( "shared.lua" );

ENT.Team = TEAM_RED;

function ENT:Initialize()
	
	self:SetModel( "models/Roller.mdl" ); -- tea pot for now
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local phys = self.Entity:GetPhysicsObject() 
	
	if( phys and phys:IsValid() ) then
		phys:Wake();
	end
	
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER );
	
	self:SetColor( 255, 255, 255, 255 );
	
	self:SetNetworkedInt( "team", self.Team );
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end


function ENT:StartTouch( ent )

	if( ent and ent:IsValid() and ent:IsPlayer() and ent:Team() != TEAM_SPECTATE and ent:Team() != TEAM_UNASSIGNED ) then
	
		local flag = GetGlobalEntity( "flag_" .. tostring( self.Team ) );
		
		if( flag and flag:IsValid() ) then
			if( ent:Team() == self.Team ) then
				flag:FlagReturned( ent );
				flag:SetNetworkedBool( "dropped", false );
				self:Remove();
			elseif( ent:Team() != self.Team ) then
				flag:SetNetworkedEntity( "carrier", ent );
				flag:SetNetworkedBool( "dropped", false );
				self:Remove();
				
				--PrintMessage( HUD_PRINTCENTER, ent:Name() .. " picked up the dropped " .. team.GetName( self.Team ) .. " flag" );
				GAMEMODE:AddFlagMessage( ent, ent:Team(), self.Team, "picked up" );
			end
		end
	end
	
end

function ENT:KeyValue( key, value )

	if( key == "team" ) then
		local team = tonumber( value );
		self.Team = team;
	end
end
