// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Stat tracking system. Shared file.

GM.Stats = {}
GM.Track = {
	Distance = {},
	Headshots = {},
	Shots = {},
	Powerups = {}
}

function GM:AddStat(name,desc,calcfunc,img)
	temp = {
		Name = name,
		Desc = desc,
		Func = calcfunc,
		Mat = "LaserTag/HUD/"..img..".vmt"
	}
	
	
	return table.insert(self.Stats,temp)
end

function GM:StatThink()
	if not SERVER then return end
	
	// I know this is pretty shocking. TODO: Make this more efficient.
	for _,ply in ipairs(player.GetAll()) do
		self.Track.Distance[ply] = self.Track.Distance[ply] or {Distance = 0,Last = false}
		local curpos = ply:GetPos()
		
		if self.Track.Distance[ply].Last then
			self.Track.Distance[ply].Distance = self.Track.Distance[ply].Distance + curpos:Distance(self.Track.Distance[ply].Last)
		end
		
		self.Track.Distance[ply].Last = curpos
	end
end

function GM:CalculateStats()
	if not SERVER then return end
	local statret = {}
	
	for k,v in ipairs(self.Stats) do
		local ret = v.Func(self)
		local rank = 1
		
		for i=1,#ret do // Rank all the results. Includes tied scores.
			if i > 1 and ret[i].Score == ret[i-1].Score then 
				ret[i].Rank = ret[i-1].Rank
			else 
				ret[i].Rank = rank
				rank = rank + 1
			end
		end
		
		local i = table.insert(statret,ret)
	end
	
	for _,ply in ipairs(player.GetAll()) do
		for k,v in ipairs(statret) do self:StatSendToPlayer(ply,v,k) end
	end
end

function GM:StatsReset(ply)
	ply:SetFrags(0)
	ply:SetDeaths(0)
	
	self.Track.Distance[ply] 	= {Distance = 0,Last = false}
	self.Track.Headshots[ply] 	= 0
	self.Track.Shots[ply] 		= 0
	self.Track.Powerups[ply] 	= 0
end

function GM:RecordStatPowerup(ply)
	self.Track.Powerups[ply] = (self.Track.Powerups[ply] or 0) + 1
end

function GM:RecordStatHeadshot(ply)
	self.Track.Headshots[ply] = (self.Track.Headshots[ply] or 0) + 1
end

function GM:RecordStatShot(ply)
	self.Track.Shots[ply] = (self.Track.Shots[ply] or 0) + 1
end

