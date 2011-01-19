function GM:PitFallOnRoundStart()
	if( SERVER ) then
		GAMEMODE:SpawnPlatforms(Vector(-872.281250, -880.406250, -135.500000))
	end
end

