GM.Name 	= "Lock 'n Load - Deathmatch"
GM.Author 	= "Devenger"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode ("fretta")

--default settings - DM-like
--note the settings for Arena are in arena/shared/settings.lua

GM.Help		= "Before spawning, select and customise two weapons.\nTo score points, kill other players."
GM.TeamBased 				= false
GM.NoPlayerTeamDamage 		= false
GM.AutomaticTeamBalance 	= true
GM.AllowAutoTeam 			= true
GM.AllowSpectating			= true
GM.SelectClass				= false
GM.GameLength 				= 10

GM.EnableFreezeCam			= true
GM.DeathLingerTime 			= 4

TEAM_BLUE = 1
TEAM_RED = 2

function GM:CreateTeams()

	if !GAMEMODE.TeamBased then return end
	
	team.SetUp( TEAM_BLUE, "Team Blue", Color( 20, 167, 243 ) )
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_terrorist", "info_player_combine", "info_player_start" } )
	
	team.SetUp( TEAM_RED, "Team Red", Color( 243, 20, 20 ) )
	team.SetSpawnPoint( TEAM_RED, { "info_player_counterterrorist", "info_player_rebel", "info_player_start" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 97, 87, 77 ) )
	team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_*" ) 

end

include ("structure.lua")

IncludePlayerClasses()







function ScreenScaleH( size )
	return size * ( ScrH() / 400.0 )	
end

-- Useful for debugging.
function printd(...)
	if GetConVarNumber("developer") == 0 then return end
	
	local s = ""
	
	// Gets the filename of the function calling printd, and strips it down to lastfolder/filename.
	local info = debug.getinfo(2, "S")
	if info.short_src then
		local found = false
		for p = string.len(info.short_src), 1, -1 do
			local c = string.sub(info.short_src, p, p)
			if c == "\\" || c == "/" then
				if found then
					s = string.sub(info.short_src, p + 1) .. ":\t"
					break
				end
				found = true
			end
		end
	end
	
	for _, v in ipairs({...}) do
		s = s .. tostring(v) .. " "
	end
	s = string.sub(s, 1, -2) // Take off the last space.
	
	MsgN(s)
end

function multipairs(...)
	local full, k = {}, 1
	for _, t in pairs({...}) do
		for _, v in pairs(t) do
			full[k] = v
			k = k + 1
		end
	end
	
	local i = 0
	return function()
		i = i + 1
		if full[i] then return full[i] end
	end
end

-- Useful for base GM values.
function Default(name, val)
	local g = GM or GAMEMODE
	g[name] = g[name] or val
end
