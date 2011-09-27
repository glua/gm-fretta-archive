// #########################
// Hooks
// #########################

GM.Hooks = {}
GM.EntHooks = {}

// Enums.
PRIORITY_HIGH = 1
PRIORITY_MED = 2
PRIORITY_LOW = 3
PRIORITY_DEFAULT = PRIORITY_LOW

// Add hooks within gamemode.
// Usage: self:AddHook(gamemode function to hook, gamemode function hooked, priority 1-3)
// Example: self:AddHook("Think", "RoundThink")
// Or: self:AddHook("Move", "SuperjumpMove", 1)
function GM:AddHook(hookName, funcName, priority)
	if type(priority) == "function" then
		self.Hooks[hookName] = self.Hooks[hookName] or {}
		self.Hooks[hookName][funcName] = priority
	else
		self.Hooks[hookName] = self.Hooks[hookName] or {}
		self.Hooks[hookName][funcName] = math.Clamp(priority or PRIORITY_DEFAULT, 1, 3)
	end
	
	hook.Add(hookName, "GMHooks." .. hookName, function(...) return (GM or GAMEMODE):CallHook(hookName, unpack(arg)) end)
end

function GM:RemoveHook(hookName, funcName)
	self.Hooks[hookName] = self.Hooks[hookName] or {}
	self.Hooks[hookName][funcName] = nil
end

// Add hooks for entities.
// Usage: GM:AddEntityHook(gamemode function, entity class, entity function)
// Example: GM:AddEntityHook( "FlagCapped", "gmf_flag", "FlagCapped")
function GM:AddEntityHook(hookName, class, funcName)
	self.EntHooks[hookName] = self.EntHooks[hookName] or {}
	self.EntHooks[hookName][class] = funcName
	
	hook.Add(hookName, "GMHooks." .. hookName, function(...) return (GM or GAMEMODE):CallHook(hookName, unpack(arg)) end)
end
function GM:RemoveEntityHook(hookName, class, funcName)
	self.EntHooks[hookName] = self.EntHooks[hookName] or {}
	self.EntHooks[hookName][class] = nil
end

// Calls the hooks.
// Usage: GM:CallHook(gamemode function, arguments)
// Example: GM:CallHook("PlayerSpawn", pPlayer)
function GM:CallHook(hookName, ...)
	// Gamemode functions.
	for priority = 1, 3 do
		for funcName, funcPri in pairs(self.Hooks[hookName] or {}) do
			if funcPri == priority then
				local func = self[funcName]
				if func then
					local ok, retval = pcall(func, self, unpack(arg))
					if ok then
						if retval != nil then return retval end
					else
						ErrorNoHalt(retval)
					end
				end
			end
		end
	end
	
	// Plain functions.
	for unique, func in pairs(self.Hooks[hookName] or {}) do
		if type(func) == "function" then
			local ok, retval = pcall(func, self, unpack(arg))
			if ok then
				if retval != nil then return retval end
			else
				ErrorNoHalt(retval)
			end
		end
	end
	
	// Entity functions.
	for class, funcName in pairs(self.EntHooks[hookName] or {}) do
		for _, ent in pairs(ents.FindByClass(class)) do
			if ent[funcName] then
				local ok, retval = pcall(ent[funcName], ent, unpack(arg))
				if ok then
					if retval != nil then return retval end
				else
					ErrorNoHalt(retval)
				end
			end
		end
	end
end

// #########################
// Console commands
// #########################

GM.ConsoleCommands = {}

local function ConCommand(ply, command, args)
	local func = GAMEMODE.ConsoleCommands[command]
	if !func then return end // It's been removed.
	
	// Call the function if it exists.
	if GAMEMODE[func] then
		local ok, error = pcall(GAMEMODE[func], GAMEMODE, ply, command, args)
		if !ok then Error(error) end
	end
end

// Hooks a console command to a gamemode function.
// Usage: GM:AddConCommand(console command, gamemode function)
// Example: GM:AddConCommand("+undo", "ILikeToUndo")
function GM:AddConCommand(command, func)
	self.ConsoleCommands[command] = func
	concommand.Add(command, ConCommand)
end
function GM:RemoveConCommand(command)
	self.ConsoleCommands[command] = nil
end

// #########################
// Folder structure
// #########################

// Work out the name of the gamemode folder.
GM.RealFolder = GM.Folder
for i = string.len(GM.Folder), 1, -1 do
	local char = string.sub(GM.Folder, i, i)
	if char == "/" || char == "\\" then
		GM.RealFolder = string.sub(GM.Folder, i + 1)
		break
	end
end

local clientFolder = "lua_temp/"
if SinglePlayer() then
	clientFolder = "gamemodes/"
end

function SettingFile(name)
	name = string.Replace(name, "%map%", game.GetMap())
	return GM.RealFolder .. "/settings/" .. name .. ".lua"
end
function LoadSettingFile(name, sendCS)
	if sendCS then AddCSLuaFile(SettingFile(name)) end
	include(SettingFile(name))
end

--What sub-mode are we playing?
local map = game.GetMap()
sm = string.sub (map, 5)
sm = string.sub (sm, 1, string.find (sm, "_") - 1)
sm = sm or "arena" --JIC
print ("SUB-MODE:", sm)

if SERVER then
	AddCSLuaFile("structure.lua")
	
	GM.GamemodeFolder = "gamemodes/" .. GM.RealFolder
	
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/server/*.lua")) do
		include("server/" .. fileName)
	end
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/client/*.lua")) do
		AddCSLuaFile("client/" .. fileName)
	end
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/shared/*.lua")) do
		include("shared/" .. fileName)
		AddCSLuaFile("shared/" .. fileName)
	end
	
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/"..sm.."/server/*.lua")) do
		include(sm.."/server/" .. fileName)
	end
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/"..sm.."/client/*.lua")) do
		AddCSLuaFile(sm.."/client/" .. fileName)
	end
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/"..sm.."/shared/*.lua")) do
		include(sm.."/shared/" .. fileName)
		AddCSLuaFile(sm.."/shared/" .. fileName)
	end
end
if CLIENT then
	GM.GamemodeFolder = clientFolder .. GM.RealFolder
	
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/client/*.lua")) do
		include("client/" .. fileName)
	end
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/shared/*.lua")) do
		include("shared/" .. fileName)
	end
	
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/"..sm.."/client/*.lua")) do
		include(sm.."/client/" .. fileName)
	end
	for _, fileName in pairs(file.Find("../" .. GM.GamemodeFolder .. "/gamemode/"..sm.."/shared/*.lua")) do
		include(sm.."/shared/" .. fileName)
	end
end
