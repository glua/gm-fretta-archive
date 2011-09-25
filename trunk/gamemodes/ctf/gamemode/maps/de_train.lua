MAP.FriendlyName = "Train";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 1520.0279541016, -1719.3967285156, -273.96875 ) );
		self:SpawnFlag( TEAM_RED, Vector( -704.09301757813, 1043.9735107422, -165.96875 ) );
	end
end
