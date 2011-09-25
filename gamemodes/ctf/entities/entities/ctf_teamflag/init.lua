AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );

include( "shared.lua" );

ENT.Team = TEAM_RED;
ENT.Stolen = false;
ENT.Dropped = false;
ENT.DroppedID = 0;

function ENT:Initialize()
	
	self:SetModel( "models/Roller.mdl" ); -- tea pot for now

	self:SetSolid( SOLID_BBOX );
	self:PhysicsInitBox( Vector( -0.5, -0.5, -0.5 ), Vector( 0.5, 0.5, 0.5 ) );
	self:SetMoveType( MOVETYPE_NONE );
	
	self:SetCollisionBounds( Vector( 0.5, 0.5, 0.5 ), Vector( 0.5, 0.5, 0.5 ) );
	
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	self:SetTrigger( true );
	
	GAMEMODE:SetTeamFlag( self.Team, self );
	
	self.Stolen = false;
	self.Dropped = false
	self:SetNetworkedBool( "stolen", false );
	self:SetNetworkedBool( "dropped", false );
	self:SetNetworkedEntity( "carrier", nil );
	
	self:SetColor( 255, 255, 255, 255 );
	
	self:SetNetworkedInt( "team", self.Team );
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end

function ENT:FlagStolen( pl )
	
	self:SetNetworkedBool( "stolen", true );
	self:SetNetworkedEntity( "carrier", pl );
	self:SetColor( 255, 255, 255, 50 );
	
	self.Stolen = true;
	
	local teamname = team.GetName( self.Team );
	--PrintMessage( HUD_PRINTCENTER, "Flag stolen from the " .. teamname .. " by " .. pl:Name() );
	GAMEMODE:AddFlagMessage( pl, pl:Team(), self.Team, "has stolen" );
	
	BroadcastLua( "LocalPlayer():EmitSound( \"HUDQuickInfo.LowHealth\" )" );
end

function ENT:FlagReturned( pl )

	self:SetNetworkedBool( "stolen", false );
	self:SetColor( 255, 255, 255, 255 );
	
	self.Stolen = false;
	
	if( pl and pl:IsValid() ) then
		local teamname = team.GetName( self.Team );
		--PrintMessage( HUD_PRINTCENTER, "The " .. teamname .. "'s flag returned by " .. pl:Name() );	
		
		GAMEMODE:AddFlagMessage( pl, pl:Team(), self.Team, "returned" );
		
		pl:AddFrags( 1 );
		
		BroadcastLua( "LocalPlayer():EmitSound( \"Buttons.snd9\" )" );
	end
	
end

function ENT:StartTouch( ent )

	if( ent and ent:IsValid() and ent:IsPlayer() ) then
	
		if( ent:Team() != self.Team and !self.Stolen ) then
			self:FlagStolen( ent );
		elseif( ent:Team() == self.Team and !self.Stolen ) then
			
			local enemy_flag = nil
			local enemy_team = TEAM_RED
			
			if( ent:Team() == TEAM_RED ) then
				enemy_flag = GetGlobalEntity( "flag_" .. tostring( TEAM_BLUE ) );
				enemy_team = TEAM_BLUE;
			else
				enemy_flag = GetGlobalEntity( "flag_" .. tostring( TEAM_RED ) );			
			end
			
			if( enemy_flag and enemy_flag:IsValid() ) then
				local stolen = enemy_flag:GetNetworkedBool( "stolen", false );
				local carrier = enemy_flag:GetNetworkedEntity( "carrier", nil );
				
				if( stolen and carrier and carrier:IsValid() and carrier == ent ) then
					local teamname = team.GetName( enemy_team );
					
					--PrintMessage( HUD_PRINTCENTER, ent:Name() .. " captured the " ..teamname .. "'s flag" );
					
					GAMEMODE:AddFlagMessage( ent, ent:Team(), enemy_team, "captured" );
					
					team.AddScore( ent:Team(), 1 );
					ent:AddFrags( 5 );
					ent:SetNetworkedInt( "Captures", ent:GetNetworkedInt( "Captures" ) + 1 );
					
					if( team.GetScore( ent:Team() ) >= GAMEMODE.TeamScoreLimit ) then
						GAMEMODE:EndOfGame( true )
					end
					
					BroadcastLua( "LocalPlayer():EmitSound( \"Hud.EndRoundScored\" )" );
					enemy_flag:FlagReturned()
				end
			end
		end
		
	end
	
end

function ENT:FlagDropped( pl )

	local teamname = team.GetName( self:GetNetworkedInt( "team", 0 ) )
	--PrintMessage( HUD_PRINTCENTER, pl:Name() .. " dropped the " ..teamname .. "'s flag" );
	GAMEMODE:AddFlagMessage( pl, pl:Team(), self.Team, "dropped" );
					
	self:SetNetworkedBool( "dropped", true );
	self:SetNetworkedEntity( "carrier", NULL );
	self.Dropped = true;

	self.DroppedID = self.DroppedID + 1;
	self:SetNetworkedInt( "droppedid", self.DroppedID );
	
	self:SpawnDroppedFlag( pl );
	
	BroadcastLua( "LocalPlayer():EmitSound( \"Buttons.snd3\" )" );
end

function ENT:SpawnDroppedFlag( pl )

	local ent = ents.Create( "ctf_droppedflag" );
	ent:SetPos( pl:GetPos() + Vector( 0, 0, 50 ) );
	ent:SetKeyValue( "team", self.Team );
	ent:Spawn();
	ent:SetNetworkedInt( "droppedid", self.DroppedID );
	
	timer.Simple( 30, self.TimeOutReturn, self, self.DroppedID );
	self:SetNetworkedFloat( "returntime", CurTime() + 30 );
	
	SetGlobalEntity( "droppedflag_" .. tostring( self.Team ), ent );
	
end

function ENT:TimeOutReturn( droppedid )
	if( !self ) then Msg( "Invalid self on dropped return\n" ); return end

	if( droppedid == self.DroppedID and self:GetNetworkedBool( "dropped", false ) == true ) then
		local dropped = GetGlobalEntity( "droppedflag_" .. tostring( self.Team ) );
		
		if( ValidEntity( dropped ) ) then
			dropped:Remove();
			self:SetNetworkedBool( "dropped", false );
			self:FlagReturned()
			
			BroadcastLua( "LocalPlayer():EmitSound( \"Buttons.snd47\" )" );

			--local teamn = team.GetName( self.Team );
			--PrintMessage( HUD_PRINTCENTER, "The " .. teamn .. " flag was returned after being dropped for 30 seconds" );
			
			umsg.Start( "PlayerFlagAutoReturned" );
				umsg.Short( self.Team );
			umsg.End();
		end
	end
	
end


function ENT:KeyValue( key, value )

	if( key == "team" ) then
		local team = tonumber( value );
		self.Team = team;
		self:SetNetworkedInt( "team", self.Team );
	end
end

  
function SpawnFlag( pl, command, args )

	if( pl:IsAdmin() ) then
		Msg( "Spawning flag...\n" );
		
		local team = tonumber( args[1] );
		local eyeTrace = pl:GetEyeTrace();
		
		local pos = eyeTrace.HitPos + Vector( 0, 0, 50 );
		
		local ent = ents.Create( "ctf_teamflag" );
		ent:SetKeyValue( "team", team );
		ent:SetPos( pos );
		ent:Spawn()
		
		Msg( "Spawned at origin " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. "\n" );
	end
end

concommand.Add( "spawn_flag", SpawnFlag );
