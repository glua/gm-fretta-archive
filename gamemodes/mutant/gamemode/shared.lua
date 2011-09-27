include("player_extension.lua")

GM.Name 	= "Mutant"
GM.Author 	= "mahalis"
GM.Email 	= "mahalis@gmail.com"
GM.Website 	= ""

DeriveGamemode("fretta")
IncludePlayerClasses()	

GM.Help	= "At the start of the round, the Mutant gets selected at random. After that, whoever kills that player becomes the Mutant themself.\n\nIf you seem to be missing effects (plasma trails, Mutant flames, etc.), try restarting GMod; if that doesn't work, update your SVN."
GM.TeamBased = false
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 10
GM.TakeFragOnSuicide = false
GM.NoPlayerSuicide = false

function GM:InitPostEntity()
	self.BaseClass:InitPostEntity()
	for _, e in pairs(ents.FindByClass("prop_physics*")) do e:Remove() end
	for _, w in pairs(ents.FindByClass("weapon_*")) do w:Remove() end
	for _, i in pairs(ents.FindByClass("item_*")) do i:Remove() end
end

function GM:CreateTeams()
	team.SetUp( TEAM_UNASSIGNED, "Players", Color(255, 150, 50), true)
	team.SetSpawnPoint( TEAM_UNASSIGNED, {"info_player_start", "info_player_deathmatch","info_player_terrorist","info_player_counterterrorist"},true)
	team.SetClass(TEAM_UNASSIGNED, {"Default","Mutant"})
	
	team.SetUp(TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true)
	team.SetSpawnPoint(TEAM_SPECTATOR, {"info_player_start", "info_player_deathmatch"})
end
