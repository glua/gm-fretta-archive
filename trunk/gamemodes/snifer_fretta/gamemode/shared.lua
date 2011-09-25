
GM.Name         = "Snifer"
GM.Author       = "Dave"
GM.Email        = "dave@sp4m.net"
GM.Website      = "sp4m.net"

DeriveGamemode( "fretta" )

TEAM_SNIPERS = 1
TEAM_KNIFERS = 2

IncludePlayerClasses()

GM.Help		= "Sniper versus Knifer - the ultimate battle"
GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 60
GM.RoundPostLength = 5
GM.RoundLength = 180
GM.RoundLimit = 20
GM.RoundBased = true
GM.RoundPreStartTime = 0
GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.MinimumDeathLength=60
GM.MaximumDeathLength=60
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = false
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = false
GM.EnableFreezeCam = true
GM.ValidSpectatorModes = {OBS_MODE_CHASE}




function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	// todo: support other map types...

    /* as_, cs_: ts defending, so snipers are ts
     * de_: cts defending, so snipers are cts */
    local snipers_spawn = "info_player_terrorist"
    local knifers_spawn = "info_player_counterterrorist"
    if game.GetMap():sub(1, 3) == "de_" then
        snipers_spawn, knifers_spawn = knifers_spawn, snipers_spawn
    end

    TEAM_SNIPERS = 1
    team.SetUp(TEAM_SNIPERS, "Snipers (the good guys)", Color(0, 127, 255))
    team.SetSpawnPoint(TEAM_SNIPERS, snipers_spawn)
	team.SetClass( TEAM_SNIPERS, { "Sniper" } )
	
    TEAM_KNIFERS = 2
    team.SetUp(TEAM_KNIFERS, "Knifers (the bad guys)", Color(255, 0, 0))
    team.SetSpawnPoint(TEAM_KNIFERS, knifers_spawn)
	team.SetClass( TEAM_KNIFERS, { "Knifer" } )

    team.SetSpawnPoint(TEAM_SPECTATOR, "worldspawn")

end