

function GM:OnRoundResult( result, resulttext )

	// The fact that result might not be a team 
	// shouldn't matter when calling this..
	-- team.AddScore( result, 1 )
	
	for k,v in pairs( player.GetAll() ) do 
	
		if v:Team() == result then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )" )
		else
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )" )
		end
		
		v:SendLua( "GAMEMODE:ShowEndGameSplash( "..result.." )" )
		
	end
	
	UTIL_StripAllPlayers()

end


function GM:OnPreRoundStart( num )

	game.CleanUpMap()
	
	team.SetScore( TEAM_BLUE, 0 )
	team.SetScore( TEAM_YELLOW, 0 )
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	 -- Start us off with some props
	GAMEMODE:SpawnProps()
	GAMEMODE:SpawnProps()
	GAMEMODE:SpawnProps()
	GAMEMODE:SpawnProps()
	GAMEMODE:SpawnProps()

end


//
// This is called when the round time ends.
//
function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	local bluescore = team.GetScore( TEAM_BLUE )
	local yellowscore = team.GetScore( TEAM_YELLOW )
	
	if bluescore > yellowscore then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
	elseif bluescore < yellowscore then
		GAMEMODE:RoundEndWithResult( TEAM_YELLOW )
	else
		GAMEMODE:RoundEndWithResult( -1, "Round draw!" )
	end

end

