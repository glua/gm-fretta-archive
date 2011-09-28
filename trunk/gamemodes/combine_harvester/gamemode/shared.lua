//Combine Harvester - fretta gamemode by Carnag3

GM.Name 	= "Combine Harvester"
GM.Author 	= "Carnag3"
GM.Email 	= "mousey76397@gmail.com"
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()


GM.Help = "KILL THE COMBINE!!!!!"
GM.TeamBased = false
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 15
GM.SelectClass = false
GM.GameLength = 9

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = false		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = true 		// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = true			// -1 frag on suicide

GM.MaximumDeathLength = 30			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 2			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = false     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 180 				// Round length, in seconds
GM.RoundPreStartTime = 0			// Preperation time before a round starts
GM.RoundEndsWhenOneTeamAlive = false	// CS Style rules

GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 2				// The time between you dying and it going into spectator mode, 0 disables

GM.SelectModel = true               // Can players use the playermodel picker in the F1 menu?
GM.HudSkin = "SimpleSkin"
GM.SuicideString = "Blew Himself to Pieces!!"

TEAM_RED = 1
TEAM_BLUE = 2

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()
--ignore this not team based
	if ( !GAMEMODE.TeamBased ) then return end
end