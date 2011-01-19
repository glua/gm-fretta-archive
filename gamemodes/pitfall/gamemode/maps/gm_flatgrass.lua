function GM:PitFallOnRoundStart()
	if( SERVER ) then
		GAMEMODE:SpawnPlatforms(Vector(990, -77, 2330))
	end
end

