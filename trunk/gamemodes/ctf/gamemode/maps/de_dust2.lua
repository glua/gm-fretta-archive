MAP.FriendlyName = "Dust 2";

function MAP:SpawnEntities()
	if( SERVER ) then
		self:SpawnFlag( TEAM_BLUE, Vector( 1402.3370361328, 2525.2717285156, 111.68321228027 ) );
		self:SpawnFlag( TEAM_RED, Vector( -1918.9309082031, -312.02813720703, 97.579284667969 ) );
	end
end
