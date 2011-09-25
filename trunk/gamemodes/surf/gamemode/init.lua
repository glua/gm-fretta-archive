AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

hook.Add( "Initialize", "Alltalk", function() game.ConsoleCommand( "sv_alltalk", "1" ) end)