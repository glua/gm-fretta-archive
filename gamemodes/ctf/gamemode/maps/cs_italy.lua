MAP.FriendlyName = "Italy";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -273.53009033203, -992.16845703125, -101.96875 ) );
		self:SpawnFlag( TEAM_RED, Vector( 920.62329101563, 2203.2312011719, 178.03125 ) );
	end
end
