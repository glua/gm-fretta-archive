////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
-- Shared vars                                --
////////////////////////////////////////////////

include( "ply_extension.lua" )

GM.Name 	= "GarryWare"
GM.Author 	= "Hurricaaane (Ha3 Team)"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Help		= 
[[Rules :
- Do what she says
- Have fun, this is not a game where you have to kill everyone
By : Hurricaaane (Ha3 Team)

Music by The Hamster Alliance ( http://www.hamsteralliance.com/ ).
Special thanks to Kilburn for developing the modular shape of the gamemode.]]

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = false

GM.SecondsBetweenTeamSwitches = 3
GM.GameLength = 9.0 + 47.0 / 60.0 -- First number was 8.0 before
GM.NotEnoughTimeCap = 20
-- If GM.DefaultAnnouncerID == false, then it switches to random each ware
GM.DefaultAnnouncerID = 1

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = true
GM.NoPlayerSelfDamage = true
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = true
GM.NoNonPlayerPlayerDamage = true

GM.MaximumDeathLength = 1			-- Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 1			-- Player has to be dead for at least this long
GM.NoAutomaticSpawning = false		-- Players don't spawn automatically when they die, some other system spawns them
GM.ForceJoinBalancedTeams = false	-- Players won't be allowed to join a team if it has more players than another team

GM.SelectColor = true

-- Useless
GM.RoundBased = false				-- Round based, like CS
GM.RoundLength = 5.0 * 60.0			-- Round length, in seconds 
GM.RoundEndsWhenOneTeamAlive = false

-- Shared
GM.SelectColor = true
GM.BestStreakEver = 3
GM.ModelPrecacheTable = {}

TEAM_HUMANS = 1

function GM:CreateTeams()
	team.SetUp( TEAM_HUMANS, "Players", Color( 235, 177, 20 ), true )
	team.SetSpawnPoint( TEAM_HUMANS, "info_player_start" )
	team.SetClass( TEAM_HUMANS, { "Default" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_start" )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end

function GM:GetBaseColorPtr( sColorname )
	if (GAMEMODE.WACOLS[sColorname] == nil) then return GAMEMODE.WACOLS["unknown"] end
	
	return GAMEMODE.WACOLS[sColorname]
end


-- Streaks (shared)
function GM:GetBestStreak()
	return GAMEMODE.BestStreakEver
end

function GM:SetBestStreak( newVal )
	if (newVal <= GAMEMODE.BestStreakEver) then return end
	GAMEMODE.BestStreakEver = newVal
end

function GM:PrintInfoMessage( sTopic, sLink, sInfo )
	chat.AddText( GAMEMODE:GetBaseColorPtr("topic"), sTopic, GAMEMODE:GetBaseColorPtr("link"), sLink, GAMEMODE:GetBaseColorPtr("info"), sInfo )
end

function GM:GetSpeedPercent()
	 return GetConVarNumber("host_timescale") * 100
end
