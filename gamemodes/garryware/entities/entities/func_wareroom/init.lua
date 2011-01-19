ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self.PlayerSpawns = {}
	self.Locations = {}
	self.Players = {}
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="minplayers" then
		self.MinPlayers = tonumber(value)
	elseif key=="maxplayers" then
		self.MaxPlayers = tonumber(value)
	end
end

function ENT:StartTouch(ent)
	if ent:GetClass()=="gmod_warelocation" then
		if ent.PlayerStart then
			table.insert(self.PlayerSpawns, ent.PlayerStart)
			ent:Remove()
		else
			if not self.Locations[ent:GetName()] then
				self.Locations[ent:GetName()] = {}
			end
			table.insert(self.Locations[ent:GetName()], ent)
			ent:SetNotSolid(true)
		end
	elseif ent:IsPlayer() then
		--Msg("Player \""..ent:GetName().."\" entered environment \""..self:GetName().."\"\n")
		self.Players[ent] = 1
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		--Msg("Player \""..ent:GetName().."\" left environment \""..self:GetName().."\"\n")
		self.Players[ent] = nil
	end
end

--[[
hook.Add("InitPostEntity", "WareRoomsInit", function()
	if #ents.FindByClass("func_wareroom")==0 then
		for _,v in pairs(ents.FindByClass("gmod_warelocation")) do
			v:SetNotSolid(true)
		end
		return
	end
	
	for _,v in pairs(ents.FindByClass("info_player_start")) do
		-- That's not a real ware location, but a dummy entity for making info_player_start entities detectable
		-- by the trigger
		local temp = ents.Create("gmod_warelocation")
		temp:SetPos(v:GetPos())
		temp:Spawn()
		temp.PlayerStart = v
	end
end)
]]--