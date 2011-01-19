include( "player_extension.lua" )

GM.Name 	= "Hide and Seek"
GM.Author 	= "Nerdboy"
GM.Email 	= "nerdboy6@gmail.com"
GM.Website 	= ""
GM.Help		= "Trade turns hiding and seeking the other team.\n\nAs the seeking team, find the hiders before time runs out. When you find a hider, shoot him with your gun to find him.\n\nAs a hider, don't let the seekers find you until time runs out!"

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = true			// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = true			// -1 frag on suicide

GM.MaximumDeathLength = 0			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 2			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 120				// Round length, in seconds
GM.RoundPreStartTime = 30			// Preperation time before a round starts
GM.RoundPostLength = 5				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = true	// CS Style rules

GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 4				// The time between you dying and it going into spectator mode, 0 disables

GM.SelectModel = true               // Can players use the playermodel picker in the F1 menu?

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSeekSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE }

DeriveGamemode( "fretta" )

TEAM_HIDERS 	= 1
TEAM_SEEKERS 	= 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	local spawns = { "info_player_start", "info_player_deathmatch", "info_player_terrorist", "info_player_counterterrorist",
					 "info_player_rebel", "info_player_combine", "info_player_axis", "info_player_allies", "gmod_player_start" }
	
	team.SetUp( TEAM_HIDERS, "Hiders", Color( 70, 230, 70 ), true )
	team.SetSpawnPoint( TEAM_HIDERS, spawns )
	team.SetClass( TEAM_HIDERS, { "Hider" } )
	
	team.SetUp( TEAM_SEEKERS, "Seekers", Color( 255, 200, 50 ), true )
	team.SetSpawnPoint( TEAM_SEEKERS, spawns )
	team.SetClass( TEAM_SEEKERS, { "Seeker" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, spawns )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end

function GM:SwapTeams()

	-- Swap players
	local hiders = team.GetPlayers( TEAM_HIDERS )
	local seekers = team.GetPlayers( TEAM_SEEKERS )
	
	for k,v in pairs( hiders ) do
		v:SetTeam( TEAM_SEEKERS )
		GAMEMODE:PlayerRequestClass( v, 1 )
	end
	
	for k,v in pairs( seekers ) do
		v:SetTeam( TEAM_HIDERS )
		GAMEMODE:PlayerRequestClass( v, 1 )
	end
	
	for k,v in pairs( player.GetAll() ) do
		v:ChatPrint( "The teams have been switched!" )
	end
	
	-- Swap scores
	local hidescore = team.GetScore( TEAM_HIDERS )
	local seekscore = team.GetScore( TEAM_SEEKERS )
	
	team.SetScore( TEAM_HIDERS, seekscore )
	team.SetScore( TEAM_SEEKERS, hidescore )
	
end

IncludePlayerClasses()	

	