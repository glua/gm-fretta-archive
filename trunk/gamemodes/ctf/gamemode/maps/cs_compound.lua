MAP.FriendlyName = "Compound";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 1014.0660400391, 1393.5079345703, 50.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( 2258.3017578125, -1182.8684082031, 51.046928405762 ) );
	end
end