function GM:StatSendToPlayer(ply,statdata,i)
	local stat = self.Stats[i]
	local send = {}
	
	if statdata[1] then send[1] = table.Copy(statdata[1]) else return false end // If we don't have any statdata then don't bother sending anything.
	if statdata[2] then send[2] = table.Copy(statdata[2]) end
	if statdata[3] then send[3] = table.Copy(statdata[3]) end
	
	for k,v in ipairs(statdata) do
		if v.Ply == ply then
			if k > 3 then send[4] = table.Copy(v) end
			break
		end
	end
	
	local MaxRank = statdata[#statdata].Rank
	
	umsg.Start("LaserTag-StatSend",ply)
		umsg.Short(i) 			// Stat ID.
		umsg.Short(#send)		// Number of scores we are sending, we have to predict the for-do.
		umsg.Short(MaxRank)		// Total number of ranks (so we can say you got 3rd place out of 14 players.)
		
		for i,data in ipairs(send) do
			umsg.Entity(data.Ply)
			umsg.Short(data.Score)
			umsg.Short(data.Rank)
		end
	umsg.End()
end

if CLIENT then
	GM.StatData = {}
	GM.LastStatData = {}
	
	function GM:StatReceive(um)
		local StatID = um:ReadShort()
		local sendnum = um:ReadShort()
		local maxrank = um:ReadShort()
		local lastround = false
		
		if self.LastStatData and self.LastStatData[StatID] then
			lastround = self.LastStatData[StatID].Personal or false
		end
		
		self.StatData[StatID] = {}
		self.StatData[StatID].LastRound = lastround or false
		self.StatData[StatID].Info = {}
		
		for i=1,sendnum do
			local temp = {
				Ply = um:ReadEntity(),
				Score = um:ReadShort(),
				Rank = um:ReadShort(),
				MaxRank = maxrank
			}
			
			if temp.Ply == LocalPlayer() then self.StatData[StatID].Personal = temp end
			table.insert(self.StatData[StatID].Info,temp)
		end
		
		self:UpdateHUD_RoundFinishStats(StatID,self.StatData[StatID])
	end
	usermessage.Hook("LaserTag-StatSend",function(um) GAMEMODE:StatReceive(um) end)
end


function GM:CalcConquerorStat()
	if not SERVER then return end
	local res = {}
	
	for _,ply in ipairs(player.GetAll()) do
		table.insert(res,{Ply = ply,Score = ply:Frags()})
	end
	
	table.sort(res,function(a,b) return a.Score > b.Score end)
	
	return res
end

function GM:CalcTraitorStat()
	if not SERVER then return end
	local res = {}
	
	for _,ply in ipairs(player.GetAll()) do
		table.insert(res,{Ply = ply,Score = ply:Deaths()})
	end
	
	table.sort(res,function(a,b) return a.Score > b.Score end)
	
	return res
end

function GM:CalcExplorerStat()
	if not SERVER then return end
	local res = {}
	
	for _,ply in ipairs(player.GetAll()) do
		if not self.Track.Distance[ply] then self.Track.Distance[ply] = {Distance = 0,Last = false} end
		table.insert(res,{Ply = ply,Score = self.Track.Distance[ply].Distance*0.01905})
	end
	
	table.sort(res,function(a,b) return a.Score > b.Score end)
	
	return res
end

function GM:CalcPowerCrazedStat()
	if not SERVER then return end
	local res = {}
	
	for _,ply in ipairs(player.GetAll()) do
		table.insert(res,{Ply = ply,Score = self.Track.Powerups[ply] or 0})
	end
	
	table.sort(res,function(a,b) return a.Score > b.Score end)
	
	return res
end

function GM:CalcHeadHunterStat()
	if not SERVER then return end
	local res = {}
	
	for _,ply in ipairs(player.GetAll()) do
		table.insert(res,{Ply = ply,Score = self.Track.Headshots[ply] or 0})
	end
	
	table.sort(res,function(a,b) return a.Score > b.Score end)
	
	return res
end

function GM:CalcSpammerStat()
	if not SERVER then return end
	local res = {}
	
	for _,ply in ipairs(player.GetAll()) do
		table.insert(res,{Ply = ply,Score = self.Track.Shots[ply] or 0})
	end
	
	table.sort(res,function(a,b) return a.Score > b.Score end)
	
	return res
end

// STAT DEFINES (should be at bottom of file.)
STAT_CONQUERER 		= GM:AddStat("Conqueror","The player who tagged the most people",GM.CalcConquerorStat,"hud_statconqueror")
STAT_TRAITOR 		= GM:AddStat("Traitor","The player who swapped teams the most",GM.CalcTraitorStat,"hud_stattraitor")
STAT_EXPLORER 		= GM:AddStat("Explorer","The player who walked the most distance (meters)",GM.CalcExplorerStat,"hud_statexplorer")
STAT_POWERCRAZED 	= GM:AddStat("Power Crazed","The player who acquired the most powerups",GM.CalcPowerCrazedStat,"hud_statpowercrazed")
STAT_HEADHUNTER 	= GM:AddStat("Head Hunter","The player who shot the most people in the head",GM.CalcHeadHunterStat,"hud_statheadhunter")
STAT_SPAMMER 		= GM:AddStat("Spammer","The player who shot the most rounds",GM.CalcSpammerStat,"hud_statspammer")
