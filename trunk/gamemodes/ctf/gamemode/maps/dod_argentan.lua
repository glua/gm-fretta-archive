function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -2114.8322753906, 49.42350769043, 59.489707946777 ) );
		self:SpawnFlag( TEAM_RED, Vector(  2068.9885253906, 113.58410644531, 249.09899902344 ) );
	end
end