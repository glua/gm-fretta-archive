AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

// Useful in practically any gamemode.
function GM:ChatMessage(message)
	for _, ply in pairs(player.GetAll()) do ply:ChatPrint("* " .. (message or "OSHI NO MESSAGE SORRY")) end
end

function GM:PlayerSpawn(...)
	self.BaseClass.PlayerSpawn(self.BaseClass, ...)
end