function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -1103.5230712891, -172.31187438965, -306 ) );
		self:SpawnFlag( TEAM_RED, Vector( 1804.5103759766, -553.03637695313, -309.86749267578 ) );
	end
end