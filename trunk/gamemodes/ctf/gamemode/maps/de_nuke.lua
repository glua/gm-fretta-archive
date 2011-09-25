MAP.FriendlyName = "Nuke";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 1983.8594970703, -383.74041748047, -301.96875 ) );
		self:SpawnFlag( TEAM_RED, Vector( -950.513671875, -1064.1429443359, -366.70355224609 ) );
	end
end
