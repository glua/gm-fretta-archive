// Create Squads func
GM.Squads = {red = {}, blu = {}}
GM.Red, GM.Blu = {Spawns = {}}, {Spawns = {}}
GM.SquadMax = 3
function CreateSquads(sqd,tm)
	local availplys = team.GetPlayers(tm)
	
	local ldr = availplys[1]
	for k,v in ipairs(availplys) do
		ldr = ta.ComparePoints(ldr,v)
	end
	ta.Message("You've been selected to become General!",false,{ldr})
	ldr:SetNWBool("General",true)

	for i = 1, math.max(math.ceil(team.NumPlayers(tm)/3),1) do
		local tbl = {}
		for n = 1, math.min(table.Count(availplys),3) do
			local num = math.random(1,table.Count(availplys))
			table.insert(tbl,availplys[num])
			table.remove(availplys,num)
		end
		local pts = {-1,nil}
		/*for _,v in pairs(tbl) do 
			if DB.GetPoints(v) + DB.GetPlays(v) * 5 > pts[1] then 
				pts[1] = DB.GetPoints(v)
				pts[2] = v
			end
		end
		for _,v in pairs(tbl) do 
			if v == pts[2] then 
				v:SetLeader()  
				tbl.leader = v
			else 
				v:RemoveLeader() 
			end 
		end*/
		local ldr = tbl[1]
		for _,v in ipairs(tbl) do ldr = ta.ComparePoints(v,ldr) end
		tbl.leader = ldr
		tbl.name = "Squad "..i
		table.insert(sqd,tbl)
		
		for c,v in pairs(tbl) do	
			if c != "name" and c != "leader" then 
				v:SetSquad(tbl)
				umsg.Start("sendSquad",v)
					umsg.Entity(tbl.leader)
					umsg.Short(GAMEMODE.SquadMax)
					for k,q in pairs(tbl) do if k !="name" and k != "leader" and q != tbl.leader then
						umsg.Entity(q)
					end end
				umsg.End()
			end
		end
		
	end
	
end

/* HOW IT WORKS:
	< 16 players = 3 person squads
	16 - 29 players = 4 person squads
	30 - 47 = 5 player squads
	> 48 = 6 player squad
*/ 

function CheckSquads( pl )

	if ta.Players() == 16 and GAMEMODE.SquadMax != 4 then 
		GAMEMODE.SquadMax = 4
		ta.Message("Squads are now 4 people.",true)
	elseif ta.Players() == 30 and GAMEMODE.SquadMax != 5 then 
		GAMEMODE.SquadMax = 5
		ta.Message("Squads are now 5 people!",true)
	elseif ta.Players()  >= 48 and GAMEMODE.SquadMax != 6 then 
		GAMEMODE.SquadMax = 6
		ta.Message("Squads are now 6 people!",true)
	elseif ta.Players() < 16 and GAMEMODE.SquadMax != 3 then
		GAMEMODE.SquadMax = 3 
		ta.Message("Squads are now 3 people!",true)
	end

	/*print("Attempting to place ".. pl:Name() .. " in a squad...")
	print("	"..tostring(pl:GetSquad()))
	print("	"..tostring(GAMEMODE:InRound()))
	print("	"..pl:Team())*/
	
	
	// Put them in a squad if not already done
	if not pl:GetSquad() and GAMEMODE:InRound() and pl:Team() != 0 and pl:Team() != 1001 then
		local in_squad = false
		local sqd = {}
		if pl:Team() == 1 then
			for _,v in pairs(GAMEMODE.Squads.red) do
				if not v[GAMEMODE.SquadMax] then 
					table.insert(v,pl)
					in_squad = true
					// DETERMINE IF HE'S A BETTER LEADER
						local ldr = pl
						for _,ply in ipairs(v) do
							ldr = ta.ComparePoints(ldr,ply)
						end
						v.leader = pl
					sqd = v
					break
				end
			end
			if not in_squad then
				sqd = {name = "Squad " ..table.Count(GAMEMODE.Squads.blu), pl, leader = pl}
				table.insert(GAMEMODE.Squads.red, sqd)
			end
		elseif pl:Team() == 2 then
			for _,v in pairs(GAMEMODE.Squads.blu) do
				if not v[GAMEMODE.SquadMax] then 
					table.insert(v,pl)
					in_squad = true
					// DETERMINE IF HE'S A BETTER LEADER
						local ldr = pl
						for _,ply in ipairs(v) do
							ldr = ta.ComparePoints(ldr,ply)
						end
						v.leader = ldr
					sqd = v
					break
				end
			end
			if not in_squad then
				sqd = {name = "Squad " ..table.Count(GAMEMODE.Squads.blu), pl, leader = pl}
				table.insert(GAMEMODE.Squads.blu, sqd)
			end
		end
		pl:SetSquad(sqd)
			
		for c,v in pairs(sqd) do	
			if c != "name" and c != "leader" then 
				v:SetSquad(sqd)
				umsg.Start("sendSquad",v)
					umsg.Entity(sqd.leader)
					umsg.Short(GAMEMODE.SquadMax)
					for k,q in pairs(sqd) do if k !="name" and k != "leader" and q != sqd.leader then
						umsg.Entity(q)
					end end
				umsg.End()
			end
		end
	end
end
hook.Add("PlayerSpawn","CheckSquads",CheckSquads)

function CheckSquadsOnTeamChange(pl)
	pl:SetSquad(nil)
	
	CheckSquads(pl)
end
hook.Add("OnPlayerChangedTeam","CheckSquadsOnTeamChange",CheckSquadsOnTeamChange)
