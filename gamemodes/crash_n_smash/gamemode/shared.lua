
GM.Name 	= "Crash 'n Smash"
GM.Author 	= "Clavus"
GM.Email 	= "clavus@clavusstudios.nl"
GM.Website 	= "www.clavusstudios.com"

/*
CREDITS

Redgord 				- Custom music ques
Mr. Green community		- Hosting and support
Garry					- Making Garry's Mod / Fretta
Facepunch Forums		- Feedback!
You						- For bothering to read this code!
*/

include( "player_extension.lua" )
include( "entity_extension.lua" )

GM.Help		= ""//"Shoot your teammates to the other side and break as much props there as you can!"
GM.RealHelp = [[
HELP

* Break props on the enemy side
* Defend the props on your side
* The team with the highest total prop value wins the round

* Launchs teammates to the other side with the player launcher weapon
* You can also fire enemies off ledges using your primary fire
* Breaks props and kill enemies with the crowbar!

* Grab powerups to activate powers for your whole team!
* Work together to reach the more valuable props!
]]
GM.TeamBased = true

GM.RoundBased = true
GM.RoundLength = 7*60				// Round length, in seconds
GM.RoundLimit = 3
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 15				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

GM.PlayersPerTeamRequiredBeforeRoundCanStart = 2//def=2 // do I really have to explain this var?

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 0				// The time between you dying and it going into spectator mode, 0 disables

GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = false
GM.AutomaticTeamBalance = true	    // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 25

GM.SelectModel = false               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)

GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = false
GM.PlayerRingSize = 48  

DeriveGamemode( "fretta" )

TEAM_RED = 1
TEAM_BLUE = 2

teaminfo = {}
teaminfo[TEAM_RED] = {}
teaminfo[TEAM_BLUE] = {}
// Team player models
teaminfo[TEAM_RED].Models = { "models/player/barney.mdl", "models/player/alyx.mdl" }
teaminfo[TEAM_BLUE].Models = { "models/player/Kleiner.mdl", "models/player/mossman.mdl" }
// Prop score related stuff
teaminfo[TEAM_RED].PropCount = 0
teaminfo[TEAM_BLUE].PropCount = 0
teaminfo[TEAM_RED].TotalPropValue = 0
teaminfo[TEAM_BLUE].TotalPropValue = 0
// Prop spawns
teaminfo[TEAM_RED].PropSpawns = {}
teaminfo[TEAM_BLUE].PropSpawns = {}

teaminfo[TEAM_RED].Powerup = "none"
teaminfo[TEAM_BLUE].Powerup = "none"

// It's better not to change these values, maps depend on it
gameinfo = {}
gameinfo.PropValue = {
["models/props_junk/wood_crate001a.mdl"] = 1, // crate
["models/props_junk/wood_crate002a.mdl"] = 2, // bigger crate
["models/props_c17/furniturechair001a.mdl"] = 5, // chair
["models/props_junk/watermelon01.mdl"] = 25 // melon
}

propClasses = { "prop_physics", "prop_physics_multiplayer" }
scoreinfo = {}

MUSIC_ROUNDSTART = Sound("crash_n_smash/roundstart.mp3")
MUSIC_ROUNDWIN = Sound("crash_n_smash/roundwin.mp3")
MUSIC_ROUNDLOSE = Sound("crash_n_smash/roundlose.mp3")

GM.PropSpawnSounds = { 
Sound("weapons/bugbait/bugbait_squeeze1.wav"), 
Sound("weapons/bugbait/bugbait_squeeze2.wav"), 
Sound("weapons/bugbait/bugbait_squeeze3.wav") }

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end

	for k, model in pairs(teaminfo[TEAM_RED].Models) do
		util.PrecacheModel(model)
	end
	for k, model in pairs(teaminfo[TEAM_BLUE].Models) do
		util.PrecacheModel(model)
	end
	
	PrecacheParticleSystem( "aurora_shockwave" )
	PrecacheParticleSystem( "blood_advisor_puncture_withdraw" )
	PrecacheParticleSystem( "ceiling_dust" )
	
	team.SetUp( TEAM_RED, "Team Red", Color( 255, 80, 80 ) )
	team.SetSpawnPoint( TEAM_RED, { "info_player_rebel" }, true )
	
	team.SetUp( TEAM_BLUE, "Team Blue", Color( 80, 150, 255 ) )
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_combine" }, true )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_rebel", "info_player_combine" } ) 

end

GM.TeamDivider = nil

