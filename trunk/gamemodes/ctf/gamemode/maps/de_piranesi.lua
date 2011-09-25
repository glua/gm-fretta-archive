MAP.FriendlyName = "Piranesi";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( -1580.2789306641, -259.54833984375, 210.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( 1906.1177978516, 563.15490722656, 306.03125 ) );
	end
end
