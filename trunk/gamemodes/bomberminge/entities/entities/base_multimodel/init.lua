include("shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:RestartAnimation(anim)
	umsg.Start("RestartAnimation")
		umsg.Entity(self)
		umsg.Char(anim)
	umsg.End()
end