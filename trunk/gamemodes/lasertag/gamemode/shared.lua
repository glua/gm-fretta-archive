// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Shared functions and methods for the gamemode.

GM.Name 	= "LaserTag"
GM.Author 	= "Fuzzylightning"
GM.Email 	= "Fuzzylightning@live.com"
GM.Website 	= ""

DeriveGamemode("fretta")
IncludePlayerClasses()	

GM.Help		= "Shoot anyone who isn't your color! Break their shields to change them to your team, but watch your own shields! Collect powerups for a competitive edge."

GM.TeamBased 					= true		// Is it team based?
GM.AllowAutoTeam 				= true		// Automatic team assignment?
GM.AllowSpectating 				= false		// Permit spectating?
GM.SecondsBetweenTeamSwitches 	= 0			// How much of a delay between team swapping to have.
GM.GameLength 					= 20		// Length of overall game.
GM.RoundLimit					= 10		// Maximum amount of rounds to be played in round based games.
GM.VotingDelay 					= 5			// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up.
GM.NoTeamSwapAfterSpawn			= true		// Prevent teamswapping after spawn. [LaserTag Specific]

GM.NoPlayerSuicide 				= true		// Disallow suicides by players?
GM.NoPlayerDamage 				= true		// Disallow damage to players at all? (e.g. godmode)
GM.NoPlayerSelfDamage			= false		// Disallow self-inflicted damage? (e.g. falling)
GM.NoPlayerTeamDamage 			= true		// Disallow team damage?
GM.NoPlayerPlayerDamage 		= false		// Disallow Player vs Player damage?
GM.NoNonPlayerPlayerDamage 		= false		// Disallow environmental damage?
GM.TakeFragOnSuicide 			= false		// Take a frag from player's score when they commit suicide?
GM.AddFragsToTeamScore 			= false		// Add the frags players get to the team score?
GM.NoPlayerFootsteps 			= false		// Give all players silent footsteps?
GM.PlayerCanNoClip 				= false		// When true, players can use noclip without sv_cheats.

GM.MaximumDeathLength 			= 0			// Player will respawn if death length > this (can be 0 to disable).
GM.MinimumDeathLength 			= 0			// Player has to be dead for at least this long.
GM.AutomaticTeamBalance 		= false     // Teams will be periodically balanced.
GM.ForceJoinBalancedTeams 		= true		// Players won't be allowed to join a team if it has more players than another team.
GM.RealisticFallDamage 			= false		// Scale fall damage to the fall. (Instead of 10 damage regardless).

GM.NoAutomaticSpawning 			= false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased 					= true		// Round based, like CS
GM.RoundLength 					= 60 * 5	// Round length, in seconds
GM.RoundPreStartTime 			= 5			// Preperation time before a round starts
GM.RoundPostLength 				= 5			// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive 	= true		// CS Style rules

GM.SelectModel 					= true 		// Allow players to change their playermodel in the F1 menu?
GM.SelectColor 					= false 	// Allow players to change their color?
GM.SelectClass 					= false		// Allow players to select their class?

GM.PlayerRingSize 				= 48			// How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin 						= "LaserTag"	// Select skin for the HUD
 
GM.EnableFreezeCam 				= false				// TF2 Style Freezecam
GM.DeathLingerTime 				= 0					// The time between you dying and it going into spectator mode, 0 disables
GM.ValidSpectatorModes 			= {OBS_MODE_CHASE} 	// Table of valid OBS modes.
GM.ValidSpectatorEntities 		= {"player"} 		// Entities we can spectate
GM.CanOnlySpectateOwnTeam 		= true 				// you can only spectate players on your own team

// Include/share files.
local function Run(f) AddCSLuaFile(f) include(f) end

// Include other shared files...
Run("sh_utility.lua")
Run("enum.lua")
Run("powerup_system.lua")
Run("stat_system.lua")

 
// Team Setup 
TEAM_RED	= 1 // 220, 0, 0
TEAM_BLUE	= 2 // 0, 100, 255
TEAM_GREEN	= 3 // 0, 220, 25
TEAM_YELLOW	= 4 // 255, 180, 0

function GM:CreateTeams()
	if not GAMEMODE.TeamBased then return end
	
	team.SetUp(TEAM_RED,"Rapture",Color(220, 0, 0))
	team.SetSpawnPoint(TEAM_RED,{"lt_rapturespawn"},true)
	
	team.SetUp(TEAM_BLUE,"Siren",Color(0, 100, 255))
	team.SetSpawnPoint(TEAM_BLUE,{"lt_sirenspawn"},true)
	
	team.SetUp(TEAM_GREEN,"Cobra",Color(0, 220, 25))
	team.SetSpawnPoint(TEAM_GREEN,{"lt_cobraspawn"},true)
	
	team.SetUp(TEAM_YELLOW,"Fury",Color(255, 180, 0))
	team.SetSpawnPoint(TEAM_YELLOW,{"lt_furyspawn"},true)
end

/*-------------------------------------------------------------------
	[ PlayerCanJoinTeam ]
	Check if a player can join a requested team.
-------------------------------------------------------------------*/
function GM:PlayerCanJoinTeam(ply,teamid)
	if self.NoTeamSwapAfterSpawn and ply:Team() >= 1 and ply:Team() <= 4 then return false end
	
	return self.BaseClass:PlayerCanJoinTeam(ply,teamid)
end


/*-------------------------------------------------------------------
	team.SetUp(TEAM_BLUE,"Siren",Color(80,150,255))
	team.SetSpawnPoint(TEAM_BLUE,{"info_player_start","info_player_terrorist","info_player_counterterrorist"},true)
	
	team.SetUp(TEAM_RED,"Rapture",Color(255,80,80))
	team.SetSpawnPoint(TEAM_RED,{"info_player_start","info_player_terrorist","info_player_counterterrorist"},true)
	
	team.SetUp(TEAM_GREEN,"Cobra",Color(70,230,70))
	team.SetSpawnPoint(TEAM_GREEN,{"info_player_start","info_player_terrorist","info_player_counterterrorist"},true)
	
	team.SetUp(TEAM_YELLOW,"Fury",Color(80,150,255))
	team.SetSpawnPoint(TEAM_YELLOW,{"info_player_start","info_player_terrorist","info_player_counterterrorist"},true)
-------------------------------------------------------------------*/
