function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 101.57582092285, -1461.4304199219, 34.325744628906 ) );
		self:SpawnFlag( TEAM_RED, Vector( 119.61610412598, 2105.4499511719, 37.601440429688 ) );
	end
end