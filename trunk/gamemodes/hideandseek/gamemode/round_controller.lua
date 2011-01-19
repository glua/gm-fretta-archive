
function GM:SetRoundResult( i ) SetGlobalInt( "RoundResult", i ) end
function GM:ClearRoundResult() SetGlobalInt( "RoundResult", 0 ) end
function GM:SetInRound( b ) SetGlobalBool( "InRound", b ) end
function GM:InRound() return GetGlobalBool( "InRound", false ) end

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	for k,v in pairs ( player.GetAll() ) do
		v:ChatPrint( "Come out, come out, wherever you are!" )
		
		if v:Team() == TEAM_SEEKERS then
			v:UnBlind()
		end
	end

end

function GM:OnPreRoundStart( num )

	game.CleanUpMap()
	
	GAMEMODE:CheckTeamBalance()
	UTIL_StripAllPlayers()
	
	if num > 1 then
		GAMEMODE:SwapTeams()
	end
	
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	for k,v in pairs ( team.GetPlayers( TEAM_HIDERS ) ) do
		v:Freeze( false )
		v:ChatPrint( "Run and hide!" )
	end
	for k,v in pairs ( team.GetPlayers( TEAM_SEEKERS ) ) do
		v:ChatPrint( "No peeking!" )
		v:Blind()
	end

end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	GAMEMODE:RoundEndWithResult( TEAM_HIDERS )

end
