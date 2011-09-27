
GM.Name 	= "PropIt"
GM.Author 	= "Ljdp"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Pictionary in Gmod."

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = false
GM.SelectClass = false
GM.SelectModel = true
GM.SelectColor = false

GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 25

GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true
GM.NoPlayerTeamDamage = false
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = true
GM.PlayerCanNoClip = false

GM.RoundBased  = true
GM.RoundLength = 60 * 1.5
GM.RoundLimit = 25
GM.RoundPreStartTime = 4		
GM.RoundPostLength = 10
GM.RoundEndsWhenOneTeamAlive = false

GM.PlayerRingSize = 48              // How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"

TEAM_PROPPER = 1
TEAM_GUESSERS = 2

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_PROPPER, "The Propper", Color( 255, 0, 0 ), true )
	team.SetSpawnPoint( TEAM_PROPPER, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } )
	team.SetClass( TEAM_PROPPER, { "propper" } )
	
	team.SetUp( TEAM_GUESSERS, "The Guessers", Color( 0, 0, 255 ), true )
	team.SetSpawnPoint( TEAM_GUESSERS, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } )
	team.SetClass( TEAM_GUESSERS, { "guesser" } )

end


