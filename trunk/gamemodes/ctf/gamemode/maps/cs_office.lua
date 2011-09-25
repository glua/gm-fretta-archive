MAP.FriendlyName = "Office";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 115.80953979492, -1668.1354980469, -285.96875 ) );
		self:SpawnFlag( TEAM_RED, Vector( 996.99267578125, 970.40612792969, -109.96875 ) );
	end
end
