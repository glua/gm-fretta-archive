MAP.FriendlyName = "Havana";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 163.82949829102, -882.69818115234, 50.03125 ) );
		self:SpawnFlag( TEAM_RED, Vector( 187.28407287598, 1357.0478515625, 298.03125 ) );
	end
end
