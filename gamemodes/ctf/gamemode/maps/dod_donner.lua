function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -2491.0654296875, -1586.6431884766, -93.21369934082 ) );
		self:SpawnFlag( TEAM_RED, Vector( 1695.6850585938, -639.74951171875, -70.730461120605 ) );
	end
end