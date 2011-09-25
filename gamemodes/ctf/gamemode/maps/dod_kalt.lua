function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 688.9189453125, 4028.5412597656, 118.55712127686 ) );
		self:SpawnFlag( TEAM_RED, Vector( 5100.9052734375, 3675.7150878906, 94.943878173828 ) );
	end
end