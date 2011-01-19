function GM:PitFallOnRoundStart()
	if( SERVER ) then
		GAMEMODE:SpawnPlatforms(Vector(-760.308411, -666.573792, 444.655273))
	end
end

