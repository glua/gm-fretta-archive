include( "util.lua" )
include( "sv_medals.lua" )

function GM:OnPreRoundStart( n )
	self.BaseClass:OnPreRoundStart( n )
	ta.SpawnEntities()
end

function GM:OnRoundStart( n )
	self.BaseClass:OnRoundStart( n )
	if not GAMEMODE.Squads.red[1] or not GAMEMODE.Squads.blu[1] then
		CreateSquads(GAMEMODE.Squads.red,1)
		CreateSquads(GAMEMODE.Squads.blu,2)
	end
	GAMEMODE.Red.Spawns = {}
	GAMEMODE.Blu.Spawns = {}
	//for _,v in ipairs(player.GetAll()) do v:ConCommand("ta_printsquads") end
	for _,v in ipairs(player.GetAll()) do v:ChatPrint("The round has begun! Go capture those points!") v:UnLock() v:Freeze(false) end
	for _,v in ipairs(ents.FindByClass("obj_*")) do v:SetNWBool("ObjectiveComplete",false) end
	
	umsg.Start("stopRoundSound") umsg.End()
end

function GM:OnRoundEnd( n )
	self.BaseClass:OnRoundEnd( n )
	local winner = GetGlobalInt("RoundResult")
	local rp1,rp2 = RecipientFilter(),RecipientFilter()
	for _,v in ipairs(player.GetAll()) do if v:Team() == 1 then rp1:AddPlayer(v) elseif v:Team() == 2 then rp2:AddPlayer(v) end end
	umsg.Start("endRoundSound",rp1)
		if winner == 1 then umsg.Bool(true) else umsg.Bool(false) end
	umsg.End()
	umsg.Start("endRoundSound",rp2)
		if winner == 2 then umsg.Bool(true) else umsg.Bool(false) end
	umsg.End()
	
	// MVP Medal
	local mvp,total = nil,0
	for _,v in ipairs(player.GetAll()) do
		if v:Frags() > total then
			mvp = v
			total = v:Frags()
		end
	end
	MEDALS:Register("Most Valuable Player","",mvp,total)
	
	// medals here
	MEDALS:Check()
	for k,v in pairs(MEDALS:GetAll()) do
		local winner = v.winner
		if ValidEntity(winner) then winner = winner:Name()
		else winner = "Nobody!" end
		ta.Message(k..": "..winner.." ("..tostring(v.winval)..")")
	end
	
	GAMEMODE.Red.Spawns = {}
	GAMEMODE.Blu.Spawns = {}
	
end

function GM:CanStartRound( n )
	return ta.Players() >= 6
end

function CaptureRound(ent,t,cappers)
	ta.Message(team.GetName(t).." has captured a control point!")
	local objs = ents.FindByClass("obj_capture")
	local letter = ent:GetNWString("ta-capname")
	
	GAMEMODE.Red.Spawns[letter] = nil
	GAMEMODE.Blu.Spawns[letter] = nil
	
	if t == 1 then
		local spawns = {}
		for i = 1,3 do
			local newspawn = ents.Create("info_target")
			newspawn:SetPos(ent:GetPos() + Vector(i * 5 - 5, i * 5 - 5,10))
			newspawn:Spawn()
			newspawn:Activate()
			table.insert(spawns,newspawn)
		end
		GAMEMODE.Red.Spawns[ent:GetNWString("ta-capname")]=spawns
	else
		local spawns = {}
		for i = 1,3 do
			local newspawn = ents.Create("info_target")
			newspawn:SetPos(ent:GetPos() + Vector(i * 5 - 5, i * 5 - 5,10))
			newspawn:Spawn()
			newspawn:Activate()
			table.insert(spawns,newspawn)
		end
		GAMEMODE.Blu.Spawns[ent:GetNWString("ta-capname")]=spawns
	end
	
	if GAMEMODE.Mode == "capture" then
	
		local capped = 0
		for _,v in ipairs(objs) do
			if v:GetNWInt("HasCapped") == 1 then capped = capped + 1
			elseif v:GetNWInt("HasCapped") == 2 then capped = capped - 1
			end
		end
		
		local pts_added = {}
		for _,v in ipairs(cappers) do
			if !table.HasValue(pts_added,v) then 
				v:AddFrags(10)
				table.insert(pts_added,v)
			end
		end
		
		if capped == #objs then GAMEMODE:RoundEndWithResult(1,"Team Red wins!")
			GAMEMODE.Red.Spawns = {}
			GAMEMODE.Blu.Spawns = {}
		elseif capped == #objs * -1 then GAMEMODE:RoundEndWithResult(2,"Team Blue wins!")
			GAMEMODE.Red.Spawns = {}
			GAMEMODE.Blu.Spawns = {}
		end
		
		for _,v in ipairs(objs) do v:SetNWBool("ObjectiveComplete",true) end
		
	end
	DB.Save()
end
hook.Add("ta_capwon","CaptureRound",CaptureRound)

function BombRound(t,detonated,boomer)
	if detonated then
		ta.Message(team.GetName(t).." detonated the bomb!")
	else
		ta.Message(team.GetName(t).." has defused the bomb!")
	end
	
	boomer:AddFrags(15)
	GAMEMODE.Red.Spawns = {}
	GAMEMODE.Blu.Spawns = {}
	
	if t == 2 then GAMEMODE:RoundEndWithResult(t,"Blue Team Wins!")
	elseif t== 1 then GAMEMODE:RoundEndWithResult(t,"Red Team Wins!") end
	DB.Save()
	
	GAMEMODE:SwitchTeams()
end
hook.Add("ta_bombwon","BombRound",BombRound)

function GM:SwitchTeams()
	local t1,t2 = team.GetPlayers(1),team.GetPlayers(2)
	for _,v in ipairs(t1) do v:SetTeam(2) end
	for _,v in ipairs(t2) do v:SetTeam(1) end
end

function GM:OnEndOfGame()
	self.BaseClass:OnEndOfGame()
	
	// MVP Medal
	local mvp,total = nil,0
	for _,v in ipairs(player.GetAll()) do
		if v:Frags() > total then
			mvp = v
			total = v:Frags()
		end
	end
	MEDALS:Register("Most Valuable Player","",mvp,total)
	
	// medals here
	MEDALS:Check()
	for k,v in pairs(MEDALS:GetAll()) do
		local winner = v.winner
		if ValidEntity(winner) then winner = winner:Name()
		else winner = "Nobody!" end
		ta.Message(k..": "..winner.." ("..tostring(v.winval)..")")
	end
end