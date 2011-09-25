MAP.FriendlyName = "Tides";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -533.09716796875, -1700.6380615234, 50.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( -229.7223815918, 713.4013671875, -45.761596679688 ) );
	end
end
