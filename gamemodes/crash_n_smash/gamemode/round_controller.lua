
function GM:OnPreRoundStart( num )

	// Call Fretta base function
	self.BaseClass:OnPreRoundStart( num )
	
	SetGlobalBool( "CanStartYet", true )
	
	// Reset all references since OnPreRoundStart uses game.CleanUpMap
	self:SetupMapProps()
	BroadcastLua( "GAMEMODE:SetupMapProps()" )

	// Clear all score chains
	ClearChains()
	
	InitializeRoundScores()
	BroadcastLua( "InitializeRoundScores()" )
	
	for k, pl in pairs(player.GetAll()) do
		pl:ResetScores()
	end
	
	BroadcastLua( "GAMEMODE:OnRoundStartClient()" )
	
	// Start timer for powerup spawn
	timer.Destroy("powerupspawn")
	timer.Create("powerupspawn", 30, 1, GAMEMODE.CreatePowerup, GAMEMODE)
	
	PlayMusic( MUSIC_ROUNDSTART )
	
	// Reset a few vars
	self.NaggedAboutScore = false

end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	timer.Destroy("powerupspawn")
	
	UpdateTeamsPropCount()
	
	for k, pl in pairs(player.GetAll()) do
		pl:DropAbsorbedPlayer()
		pl:StripWeapons()
		pl:GodEnable()
	end
	
	local redscore = team.GetScore( TEAM_RED ) // duplicate values of the TotalPropValue but whatever
	local bluescore = team.GetScore( TEAM_BLUE )
	
	if bluescore > redscore then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
	elseif redscore > bluescore then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
	else
		GAMEMODE:RoundEndWithResult( -1, "It's a draw!" )
	end

	GAMEMODE:SendTopRoundScores()
	
end

function GM:OnRoundResult( result, resulttext )

	if result == -1 then
		PlayMusic( MUSIC_ROUNDLOSE )	
	else
		if result == TEAM_BLUE then
			PlayMusic( MUSIC_ROUNDWIN, team.GetPlayers( TEAM_BLUE ) )
			PlayMusic( MUSIC_ROUNDLOSE, team.GetPlayers( TEAM_RED ) )
		elseif result == TEAM_RED then
			PlayMusic( MUSIC_ROUNDWIN, team.GetPlayers( TEAM_RED ) )
			PlayMusic( MUSIC_ROUNDLOSE, team.GetPlayers( TEAM_BLUE ) )
		end
	end

end

function GM:CanStartRound( iNum )

	local required = self.PlayersPerTeamRequiredBeforeRoundCanStart
	local result = team.NumPlayers(TEAM_RED) >= required and team.NumPlayers(TEAM_BLUE) >= required
	
	SetGlobalBool( "CanStartYet", result )
	return result
	
end

function GM:SendTopRoundScores()

	for k, pl in pairs(player.GetAll()) do
		if pl.PropsBroken then // check if score was initialized
			if !scoreinfo.MostPropsBroken.player or scoreinfo.MostPropsBroken.score < pl.PropsBroken then
				scoreinfo.MostPropsBroken.player = pl:Name()
				scoreinfo.MostPropsBroken.score = pl.PropsBroken
				scoreinfo.MostPropsBroken.team = pl:Team()
			end
			if !scoreinfo.MostPlayersLaunched.player or scoreinfo.MostPlayersLaunched.score < pl.PlayersLaunched then
				scoreinfo.MostPlayersLaunched.player = pl:Name()
				scoreinfo.MostPlayersLaunched.score = pl.PlayersLaunched
				scoreinfo.MostPlayersLaunched.team = pl:Team()
			end		
			if !scoreinfo.MostPoints.player or scoreinfo.MostPoints.score < pl:GetPoints() then
				scoreinfo.MostPoints.player = pl:Name()
				scoreinfo.MostPoints.score = pl:GetPoints()
				scoreinfo.MostPoints.team = pl:Team()
			end		
			if !scoreinfo.MostAssistPoints.player or scoreinfo.MostAssistPoints.score < pl:GetAssistPoints() then
				scoreinfo.MostAssistPoints.player = pl:Name()
				scoreinfo.MostAssistPoints.score = pl:GetAssistPoints()
				scoreinfo.MostAssistPoints.team = pl:Team()
			end
			if !scoreinfo.MostKills.player or scoreinfo.MostKills.score < pl:Frags() then
				scoreinfo.MostKills.player = pl:Name()
				scoreinfo.MostKills.score = pl:Frags()
				scoreinfo.MostKills.team = pl:Team()
			end
			if !scoreinfo.MostFallDamage.player or scoreinfo.MostFallDamage.score < pl.TotalFallDamage then
				scoreinfo.MostFallDamage.player = pl:Name()
				scoreinfo.MostFallDamage.score = pl.TotalFallDamage
				scoreinfo.MostFallDamage.team = pl:Team()
			end
			if !scoreinfo.PropsBrokenChainRecord.player or scoreinfo.PropsBrokenChainRecord.score < pl.PropsBrokenChainRecord then
				scoreinfo.PropsBrokenChainRecord.player = pl:Name()
				scoreinfo.PropsBrokenChainRecord.score = pl.PropsBrokenChainRecord
				scoreinfo.PropsBrokenChainRecord.team = pl:Team()
			end
		end
	end

	umsg.Start("toproundscores")
		umsg.String(scoreinfo.MostPropsBroken.player)
		umsg.Short(scoreinfo.MostPropsBroken.score)
		umsg.Short(scoreinfo.MostPropsBroken.team)
		umsg.String(scoreinfo.MostPlayersLaunched.player)
		umsg.Short(scoreinfo.MostPlayersLaunched.score)
		umsg.Short(scoreinfo.MostPlayersLaunched.team)
		umsg.String(scoreinfo.MostPoints.player)
		umsg.Short(scoreinfo.MostPoints.score)
		umsg.Short(scoreinfo.MostPoints.team)
		umsg.String(scoreinfo.MostAssistPoints.player)
		umsg.Short(scoreinfo.MostAssistPoints.score)
		umsg.Short(scoreinfo.MostAssistPoints.team)
		umsg.String(scoreinfo.MostKills.player)
		umsg.Short(scoreinfo.MostKills.score)
		umsg.Short(scoreinfo.MostKills.team)
	umsg.End()
	
	// Split up usermessages so we prevent them from becoming larger than 255 bytes
	umsg.Start("toproundscores2")
		umsg.String(scoreinfo.MostFallDamage.player)
		umsg.Short(scoreinfo.MostFallDamage.score)
		umsg.Short(scoreinfo.MostFallDamage.team)
		umsg.String(scoreinfo.PropsBrokenChainRecord.player)
		umsg.Short(scoreinfo.PropsBrokenChainRecord.score)
		umsg.Short(scoreinfo.PropsBrokenChainRecord.team)
		umsg.Short(scoreinfo.LongestChain.numplayers)
		umsg.Short(scoreinfo.LongestChain.team)
		for k, v in pairs(scoreinfo.LongestChain.players) do
			umsg.String(v)
		end
	umsg.End()
	

end

