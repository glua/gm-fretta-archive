local TIME_MANHACKS = 60
local TIME_TURRET = 120
local TIME_DISPENSER = 60

local build_sounds = {
	Sound("ta/build/build1.mp3"),
	Sound('ta/build/build2.wav'),
}

concommand.Add("techie_barrier",function(pl,cmd,args)
	if pl:GetPlayerClassName() != "Techie" then return end
	
	if pl:GetActiveWeapon():GetClass() == "weapon_techie" then
		pl:GetActiveWeapon():MakeGhost(tonumber(args[1]))
	end
end)

concommand.Add("techie_manhacks",function(pl)
	if pl:GetPlayerClassName() != "Techie" then return end
	local last = pl:GetNWInt("ta-lasthack")
	if CurTime() - last < TIME_MANHACKS && last != 0 then pl:ChatPrint("You have "..tostring(math.ceil(TIME_MANHACKS - (CurTime() - last))).." more seconds til your next manhack strike.") return end
	
	for i = 1,4 do
		local npc = ents.Create("npc_manhack")
		local tr = pl:GetEyeTrace()
		if tr.HitPos:Distance(pl:EyePos()) > 300 then npc:SetPos(pl:EyePos() + pl:GetAimVector() * 1000 + Vector(0,0,i * 15))
		else npc:SetPos(tr.HitPos + Vector(0,0,i*15)) end
		npc:SetKeyValue("squadname",pl:SteamID())
		
		for k,_ in pairs(team.GetAllTeams()) do
			for _,v in ipairs(team.GetPlayers(k)) do
				if k != pl:Team() then npc:AddEntityRelationship(v,D_HT,99)
				else npc:AddEntityRelationship(v,D_LI,99) end
			end
		end
		
		npc:SetMaxHealth(75)
		npc:SetHealth(75)
		npc:Spawn()
		npc:Activate()
		npc:SetNWEntity("ta-owner",pl)
	end
	pl:EmitSound(table.Random(build_sounds))
	pl:SetNWInt("ta-lasthack",CurTime())
end)

concommand.Add("techie_spawner",function(pl)
	if pl:GetPlayerClassName() != "Techie" then return end
	if CurTime() - pl:GetDispenserTime() < TIME_DISPENSER then pl:ChatPrint("You have "..tostring(math.ceil(TIME_DISPENSER - (CurTime() - pl:GetDispenserTime()))).." more seconds before spawning another item spawner.") end
	if not pl:GetDispenser() then
		local tr = pl:GetEyeTrace()
		local item = ents.Create("sent_weaponspawner")
		if tr.HitPos:Distance(pl:EyePos()) > 300 then 
			item:SetPos(pl:EyePos() + pl:GetAimVector() * 300)
			item:DropToFloor()
		else item:SetPos(tr.HitPos) end
		item:SetAngles(Angle(0,pl:GetAngles().yaw + 180,0) )
		item:Spawn()
		item:Activate()
		pl:SetDispenser(item)
		pl:SetDispenserTime(CurTime())
	else pl:ChatPrint("You already have a dispenser!") end
end)

concommand.Add("techie_turret",function(pl)
	if pl:GetPlayerClassName() != "Techie" then return end
	local last = pl:GetNWInt("ta-lastturret")
	if CurTime() - last < TIME_TURRET && last != 0 then pl:ChatPrint("You have "..tostring(math.ceil(TIME_TURRET - (CurTime() - last))).." more seconds before spawning another turret.") return end

	local prev_ent = pl:GetNWEntity("ta-turret")
	if prev_ent and prev_ent:IsValid() and prev_ent:GetClass() == "npc_turret_floor" then pl:ChatPrint("You already have a turret!") return end

	local npc = ents.Create("npc_turret_floor")
	local tr = pl:GetEyeTrace()
	if tr.HitPos:Distance(pl:EyePos()) > 300 then npc:SetPos(pl:EyePos() + pl:GetAimVector() * 300)
	else npc:SetPos(tr.HitPos) end
	
	for k,_ in pairs(team.GetAllTeams()) do
		for _,v in ipairs(team.GetPlayers(k)) do
			if k != pl:Team() then npc:AddEntityRelationship(v,D_HT,99)
			else npc:AddEntityRelationship(v,D_LI,99) end
		end
	end
	
	npc:Spawn()
	npc:Activate()
	npc:SetNWEntity("ta-owner",pl)
	pl:EmitSound(table.Random(build_sounds))
	pl:SetNWEntity("ta-turret",npc)
	pl:SetNWInt("ta-lastturret",CurTime())
end)

hook.Add("Think","CheckTechies",function()
	for _,v in ipairs(table.Add(table.Add(ents.FindByClass("npc_manhack"),ents.FindByClass("npc_turret_floor")),ents.FindByClass("ent_barrier"))) do
		local owner = v:GetNWEntity("ta-owner")
		if !owner or !owner:IsValid() or !owner:IsConnected() or owner:GetPlayerClassName() != "Techie" || (!owner:Alive() && (v:GetClass() == "npc_manhack" || v:GetClass() == "npc_turret_floor")) then 
			v:Remove()
		end
		
		if owner and owner:IsValid() and owner:GetPlayerClassName() != "Techie" then
			owner:SetNWInt("ta-barriercount",0)
			owner:SetNWEntity("ta-turret",nil)
		end
	end
end)