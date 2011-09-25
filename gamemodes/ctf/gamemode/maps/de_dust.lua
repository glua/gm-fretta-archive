MAP.FriendlyName = "Dust";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -371.91186523438, -181.92413330078, 49.999992370605 ) );
		self:SpawnFlag( TEAM_RED, Vector( 652.138671875, 2631.3803710938, 50 ) );
	end
end
