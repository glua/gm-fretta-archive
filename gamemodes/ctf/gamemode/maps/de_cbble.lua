MAP.FriendlyName = "Cbble";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -2315.8098144531, -1013.2125244141, 50.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( 386.83657836914, 2240.0090332031, 82.03125 ) );
	end
end
