function GM:Initialize()
	// If we're round based, wait 5 seconds before the first round starts
	if GAMEMODE.RoundBased then
		timer.Create( "AttemptStartFirstRound", 1, 0, function() GAMEMODE:AttemptStartRoundBasedGame() end )
	end
	
	if GAMEMODE.AutomaticTeamBalance then
		timer.Create( "CheckTeamBalance", 30, 0, function() GAMEMODE:CheckTeamBalance() end )
	end
end

function GM:OnPreRoundStart (num)
	game.CleanUpMap()
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	--UTIL_FreezeAllPlayers()
	
	hook.Call ("OnPreRoundStart", nil, num)
end

function GM:OnRoundStart (num)
	for _,ent in pairs (ents.FindByName ("spawndoor")) do
		ent:Fire ("Open", "", 0)
	end
	umsg.Start ("lnl_roundstart")
	umsg.End()
	--UTIL_UnFreezeAllPlayers()
	hook.Call ("OnRoundStart", nil, num)
end

function GM:OnRoundEnd (num)
	for k,v in pairs(player.GetAll()) do
		if v:Team() != self.CaptureZoneTeam then
			v:StripWeapons()
		end
	end
	hook.Call ("OnRoundEnd", nil, num)
end

function GM:AttemptStartRoundBasedGame()
	if team.NumPlayers(1) > 0 or team.NumPlayers(2) > 0 then
		self:StartRoundBasedGame()
		timer.Destroy ("AttemptStartFirstRound")
	end
end

function GM:RoundTimerEnd()
	if not GAMEMODE:InRound() then return end
	if (self.CaptureZoneTeam or -1) == -1 then
		GAMEMODE:RoundEndWithResult (-1, "Time Up")
	else
		GAMEMODE:RoundEndWithResult (self.CaptureZoneTeam)
	end
end