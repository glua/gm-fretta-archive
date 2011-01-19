MAP.FriendlyName = game.GetMap();

MAP.RemoveItems = true;
MAP.RemoveSpawns = false;

MAP.SpawnClasses = {}
MAP.SpawnClasses[ TEAM_RED ] = "info_player_terrorist";
MAP.SpawnClasses[ TEAM_BLUE ] = "info_player_counterterrorist";
MAP.SpawnClasses[ TEAM_UNASSIGNED ] = "info_player_deathmatch";

function MAP:AddSpawn( team, origin, angle )

	if( !self.SpawnClasses[ team ] ) then return end
	
	if( !angle ) then
		angle = Angle( 0, 0, 0 )
	end
	
	local ent = ents.Create( self.SpawnClasses[ team ] );
	ent:SetPos( origin );
	ent:SetAngles( angle );
	ent:Spawn();
	
end

function MAP:AddPickup( origin, pickup )

	local ent = ents.Create( "gmdm_pickup" );
	ent:SetPos( origin );
	ent:SetKeyValue( "item", pickup );
	ent:Spawn();
	
end

function MAP:RemoveEntByClass( class ) 
	
	Msg( "Removing all " .. class .. " from map\n" );
	local ents = ents.FindByClass( class );
	local numents = #ents;
	
	if( numents < 1 ) then
		Msg( "No ents found.\n" );
	else
		for k, v in pairs( ents ) do
			Msg( "Removed " .. v:GetClass() .. " at " .. tostring( v:GetPos() ) .. "\n");
			v:Remove();
		end
	end
	
end

function MAP:SpawnEntities()
	if( SERVER ) then
		self:DoSpawns()
	end
end

function MAP:DoSpawns()

end

function GetAbsPos( pl, command, args )
	if( pl and pl:IsValid() ) then
		local pos = pl:GetPos();
		local ang = pl:GetAngles();
		
		pl:PrintMessage( HUD_PRINTCONSOLE, "origin: " .. tostring( pos ) .. "\nangles: " ..  tostring( ang ) ..  "\nVector( " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. " ), Angle( " .. ang.p .. ", " .. ang.y .. ", " .. ang.r .. " )\n" );
	end
end

concommand.Add( "printabspos", GetAbsPos );