-- SHARED --
GM.DebugMode = false

GM.Name 	= "Rocketball"
GM.Author 	= ""
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Use your GravGun to punt the rocket ball to the other team."
GM.Data 	= {}

GM.PuntLength = 160
GM.PuntPowerMax = 160
GM.PuntPowerMin = 135
 
DeriveGamemode( "fretta" )
IncludePlayerClasses()				-- Automatically includes files in "gamemode/player_class"
 
GM.TeamBased 		= true			-- Team based game or a Free For All game?
GM.AllowAutoTeam 	= true			-- Automatically balance teams?
GM.AllowSpectating 	= true			-- Allow the player to spectate?
GM.SelectClass 		= true			-- Allow the player to choose a class?
GM.GameLength 		= 99			-- Maximum game length in minutes.
GM.RoundLimit 		= 99			-- If GM.RoundBased then this sets the maximum playable rounds.
GM.VotingDelay 		= 5				-- Delay between end of game, and vote.
 
GM.NoPlayerSuicide 			= true	-- Don't allow the player to suicide including the "kill" command?
GM.NoPlayerDamage 			= false	-- Don't allow players to take any damage?
GM.NoPlayerSelfDamage 		= false	-- Don't allow players to hurt themselves?
GM.NoPlayerPlayerDamage		= false -- Don't allow players to hurt each other?
GM.NoNonPlayerPlayerDamage 	= false -- Don't allow damage from non players (physics, fire, etc)
GM.NoPlayerTeamDamage 		= false	-- Don't allow players to hurt own team players?
GM.NoPlayerFootsteps 		= false	-- When true, all players have silent footsteps.
GM.PlayerCanNoClip 			= false	-- When true, players can use noclip without sv_cheats.
GM.TakeFragOnSuicide 		= false	-- When true, -1 frag on suicide.
 
GM.MaximumDeathLength 	= 0			-- Player will respawn if death length > this (use 0 to disable)
GM.MinimumDeathLength 	= 0			-- Player has to be dead for at least this long
GM.RealisticFallDamage 	= false		-- Players will die if they fall too far.
 
GM.NoAutomaticSpawning 	= true		-- When true, players will not spawn after being killed.
GM.RoundBased 			= true		-- Round based, like CS.
GM.RoundLength 			= 60 * 10	-- Round length, in seconds
GM.RoundPreStartTime 	= 5			-- Preperation time before a round starts. OnRoundStart is called when this time is up.
GM.RoundPostLength 		= 5			-- Time it takes for the next round to start after OnRoundEnd.
 
GM.EnableFreezeCam 		= false		-- TF2 Style Freezecam. (when killed you will see a frozen shot of your attacker)
GM.DeathLingerTime 		= 3			-- The time between you dying and going into spectator mode, 0 disables.
 
GM.SelectModel 			= true      -- When true, players can select their own Player model in the F1 menu.
GM.SelectColor 			= false		-- When true, players can select their own Ring color in the F1 menu.
 
GM.PlayerRingSize 		= 48        -- How big are the colored rings under the player's feet (if they are enabled)?
GM.HudSkin 				= "SimpleSkin"
 
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player", "sent_rocketball" }	-- Entities we can spectate

TEAM_RED = 1
TEAM_BLUE = 2
function GM:CreateTeams()
	if GAMEMODE.TeamBased then
		team.SetUp( TEAM_RED, "RED", Color( 255, 0, 0, 255 ), true )
		team.SetSpawnPoint( TEAM_RED,{"info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch"} )
		team.SetClass( TEAM_RED, {"Template"} )
		
		team.SetUp( TEAM_BLUE, "BLUE", Color( 0, 0, 255, 255 ), true )
		team.SetSpawnPoint( TEAM_BLUE,{"info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch"} )
		team.SetClass( TEAM_BLUE, {"Template"} )
	else
		team.SetUp( TEAM_UNASSIGNED, "Default Team", Color( 255, 255, 255, 255 ), true )
		team.SetSpawnPoint( TEAM_UNASSIGNED,{"info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch"} )
		team.SetClass( TEAM_UNASSIGNED, {"Template"} )
	end
end
 