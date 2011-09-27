function GM:OnPreRoundStart (num)
	game.CleanUpMap()
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	hook.Call ("OnPreRoundStart", nil, num)
end

function GM:OnRoundStart (num)
	UTIL_UnFreezeAllPlayers()
	hook.Call ("OnRoundStart", nil, num)
end

function GM:OnRoundEnd (num)
	hook.Call ("OnRoundEnd", nil, num)
end