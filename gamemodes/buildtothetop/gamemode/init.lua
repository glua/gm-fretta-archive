
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "admin.lua" )
AddCSLuaFile( "tables.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
include( "admin.lua" )
include( "tables.lua" )


function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
end

function GM:OnRoundResult( t )

	UTIL_FreezeAllPlayers()
	team.AddScore( t, 1 )
	
	local maxscore = GetConVar("btt_maxscore"):GetInt()
	
	for k,v in pairs( player.GetAll() ) do 
	
		if v:Team() == t then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )" )
			v:ChatPrint( "YOUR TEAM REACHED THE TOP, GOOD JOB!" );
		else
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )" )
			v:ChatPrint( "YOUR TEAM FAILED, YOU ARE A USELESS!" );
		end
		
	end
	
	if team.GetScore(t) >= maxscore then
		timer.Simple( 5, function() GAMEMODE:EndOfGame( true ) end )
	end
	
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end

	if team.GetScore( TEAM_RED ) < team.GetScore( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
	elseif team.GetScore( TEAM_RED ) > team.GetScore( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
	else
		GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )
	end

end

function GM:BlueAddScore( ply, ent ) 
 if
		ply:Team() == 2
	then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
	else
		return false
	end
 end 
hook.Add( "PlayerUse", "PrintUseHook", BlueWin ) 

		
function GM:RedAddScore( ply, ent ) 
	if
		ply:Team() == 1
	then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
	else
		return false
	end	
 end 
hook.Add( "PlayerUse", "PrintUseHook", RedWin )

function GM:Think()

for k, ply in pairs( player.GetAll() ) do
	if  
	(ply:GetVelocity():Length() > 1200)
	then
    ply:KillSilent()
	ply:Spawn()
	end	
end




end