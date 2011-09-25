function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -1824.0725097656, -366.83731079102, 50.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( 1108.6248779297, -793.79870605469, 50.50708770752 ) );
	end
end