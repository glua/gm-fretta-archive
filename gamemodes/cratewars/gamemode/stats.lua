function GM:resetStats(ply)
	ply.stats = {}
	ply.stats["placed"] = 0
	ply.stats["broken"] = 0
	ply.stats["kills"] = 0
	ply.stats["caps"] = 0
	ply.stats["nades"] = 0
end

function getHighest()
	local highest = {}
	local ply = nil
	for _,v in pairs( player.GetAll() ) do
		ply = v
	end
	
	for statType, _ in pairs(ply.stats) do
		highest[statType] = ply
	end
	highest["wrong"] = ply
	highest["mvp"] = ply
	
	for _,v in pairs( player.GetAll() ) do
		for statType, _ in pairs(v.stats) do
			if(v.stats[statType] >= highest[statType].stats[statType])then highest[statType] = v end
		end
		if(v:Deaths() >= highest["wrong"]:Deaths())then highest["wrong"] = v end
		if(v:Frags() >= highest["mvp"]:Frags())then highest["mvp"] = v end
	end
	
	return highest
end

function GM:addStat(ply, stat, ammount)
	if (GetGlobalBool( "InRound", false))then
		ply.stats[stat] = ply.stats[stat]+ammount
	end
end

function GM:displayStat(msg)
	highestPlayers = getHighest()
	for _,ply in pairs( player.GetAll() ) do
		datastream.StreamToClients( ply, "Stats", {["team"]=msg, ["highplayers"]=highestPlayers, ["stats"]=ply.stats})
	end
end

function OnDeathStat( v, i ,k )
	if(v != k) and (k:IsPlayer())then
		GAMEMODE:addStat(k, "kills", 1)
	end
end
hook.Add("PlayerDeath", "StatOnDeath", OnDeathStat)