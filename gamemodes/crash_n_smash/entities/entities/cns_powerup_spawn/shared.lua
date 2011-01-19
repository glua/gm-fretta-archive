AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Clavus"
ENT.Purpose			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:Initialize()

	self.Entity:DrawShadow( false )
	
end

if CLIENT then
	function ENT:Draw()
	
	end
end
