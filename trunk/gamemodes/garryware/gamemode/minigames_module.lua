////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Minigames Module                           //
////////////////////////////////////////////////

module( "ware_mod", package.seeall )

local Minigames = {}
local Minigames_names = {}
local Minigames_sequence = {}
local Minigames_CSFiles = {}

local function CopyMinigameTable(tbl)
	local res = {}
	for k,v in pairs(tbl) do
		if k~="Hooks" or type(v)~="table" then
			res[k] = v
		else
			res[k] = CopyMinigameTable(v)
		end
	end
	return res
end

--[[
local WARE = {}
local ware_mod_meta = {__index=WARE}]]

local function IsValidHookName(name)
	return (string.Left( name , 1 ) ~= "_") and name ~= "Initialize" and name ~= "StartAction" and name ~= "EndAction" and name ~= "IsPlayable" and name ~= "GetModelList" and name ~= "PhaseSignal" and name ~= "PreEndAction"
end

function Register(name, minigame)
	minigame.Name = name
	Minigames[name] = minigame
	table.insert(Minigames_names, name)
end

function Remove(name)
	for k,v in ipairs(Minigames_names) do
		if v==name then
			table.remove(Minigames_names, k)
			break
		end
	end
	
	Minigames[name] = nil
end

function CreateInstance(name)
	if not Minigames[name] then return nil end
	
	local obj = CopyMinigameTable(Minigames[name])
	
	obj.Hooks = {}
	for name,func in pairs(obj) do
		if type(func) == "function" and IsValidHookName( name ) then
			obj.Hooks[name] = function(...) return func( obj, ... ) end
		end
	end
	
	--setmetatable(obj, ware_mod_meta)
	return obj
end

function RandomizeGameSequence()
	Minigames_sequence = {}
	local gamenamecopy = ware_mod.GetNamesTable()
	local occurListDisc = {}
	local occur
	
	for i=1,#gamenamecopy do
		local name = table.remove(gamenamecopy, math.random(1,#gamenamecopy))
		table.insert(Minigames_sequence,name)
		
		occur = ware_mod.Get(name).OccurencesPerCycle or 1
		occurListDisc[name] = (occurListDisc[name] or 0) + 1
		if occur - occurListDisc[name] > 0 then
			table.insert(gamenamecopy,name)
		end
	end
end

function GetRandomGameName()
	local name, minigame
	local env
	repeat
		if #Minigames_sequence == 0 then -- All games have been played, start a new cycle
			ware_mod.RandomizeGameSequence()
		end
		name = table.remove(Minigames_sequence,1)
		minigame = ware_mod.Get(name)
		env = ware_env.FindEnvironment(minigame.Room)
	until env and (minigame.IsPlayable == nil or minigame:IsPlayable())
	return name, env
end

function Get(name)
	return Minigames[name] or Get("_empty")
end

function GetHooks(name)
	if Minigames[name] == nil then return nil end
	return Minigames[name].Hooks or nil
end

function GetNamesTable()
	return table.Copy(Minigames_names)
end

function GetAuthorTable()
	local authtable = {}
	for k,v in pairs(Minigames) do
		authtable[v.Author or "Unknown"] = (authtable[v.Author or "Unknown"] or 0) + 1
	end
	return table.Copy(authtable)
end
