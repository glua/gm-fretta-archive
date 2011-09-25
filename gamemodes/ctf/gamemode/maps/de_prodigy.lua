MAP.FriendlyName = "Prodigy";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 893.28125, -972.29748535156, -349.96875 ) );
		self:SpawnFlag( TEAM_RED, Vector( 3153.3015136719, 554.84112548828, -333.96875 ) );
	end
end
