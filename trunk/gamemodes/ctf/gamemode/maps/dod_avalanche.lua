function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 751.55108642578, -604.07867431641, -329.56573486328 ) );
		self:SpawnFlag( TEAM_RED, Vector(  -233.96878051758, 1655.3392333984, 175.28596496582 ) );
	end
end