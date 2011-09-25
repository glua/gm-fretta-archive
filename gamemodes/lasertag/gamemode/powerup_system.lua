// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Powerup system. Shared file.

GM.Powerups = {
	Master = {}
}

local pcol = {
	[POWERUP_PRIMARY]		= Color(0,0,255,100),
	[POWERUP_SECONDARY]		= Color(205,0,0),
	[POWERUP_PLAYER]		= Color(255,180,0)
}


local Class = {}
Class.__index = Class
PWUP = nil

function GM:LoadPowerups()
	for _,f in ipairs(file.FindInLua("lasertag/gamemode/powerups/*.lua")) do
		if SERVER then AddCSLuaFile("lasertag/gamemode/powerups/"..f) end
		
		// Command Table
		local o = {
			Name 	= "##UNKNOWN##",
			Type 	= POWERUP_PRIMARY,
			Rarity 	= 1,
			Mat 	= "LaserTag/HUD/powerup_base",
			Tex 	= "LaserTag/HUD/powerup_base"
		}
		
		PWUP = setmetatable(o,Class)
			include("lasertag/gamemode/powerups/"..f)
			
			// Post init setup.
			if not self.Powerups[PWUP.Rarity] then self.Powerups[PWUP.Rarity] = {} end
			PWUP.Color = PWUP.Color or pcol[PWUP.Type]
			
			if CLIENT then
				PWUP.Mat = Material(PWUP.Mat)
				PWUP.Tex = surface.GetTextureID(PWUP.Tex)
			end
			
			// Insert into tables.
			table.insert(self.Powerups[PWUP.Rarity],PWUP) 	// Sort by rarity. (Convenience for rolling randomality.)
			self.Powerups.Master[PWUP.Name] = PWUP 			// Sort by name. (Convenience for fetching.)
		PWUP = nil
	end
end

GM:LoadPowerups()

function GM:RollPowerup(rarity)
	if rarity < 1 then rarity = 1 end
	
	if not self.Powerups[rarity] and rarity > 1 then
		return self:RollPowerup(rarity - 1)
	elseif not self.Powerups[rarity] then
		return error("LaserTag encountered an error while randomly selecting a powerup: No powerups found.")
	end
	
	local max = #self.Powerups[rarity]
	local result = math.random(1,max)
	if rarity > 1 then 
		local chance = math.random(1,3)
		if chance < 3 then 
			local result = self:RollPowerup(rarity-1)
			if result then return result end
		end
	end
	
	return self.Powerups[rarity][result]
	
end

if SERVER then
	
	//	--------------------------	//
	//	SERVERSIDE ONLY FUNCTIONS	//
	//	--------------------------	//
	
	function GM:GrantPowerup(ply,powerup)
		if not powerup then return false end 
		
		// Run the OnPickup function for the powerup.
		if powerup.OnPickup and type(powerup.OnPickup) == "function" then
			powerup:OnPickup(ply,ply:GetActiveWeapon())
		end
		
		// Set the networked variable.
		ply:SetNWString(self:GetSlotStr(powerup.Type),powerup.Name)
		self:RecordStatPowerup(ply)
		
		// Send the UMSG to trigger the same process on the client.
		umsg.Start("GrantPowerup",ply)
			umsg.String(powerup.Name)
		umsg.End()
	end
	
	function GM:DropPowerup(ply,slot)
		local powerup = self:GetPowerupFromSlot(ply,slot)
		if not powerup then return false end
		
		// Run the OnDrop function for the powerup.
		if powerup.OnDrop and type(powerup.OnDrop) == "function" then
			powerup:OnDrop(ply,ply:GetActiveWeapon())
		end
		
		// Set the networked variable to false.
		ply:SetNWString(self:GetSlotStr(powerup.Type),false)
		
		// Send the UMSG to trigger the same process on the client.
		umsg.Start("DropPowerup",ply)
			umsg.String(powerup.Name)
		umsg.End()
	end
	
	// Developer convenience function. lua_run GAMEMMODE:PlyGive(player.GetByID(1,"whatever")
	function GM:PlyGive(ply,pname)
		local powerup = self.Powerups.Master[pname]
		
		if powerup then
			self:DropPowerup(ply,powerup.Type)
			self:GrantPowerup(ply,powerup)
		end
	end
	
else

	//	--------------------------	//
	//	CLIENTSIDE ONLY FUNCTIONS	//
	//	--------------------------	//
	
	function GM:RcvGrantPowerup(um)
		local name = um:ReadString()
		local powerup = self:GetPowerup(name)
		
		if powerup and powerup.OnPickup and type(powerup.OnPickup) == "function" then
			powerup:OnPickup(LocalPlayer(),LocalPlayer():GetActiveWeapon())
		end
	end
	usermessage.Hook("GrantPowerup",function(um) GAMEMODE:RcvGrantPowerup(um) end)
	
	function GM:RcvDropPowerup(um)
		local name = um:ReadString()
		local powerup = self:GetPowerup(name)
		
		if powerup and powerup.OnDrop and type(powerup.OnDrop) == "function" then
			powerup:OnDrop(LocalPlayer(),LocalPlayer():GetActiveWeapon())
		end
	end
	usermessage.Hook("DropPowerup",function(um) GAMEMODE:RcvDropPowerup(um) end)
end

function GM:GetPowerup(name)
	return self.Powerups.Master[name]
end

function GM:GetSlotStr(slot)
	if slot == POWERUP_PRIMARY then return "pwPrimary"
	elseif slot == POWERUP_SECONDARY then return "pwSecondary"
	elseif slot == POWERUP_PLAYER then return "pwPlayer" else return error("Powerup slot unrecognised: "..tostring(slot)) end
end

function GM:GetPowerupFromSlot(ply,slot)
	local slotstr = self:GetSlotStr(slot)
	
	if slotstr then return self:GetPowerup(ply:GetNWString(slotstr)) end
	return false
end
