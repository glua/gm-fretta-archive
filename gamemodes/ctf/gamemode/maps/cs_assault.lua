MAP.FriendlyName = "Assault";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 6736.1723632813, 6816.9780273438, -837.11407470703 ) );
		self:SpawnFlag( TEAM_RED, Vector( 5217.5639648438, 4691.2602539063, -781.96875 ) );
	end
end
