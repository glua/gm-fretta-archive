MAP.FriendlyName = "Militia";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 1978.0252685547, -2094.5842285156, -109.96875 ) );
		self:SpawnFlag( TEAM_RED, Vector( 528.94903564453, 1814.7509765625, -109.96875 ) );
	end
end
