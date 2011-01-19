////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Environnement and Rooms Module             //
////////////////////////////////////////////////

module( "ware_env", package.seeall )

local Environments = {}

--[[
Ware environment metatable starts here
]]

local function FindBestEnvironmentByPlayerCount(list)
	local numPlayers = team.NumPlayers(TEAM_HUMANS)
	local best, lastDiff, lastDiff2
	
	for _,v in ipairs(list) do
		if not lastDiff2 then -- "Good" room not found yet, find the best room that approaches most the player count
			if numPlayers>=v.MaxPlayers then
				if not lastDiff or numPlayers-v.MaxPlayers<lastDiff then
					best = v
					lastDiff = numPlayers-v.MaxPlayers
				end
			elseif numPlayers<v.MinPlayers then
				if not lastDiff or v.MinPlayers-numPlayers<lastDiff then
					best = v
					lastDiff = v.MinPlayers-numPlayers
				end
			end
		end
			
		-- "Good" room found, let's see if we can find anything better
		if numPlayers>=v.MinPlayers and numPlayers<v.MaxPlayers then
			local diff = math.abs(numPlayers-(v.MaxPlayers-v.MinPlayers)/2)
			if not lastDiff2 or diff<lastDiff2 then
				lastDiff2 = diff
				best = v
			end
		end
	end
	
	return best
end

local WAREENV = {}

--Location retrieval functions
function WAREENV:GetEnts(group)
	if type(group)=="table" then
		local result = {}
		for _,v in pairs(group) do
			table.Add(result, self:GetEnts(v))
		end
		return result
	elseif type(group)=="string" then
		return table.Copy(self.Locations[group] or {})
	elseif group and group:IsValid() then
		return {group}
	end
end

function WAREENV:GetNumEnts(group)
	if type(group)=="table" then
		local result = 0
		for _,v in pairs(group) do
			result = result + self:GetNumEnts(v)
		end
		return result
	else
		return #(self.Locations[group] or {})
	end
end

function WAREENV:GetRandomLocations(num, group)
	local entposcopy = self:GetEnts(group)
	local result = {}
	
	local available = math.Clamp(num,0,#entposcopy)
	
	for i=1,available do
		local p = table.remove(entposcopy, math.random(1,#entposcopy))
		table.insert(result, p)
	end
	
	return result
end

function WAREENV:GetRandomPositions(num, group)
	local result = self:GetRandomLocations(num, group)
	for k,v in pairs(result) do
		result[k] = result[k]:GetPos()
	end
	
	return result
end

function WAREENV:GetRandomLocationsAvoidBox(num, group, test, vec1, vec2)
	local entposcopy = self:GetEnts(group)
	local result = {}
	
	local invalid = {}
	local failsafe = false
	local available = math.Clamp(num,0,#entposcopy)
	
	for i=1,available do
		local ok
		repeat
			local p = table.remove(entposcopy, math.random(1,#entposcopy))
			
			ok = true
			
			if not failsafe then
				for _,v in pairs(ents.FindInBox(p:GetPos()+vec1, p:GetPos()+vec2)) do
					if test(v) then
						ok = false
						break
					end
				end
			end
			
			if ok then
				table.insert(result, p)
			else
				table.insert(invalid, p)
			end
			
			if #entposcopy==0 then
				-- No more entities available, enable failsafe mode, and pick invalid entities
				entposcopy = invalid
				failsafe = true
			end
		until ok
	end
	
	return result
end

function WAREENV:GetRandomPositionsAvoidBox(num, group, test, vec1, vec2)
	local result = self:GetRandomLocationsAvoidBox(num, group, test, vec1, vec2)
	for k,v in pairs(result) do
		result[k] = result[k]:GetPos()
	end
	
	return result
end

local ware_env_meta = {__index=WAREENV}

-- End of metatable

function Create(ent)
	local env
	if ent and ent:IsValid() and ent:GetClass()=="func_wareroom" then
		--Create a new environment based on the given func_wareroom entity
		env = {PlayerSpawns=ent.PlayerSpawns, Locations=ent.Locations, Players=ent.Players, Name=ent:GetName(), MinPlayers=ent.MinPlayers or 0, MaxPlayers=ent.MaxPlayers or 0}
	else
		--Create the default environment
		env = {PlayerSpawns={}, Locations={}, Players={}, Name="", MinPlayers=0, MaxPlayers=0}
		for _,v in pairs(ents.GetAll()) do
			if v:GetClass()=="info_player_start" then
				table.insert(env.PlayerSpawns, v)
			elseif v:GetClass()=="gmod_warelocation" then
				if not env.Locations[v:GetName()] then
					env.Locations[v:GetName()] = {}
				end
				table.insert(env.Locations[v:GetName()], v)
			end
		end
	end
	setmetatable(env, ware_env_meta)
	
	table.insert(Environments, env)
	env.ID = #Environments
	
	return env
end

function Get(id)
	return Environments[id]
end

function HasEnvironment(name)
	if name=="none" or name=="generic" or name=="" or not name then
		return true
	end
	
	for _,v in pairs(ents.FindByClass("func_wareroom")) do
		if string.find(v:GetName(),name) then
			return true
		end
	end
	return false
end

function FindEnvironment(name)
	if name=="none" and not GAMEMODE.CurrentEnvironment then
		name="generic"
	end
	
	if name=="none" then
		return GAMEMODE.CurrentEnvironment
	elseif not name or name=="" or name=="generic" then
		local list = {}
		for _,v in ipairs(Environments) do
			if v.Name=="" then
				table.insert(list,v)
			end
		end
		
		return FindBestEnvironmentByPlayerCount(list)
	else
		local list = {}
		for _,v in ipairs(Environments) do
			if string.find(v.Name,name) then
				table.insert(list,v)
			end
		end
		
		return FindBestEnvironmentByPlayerCount(list)
	end
end

function GetTable()
	return Environments
end
