function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 2512.8400878906, -673.15979003906, -286.29791259766 ) );
		self:SpawnFlag( TEAM_RED, Vector( 2927.5231933594, 1616.7690429688, -219.4118347168 ) );
	end
end