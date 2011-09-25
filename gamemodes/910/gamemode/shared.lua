include( "meta.lua" )

GM.Name 	= "Nine Tenths"
GM.Author 	= "Nerdboy"
GM.Email 	= "nerdboy6@gmail.com"
GM.Website 	= ""
GM.Help		= "Locate props as they spawn around the map, then bring them back to your base. Regular props are one point, but larger props are three. Explosive barrels are worthless, but they explode nicely.\n\nDon't forget to defend yourself. Chuck props at your enemies to kill them. Don't let your enemies steal from your base!"

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 16.5

GM.MaximumDeathLength = 0			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true	    // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 300				// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 30				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false// CS Style rules

GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 4				// The time between you dying and it going into spectator mode, 0 disables

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate

DeriveGamemode( "fretta" )

TEAM_BLUE 		= 1
TEAM_YELLOW 	= 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 70, 230, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, "info_player_blue" )
	team.SetClass( TEAM_BLUE, { "Default" } )
	
	team.SetUp( TEAM_YELLOW, "Yellow Team", Color( 255, 200, 50 ) )
	team.SetSpawnPoint( TEAM_YELLOW, "info_player_yellow", true )
	team.SetClass( TEAM_YELLOW, { "Default" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_start" )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end

IncludePlayerClasses()	

function GM:BlueTakesLead()

	for k,v in pairs ( team.GetPlayers( TEAM_BLUE ) ) do
		v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.EarnPoint .. "\" )" )
	end
	
	for k,v in pairs ( team.GetPlayers( TEAM_YELLOW ) ) do
		v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LosePoint .. "\" )" )
	end

end

function GM:GameTied()

	for k,v in pairs ( player.GetAll() ) do
		v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.TiePoint .. "\" )" )
	end

end

function GM:YellowTakesLead()

	for k,v in pairs ( team.GetPlayers( TEAM_BLUE ) ) do
		v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LosePoint .. "\" )" )
	end
	
	for k,v in pairs ( team.GetPlayers( TEAM_YELLOW ) ) do
		v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.EarnPoint .. "\" )" )
	end

end


