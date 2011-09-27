ENT.Type = "brush"

AddCSLuaFile("shared")
AccessorFunc(ENT, "TeamCZ","CZNum")

function ENT:StartTouch(ent)
    gamemode.Call("CaptureFlag", ent, self:GetCZNum())
end

function ENT:KeyValue(key, value)
	if (key == "team") then
		self:SetCZNum(tonumber(value))
	end
end