MAP.FriendlyName = "Inferno";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 2568.2297363281, 1118.8552246094, 210.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( -549.90319824219, 707.345703125, 18.03125 ) );
	end
end
