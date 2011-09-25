function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -1613.9459228516, -557.50952148438, -359.12835693359 ) );
		self:SpawnFlag( TEAM_RED, Vector( 1157.5811767578, 1530.4517822266, -247.18844604492 ) );
	end
end