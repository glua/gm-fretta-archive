AddCSLuaFile("shared.lua")

ENT.Type 			= "brush"
ENT.PrintName		= ""
ENT.Author			= "Clavus"
ENT.Purpose			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:Initialize()

end

function ENT:Touch( ent )

end

function ENT:StartTouch( ent )

	ent:HitTeamBoundary()	

end

function ENT:EndTouch( ent )
	
end