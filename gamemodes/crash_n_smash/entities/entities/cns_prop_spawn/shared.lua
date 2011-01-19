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

function ENT:ValueLevel()
	
	return self:GetNWInt("level")
	
end

if SERVER then

	function ENT:KeyValue( key, value )

		if key == "value" then
			self:SetNWInt("level",tonumber(value))
		end
		
	end

end

if CLIENT then
	function ENT:Draw()
	
	end
end
