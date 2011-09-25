MAP.FriendlyName = "Chateau";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 1529.2761230469, 2003.4294433594, 50.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( 1661.0435791016, -501.02041625977, -109.96875 ) );
	end
end
