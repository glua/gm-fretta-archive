ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Category 			= "cratewars"
ENT.PrintName			= "cw_flag"
ENT.Author			= "Paul Sweeney and Doug Huck"
ENT.Contact			= ""
ENT.Purpose			= "cw_flag"
ENT.Instructions		= ""
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

AccessorFunc(ENT, "FlagTeam","teamNum")

function ENT:StartTouch(entity)
    gamemode.Call("GrabFlag", entity, self:GetteamNum(), self.Entity)
end

function ENT:KeyValue(key, value)
    if (key == "team") then
        self:SetteamNum(tonumber(value))
    end
end
