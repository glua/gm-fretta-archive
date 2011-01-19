function GM:PitFallOnRoundStart()
	if( SERVER ) then
		GAMEMODE:SpawnPlatforms(Vector(0, 0, 1500))
	end
end