function GM:InitPostEntity()

	self.BaseClass:InitPostEntity()
	
	self:SetupMapProps()
	
end

function GM:ShouldCollide( ent1, ent2 )

	if ent1:IsPlayer() and ent2:IsPlayer() and ent1:Team() != ent2:Team() then
		// After firing an enemy player, they get temporary nocollide to prevent players getting stuck in each other
		local ent1nocol = ent1:GetNWFloat("tempnocollidestart", 0) >= CurTime()-1
		local ent2nocol = ent2:GetNWFloat("tempnocollidestart", 0) >= CurTime()-1
		if ent1nocol or ent2nocol then
			if ent1nocol then
				applyto = ent1
				from = ent2
			else
				applyto = ent2
				from = ent1
			end
			local dir = applyto:GetPos()-from:GetPos()
			if dir:Length() < 80 and applyto:GetNWFloat("tempnocollidestart", 0) < CurTime()-0.2 then
				dir.z = 0
				dir:Normalize()
				applyto:SetVelocity(dir*300)
			end
			return false
		end
	end
	
	return self.BaseClass:ShouldCollide( ent1, ent2 )
	
end

function GM:SetupMapProps( check )

	self.TeamDivider = ents.FindByClass("cns_team_divider")[1]
	self.PowerupSpawn = ents.FindByClass("cns_powerup_spawn")[1]
	
	local propspawns = ents.FindByClass("cns_prop_spawn")

	teaminfo[TEAM_RED].PropSpawns = table.filter(propspawns,function( v ) return v:TeamSide() == TEAM_RED end)
	teaminfo[TEAM_BLUE].PropSpawns = table.filter(propspawns,function( v ) return v:TeamSide() == TEAM_BLUE end)

	for k, prop in pairs(GetAllProps()) do
		prop.Value = GetPropValue( prop )
	end	
	
	if SERVER then
		UpdateTeamsPropCount()
	end
end

function GM:TeamSide( pos )

	// The cns_team_divider entity points towards the red team's side.  
	// It's exactly 90 degrees on imaginary the plane that seperates the teams.
	local teampointer = self:GetTeamDividerAngles():Forward()
	local proppointer = (pos-self.TeamDivider:GetPos()):GetNormal()
	
	if (teampointer:Dot(proppointer) > 0) then
		return TEAM_RED
	else
		return TEAM_BLUE
	end

end

function GM:GetTeamDividerAngles()

	if not ValidEntity(self.TeamDivider) then
		// For some reason, the self.TeamDivider turns invalid after round start.
		// Temporary fix until I can find out what's really wrong.
		self.TeamDivider = ents.FindByClass("cns_team_divider")[1]
	end
	
	return self.TeamDivider:GetAngles()
end

function GetAllProps()
	
	local props = {}
	for k, v in pairs(propClasses) do
		table.Merge(props,ents.FindByClass(v))
	end
	return props
	
end

function GetPropValue( prop )
	if not ValidEntity(prop) then return 1 end
	if not gameinfo.PropValue[prop:GetModel()] then return 1 end
	return gameinfo.PropValue[prop:GetModel()]
end

function GetPlayerByName( name )

	local found = nil
	local multiple = false
	local foundString = nil
	for k,v in pairs(player.GetAll()) do
		foundString = string.find(string.lower(v:GetName()), string.lower(name))
		if (foundString ~= nil and multiple == false) then
			if (found == nil) then
				found = v
			else
				multiple = true
			end
		end	
	end

	if (multiple == true) then return nil end
	if (found == nil or not found:IsValid()) then return nil end
	
	return found	
end

function InitializeRoundScores()
	scoreinfo.MostPropsBroken = {}
	scoreinfo.MostPlayersLaunched = {}
	scoreinfo.MostPoints = {}
	scoreinfo.MostAssistPoints = {}
	scoreinfo.MostKills = {}
	scoreinfo.MostFallDamage = {}
	scoreinfo.PropsBrokenChainRecord = {}
	scoreinfo.LongestChain = {}
	scoreinfo.LongestChain.players = {}
end

// returns a table that is the paramater table filtered by the parameter function
function table.filter( tab , func )
	local newtab = {}
	for k, v in pairs(tab) do
		if func(v) then
			table.insert(newtab,v)
		end
	end
	return newtab
end

// Constants for the hints in cl_tips
NOTIFY_GENERIC			= 0
NOTIFY_ERROR			= 1
NOTIFY_UNDO				= 2
NOTIFY_HINT				= 3
NOTIFY_CLEANUP			= 4
