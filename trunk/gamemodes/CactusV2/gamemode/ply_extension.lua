
//Shared?

local meta = FindMetaTable( "Player" )
if (!meta) then return end

//Scores
--Set/Get/Add score
function meta:SetScore(num)
	self:SetFrags(num)
end
function meta:GetScore()
	return self:Frags()
end
function meta:AddScore(num)
	local score = self:GetScore()
	self:SetFrags(score+num)
end

--Set/Get total score
function meta:SetTotalScore(num)
	self.TotalScore = num
end
function meta:GetTotalScore()
	return self.TotalScore
end

//Use accessor
--Set/Get total cacti caught
function meta:SetCaught(num)
	self.Caught = num
end
function meta:GetCaught()
	return self.Caught
end
--Set/Get total cacti of a certain type caught
function meta:SetCaughtType(typ,num)
	if !self.CaughtType then self.CaughtType = {} end
	for k,v in pairs(Cactus.Types) do
		if typ == v then
			self.CaughtType[typ] = num
		end
	end
end
function meta:GetCaughtType(typ)
	return self.CaughtType[typ]
end

function meta:SetHumansKilled(num)
	self.HumansKilled = num
end
function meta:GetHumansKilled()
	return self.HumansKilled
end


//Power-ups
--Clears your powerups
function meta:ClearPowerupQueue() --shd -clear the hud/queue
	self.Powerups = {}
end
--Gets your powerups
function meta:GetPowerupQueue() --shd -stuff in hud
	return self.Powerups
end
--Gets your powerups
function meta:HasPowerup(powerup) --sv -only needed for sv?
	if table.HasValue(self.Powerups,powerup) then
		return true
	end
	return false
end
--Adds a powerup
function meta:AddPowerup(powerup) --shd -used to add a new one
	table.insert(self.Powerups,1,powerup)
	local obj = Cactus.GetPowerup(powerup)
	local notestring = "You've gained the "..obj:GetNick().." power-up!" --use this if not
	
	local notify = {} --Hint table
	notify["Type"] = "powerup_gain" --Type of notification for cactus icon to use
	notify["Urgency"] = 3 --Type of notification for cactus icon to use
	notify["Time"] = {}
	notify["Time"]["Notify"] = 1 --Time in seconds for notification to stop
	notify["Time"]["Hint"] = 0.5 --Time in seconds before the hint to goes away
	
	GAMEMODE:SendCactusNotification(self,notestring,notify) --Send a notification
end
--Removes a powerup
function meta:RemovePowerup(powerup) --shd -used to remove
	for k,v in ipairs(self.Powerups) do
		if v == powerup then
			table.remove(self.Powerups,k)
		end
	end
end


//Misc.
--Quick reference
function meta:IsHuman() --Shared
	if self:Team() == TEAM_HUMAN then
		return true
	end
	return false
end

function meta:SetCactus(ent) --Shared
	if !ValidEntity(ent) then return end
	if ent:IsPlayer() then return end
	self:SetNWEntity("cactusobj",ent)
	ent:SetPlayerObj(self)
	ent:SetOwner(self)
	timer.Stop("spamtimer_"..ent:EntIndex())
	--ent.PlayerObj = self
end
function meta:GetCactus() --shd
	if !self:GetNWEntity("cactusobj") then
		return nil
	end
	return self:GetNWEntity("cactusobj")
end

//Use accessor
function meta:SetSurvivalTime(num)
	self.SurvivalTime = num
end
function meta:GetSurvivalTime()
	return self.SurvivalTime
end

function meta:SetCactusType(typ) --Shared
	self:GetCactus():SetCactusType(typ)
end
function meta:GetCactusType() --Shared
	if ValidEntity(self:GetCactus()) then
		return self:GetCactus():GetCactusType()
	end
end

//Server
if !SERVER then return end

//Use accessor
function meta:SetCanSpawnFromSpec(bool)
	self:SetNWBool("CanSpawnFromSpectator", bool)
end
function meta:GetCanSpawnFromSpec()
	return self:GetNWBool("CanSpawnFromSpectator")
end

--Grabber stuff
function meta:SetGrabber(bool) --sv
	if !bool then
		if self.GrabberObj and ValidEntity(self.GrabberObj) then
			SafeRemoveEntity(self.GrabberObj)
		end
	else
		local ent = ents.Create("sent_grabber")
		ent:SetPos(self:GetPos()+self:OBBCenter())
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:Spawn()
		self.GrabberObj = ent
	end
end
function meta:GetGrabber() --sv
	return self.GrabberObj or false
end

//Use accessor
--Invincibility stuff
function meta:SetInvincible(bool) --sv
	self.Invincible = bool
end
function meta:GetInvincible() --sv
	return self.Invincible
end



