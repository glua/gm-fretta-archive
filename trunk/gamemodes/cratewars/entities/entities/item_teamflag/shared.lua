ENT.Base = "base_anim"
ENT.Type = "anim"

AddCSLuaFile("shared")
AccessorFunc(ENT, "SpawnFlagTeam","SpawnteamNum")

function ENT:Initialize()
	gamemode.Call("SpawnFlag", self:GetSpawnteamNum(), self.Entity:GetPos())
	self.Entity:SetNoDraw( true )
end

function ENT:KeyValue(key, value)
	if (key == "team") then
		self:SetSpawnteamNum(tonumber(value))
		self.Entity:SetNWInt("team", tonumber(value))
	end
end