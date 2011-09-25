MAP.FriendlyName = "Aztec";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -2769.6584472656, -490.72476196289, -174.79719543457 ) );
		self:SpawnFlag( TEAM_RED, Vector( 2042.0672607422, -284.54559326172, -220.82723999023 ) );
	end
end
