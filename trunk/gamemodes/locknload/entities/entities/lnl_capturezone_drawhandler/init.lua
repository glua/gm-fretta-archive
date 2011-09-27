include ("shared.lua")
AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel ("models/Items/grenadeAmmo.mdl")
end