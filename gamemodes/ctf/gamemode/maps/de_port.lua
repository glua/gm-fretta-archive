MAP.FriendlyName = "Port";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 1719.9056396484, 395.77377319336, 740.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( -1266.447265625, -1123.5992431641, 613.34741210938 ) );
	end
end
