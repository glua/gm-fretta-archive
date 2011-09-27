
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )


include( 'shared.lua' )



for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/server/*.lua" ) ) do
	include( "modules/server/"..file )
end

for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/" .. file )
	AddCSLuaFile( "modules/shared/"..file )
end	

for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/client/*.lua" ) ) do
	AddCSLuaFile( "modules/client/"..file )
end

resource.AddFile("materials/CuratorHUD/lock.vmt")
resource.AddFile("materials/CuratorHUD/family.vmt")
resource.AddFile("materials/CuratorHUD/fancy.vmt")
resource.AddFile("materials/CuratorHUD/person.vmt")
resource.AddFile("materials/CuratorHUD/lock.vtf")
resource.AddFile("materials/CuratorHUD/family.vtf")
resource.AddFile("materials/CuratorHUD/fancy.vtf")
resource.AddFile("materials/CuratorHUD/person.vtf")
resource.AddFile("materials/effects/emp_ring.vmt")
resource.AddFile("materials/effects/emp_blast.vtf")

GM.LossAmt = 50
GM.GuardWage = 500

function GM:Initialize()

end

--[[local function CurInitPostEntity()
	timer.Simple(10,function()
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		local ent = ents.Create("thief_shop")
		ent:SetPos(v:GetPos())
		ent:Spawn()
	end
	end)
end
hook.Add("InitPostEntity","CuratorInitPostEntity",CurInitPostEntity)]]

local function KeyPressed(ply, code)
	if (not ply:GetNWBool("Curator")) and code == IN_USE then
		local tr = util.QuickTrace(ply:GetShootPos(),ply:GetAimVector()*200,ply)
		if tr.Entity and tr.Entity:IsValid() and tr.Entity:GetClass() == "thief_shop" then
			SendUserMessage("OpenThiefBuyMenu",ply)
		elseif tr.Hit and (not tr.HitSkybox) then
			for k,v in ipairs(ents.FindByClass("trigger_event")) do
				if v:IsPosInBounds(tr.HitPos) and not v.UsedAlready then
					if ply:HasItems(v.ReqItems) then
						for kz,vz in ipairs(ents.FindByName(v.RelayName)) do
							vz:Input("FireUser1",GetWorldEntity(),GetWorldEntity())
						end
						print("I've Activated the event!")
						for ka,va in ipairs(v.ReqItems) do
							for kz,vz in pairs(ply:GetItems()) do
								if string.lower(vz.Item:GetName()) == string.lower(va) then
									if vz.Entity then vz.Entity:Remove() end
									if not string.find(vz.Item:GetName(),"Crowbar") then --So you always keep the crowbar even if its required for an event.
										if vz.Item.OnRemove then vz.Item:OnRemove(ply) end
										table.remove(ply.ItemList,kz)
									end
									break
								end
							end
						end
						v.UsedAlready = true
					else
						ply:ChatPrint("This event requires "..table.concat(v.ReqItems," and ").." to run.")
					end
				elseif v:IsPosInBounds(tr.HitPos) and v.UsedAlready then
					ply:ChatPrint("This event has already been used.")
				end
			end
		end
	end
end
hook.Add("KeyPress","CuratorKeyPressed",KeyPressed)

function GM:PhysgunPickup(ply, ent)
	return false
end

function GM:PlayerNoClip( ply ) 
	return false
end

function GM:PlayerDeath(ply,inf,killr)
	ply:SetTeam(TEAM_DEAD)
	if ply ~= self.Curator and ply.ItemList then
		local ToRemove = {}
		for k,v in pairs(ply.ItemList) do
			if v.Entity then
				ply:ChatPrint("The "..v.Item:GetName().." you stole has been removed from your inventory because of death!")
				v.Entity:StopFade()
				table.insert(ToRemove,k)
			end
		end
		for k,v in ipairs(ToRemove) do
			ply.ItemList[v] = nil
		end
		ply:SendItems()
	end
	ply:SetNWInt("Detection",0)
	
	if ply ~= self.Curator then
		ply:SetMoveType(MOVETYPE_WALK)
		ply:SetNoDraw(false)
	else
		ply:SetMoveType(MOVETYPE_NOCLIP)
		local tbl = ents.FindByClass("info_curator_start")
		if tbl[1] then
			self.Curator:SetPos(table.Random(tbl):GetPos())
		end
		ply:SetNoDraw(true)
		ply:SetTeam(TEAM_CURATOR)
	end
end

function GM:ArrestPlayer(ply)
	ply.Arrested = true
	PrintMessage(HUD_PRINTCHAT,ply:Nick().." has been caught and arrested. He is out of the game for 60 seconds!")
	for k,v in pairs(ply.ItemList) do
		if v.Entity and v.Entity:IsValid() then v.Entity:StopFade() end
	end
	if ply ~= self.Curator and ply.ItemList then
		local ToRemove = {}
		for k,v in pairs(ply.ItemList) do
			if v.Entity then
				ply:ChatPrint("The "..v.Item:GetName().." you stole has been removed from your inventory because of death!")
				if v.Entity and v.Entity.StopFade then v.Entity:StopFade() end
				table.insert(ToRemove,k)
			end
		end
		for k,v in ipairs(ToRemove) do
			ply.ItemList[v] = nil
		end
		ply:SendItems()
	end
	ply:SetNWInt("money",math.floor(math.Clamp(ply:GetNWInt("money")*0.9,0,9999999)))
	ply:KillSilent()
	ply:Spectate(OBS_MODE_IN_EYE)
	ply:SpectateEntity(self.Curator)
	ply:SetMoveType(MOVETYPE_OBSERVER)
	ply:SetTeam(TEAM_JAILED)
	ply:SetPos(self.Curator:GetPos())
	ply:Lock()
	ply:SetNWInt("Detection",0)
end

function GM:UnArrestPlayer(ply)
	ply:Spectate(OBS_MODE_NONE)
	ply:UnSpectate()
	ply:SetTeam(TEAM_THIEF)
	ply:UnLock()
	ply.Arrested = false
	ply:SetNWInt("Detection",0)
end

function GM:PlayerSpawn( pl )

	if pl ~= self.Curator then
		pl:SetMoveType(MOVETYPE_WALK)
		pl:SetNoDraw(false)
		pl:SetTeam(TEAM_THIEF)
		if not pl:GetPData("hasbeenthief") then
			pl:SetPData("hasbeenthief","yah")
			SendUserMessage("OpenHelp",pl,0)
		end
	else
		pl:SetMoveType(MOVETYPE_NOCLIP)
		local tbl = ents.FindByClass("info_curator_start")
		if tbl[1] then
			self.Curator:SetPos(table.Random(tbl):GetPos())
		end
		pl:SetNoDraw(true)
		pl:SetTeam(TEAM_CURATOR)
		if not pl:GetPData("hasbeencurator") then
			pl:SetPData("hasbeencurator","yah")
			SendUserMessage("OpenHelp",pl,1)
		end
	end
	
	pl:SetNWInt("Detection",0)
	self.BaseClass.PlayerSpawn( self, pl )
end


function GM:SetupVote(name,duration,percent,OnPass,OnFail)
	self.ActiveVoting = true
	self.CurrentVote = {}
	self.CurrentVote.Name = name
	self.CurrentVote.Yes = 0
	self.CurrentVote.No = 0
	PrintMessage( HUD_PRINTTALK, "A Vote For "..name.." has commenced! You have "..duration.." seconds to vote. Just say yes or no! "..(percent*100).."% is required to pass it.")
	timer.Simple(duration,function() 
		self.ActiveVoting = nil
		if self.CurrentVote.Yes/#player.GetAll() >= percent then OnPass() else OnFail() end 
		for k,v in pairs(player.GetAll()) do
			v.HasVoted = nil
		end
		self.CurrentVote = nil
	end)
end

function GM:PlayerLoadout( ply )

	ply:RemoveAllAmmo()
	
	for k,v in pairs(ply.ItemList) do
		if v.Item.OnSpawn then 
			v.Item:OnSpawn(ply) 
		end
	end

	local cl_defaultweapon = ply:GetInfo( "cl_defaultweapon" )

	if ( ply:HasWeapon( cl_defaultweapon )  ) then
		ply:SelectWeapon( cl_defaultweapon ) 
	end
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	return (not ply == self.Curator) or attacker == self.Curator
end

function GM:ShowHelp( ply )
	umsg.Start("OpenHelp",ply)
	umsg.End()
end

local DecayFactor = 1.2

function GM:Payday()
	self.Curator:SetNWInt("money",self.Curator:GetNWInt("money")+(self.Curator:GetNWInt("happ1")*math.random(30,40)+self.Curator:GetNWInt("happ2")*math.random(60,70)+self.Curator:GetNWInt("happ3")*math.random(90,100))) -- that makes a max of 2500+5000+9000, or 16500. If you're getting this much, your thieves suck, and you pwn.
	local liquid = 0
	for k,v in ipairs(ents.FindByClass("curator_*")) do
		if v.Item then
			if v.Item:GetFamilyHappiness() > 0 then
				v.Item:SetFamilyHappiness(math.Clamp(v.Item:GetFamilyHappiness()/DecayFactor,0.25,100))
			elseif v.Item:GetFamilyHappiness() < 0 then
				v.Item:SetFamilyHappiness(math.Clamp(v.Item:GetFamilyHappiness()/DecayFactor,-100,-0.25))
			end
			if v.Item:GetEnthusistHappiness() > 0 then
				v.Item:SetEnthusistHappiness(math.Clamp(v.Item:GetEnthusistHappiness()/DecayFactor,0.25,100))
			elseif v.Item:GetEnthusistHappiness() < 0 then
				v.Item:SetEnthusistHappiness(math.Clamp(v.Item:GetEnthusistHappiness()/DecayFactor,-100,-0.25))
			end
			if v.Item:GetCollectorHappiness() > 0 then
				v.Item:SetCollectorHappiness(math.Clamp(v.Item:GetCollectorHappiness()/DecayFactor,0.25,100))
			elseif v.Item:GetCollectorHappiness() < 0 then
				v.Item:SetCollectorHappiness(math.Clamp(v.Item:GetCollectorHappiness()/DecayFactor,-100,-0.25))
			end
		end
	end
	local JItems = Junk.GetItems()
	local entz = ents.FindByClass("info_junk_spawn")
	for i=1,5 do
		local item = table.Random(JItems)
		local v = table.Random(entz)
		item:OnSpawn(GetWorldEntity(),v:GetPos(),Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)))
	end
	self.Curator:SetNWInt("money",math.floor(self.Curator:GetNWInt("money"))-(self.GuardWage*(#ents.FindByClass("curator_guard") or 0)))
end

function GM:ShowTeam(ply)

end

function GM:ShowSpare1(ply)

end

function GM:ShowSpare2(ply)

end

local SelectionWeights = {}
SelectionWeights.__mode = "k" --weak keys, so it's rmeoved when the player is unreferenced.

function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
	SelectionWeights[ply] = 1
	ply.ItemList = {}
	ply:SetDeaths(SelectionWeights[ply])
	timer.Simple(5,function()
	for k,v in ipairs(ents.FindByClass("trigger_ladder")) do
		SendUserMessage("RecieveLadder",ply,v:LocalToWorld(v:OBBMaxs()),v:LocalToWorld(v:OBBMins()))
	end
	end)
	
end

function GM:PlayerDisconnected( ply )
	SelectionWeights[ply] = nil
	for k,v in ipairs(ply.ItemList) do
		if v.Entity and ValidEntity(v.Entity) then v.Entity:StopFade() end
	end
end

function GM:TriggerAlarm(sndPos)
	if not self.Alarming then
		self.Alarming = true
		WorldSound("Trainyard.distantsiren",sndPos,165,100)
		SendUserMessage("StartAlarmCountdown")
		timer.Simple(25,function() 
			self.Alarming = false
			for k,v in ipairs(player.GetAll()) do
				if v:GetPos():IsInMuseum() and v ~= self.Curator then
					GAMEMODE:ArrestPlayer(v)
					SendUserMessage("YouBeenArrested",v)
					timer.Simple(45,function() GAMEMODE:UnArrestPlayer(v) SendUserMessage("YouveBeenReleased",v) end)
				end
			end
		end)
	end
end

function GM:StealArt(ply,ent,item)
	if (not self.GraceTime) and #ply:GetItems() < 5 then
		if ent.Fade then ent:Fade(3) end
		ply:Lock()
		SendUserMessage("StealingProgressBar",ply)
		timer.Simple(3,function()
			ply:UnLock()
			ply:GiveStolenItem(item,ent)
		end)
	else
		ply:ChatPrint("Your inventory is full, so you can't pick up that "..item:GetName().."!")
	end
end

function GM:Think()
	if self.Curator and self.Curator:IsValid() then
		self.Curator:SetMoveType(MOVETYPE_NOCLIP)
		self.Curator:SetNoDraw(true)
	elseif #player.GetAll() >= 1 then
		RoundTimer.CurrentTime = RoundTimer.RoundTime
		hook.Call("RoundStarted")
	else
		self.Curator = nil
	end
	for k,v in ipairs(player.GetAll()) do
		v:SetNWBool("Curator",v == self.Curator)
		v:SetFrags(v:GetNWInt("money"))
		if v ~= self.Curator and v:Team() == TEAM_THIEF and v:Alive() and v:GetNWInt("Detection") >= 1000 then
			self:TriggerAlarm(v:GetPos())
		end
		if not v:GetPos():IsInMuseum() then
			v:SetNWInt("Detection",math.Clamp(v:GetNWInt("Detection")-2,0,1000))
		end
		if v == self.Curator then v:SetTeam(TEAM_CURATOR) end
	end
	if self.Curator then
		local val1,val2,val3 = 0,0,0
		local liquid = 0
		for k,v in ipairs(ents.FindByClass("curator_*")) do
			if v.Item then
				val1 = val1 + v.Item:GetFamilyHappiness()
				val2 = val2 + v.Item:GetEnthusistHappiness()
				val3 = val3 + v.Item:GetCollectorHappiness()
				if not Security.GetItem(v.Item:GetName()) then
					liquid = liquid + v.Item:GetPrice()*(0.1*math.Clamp(#player.GetAll()-1,1,10))
				end
			end
		end
		self.Curator:SetNWInt("happ1", math.Clamp(val1,0,100)) 
		self.Curator:SetNWInt("happ2", math.Clamp(val2,0,100)) 
		self.Curator:SetNWInt("happ3", math.Clamp(val3,0,100))
		self.Curator:SetNWInt("liquid",liquid)
	end
end 

local num = 0
function GM:CalledPerSecond()
	if not self.Curator then return end
	num = num + 1
	if num >= 3 then
		num = 0
		if #ents.FindByClass("curator_art") < 1 and not self.GraceTime then
			self.Curator:SetNWInt("money",math.Clamp(self.Curator:GetNWInt("money")-self.LossAmt,0,math.huge))
		end
		if (not self.GraceTime) and self.Curator:GetNWInt("money") == 0 and self.Curator:GetNWInt("happ1") == 0 and self.Curator:GetNWInt("happ2") == 0 and self.Curator:GetNWInt("happ3") == 0 then
			RoundTimer.EndRound()
		end
	end
end

function GM:ResetMap()
	game.CleanUpMap()
end

function table.WeightedRandom(weights)
	--[[local selectTbl = {}
	for k,v in pairs(tbl) do
		for i=1,(weights[v] or 1) do
			table.insert(selectTbl,v)
		end
	end
	return table.Random(selectTbl)]]
	local winner = {}
	for k,v in pairs(weights) do
		if k ~= "__mode" then
			if (not winner[1]) or v>=weights[winner[1]] then
				table.insert(winner,k)
			end
		end
	end
	return table.Random(winner)
end
--[[
function table.Random (t)
  debug.Trace()
  PrintTable(t)
  local rk = math.random( 1, table.Count( t ) )
  local i = 1
  for k, v in pairs(t) do
    if ( i == rk ) then return v end
    i = i + 1
  end

end]]

function GM:RoundBegin()
	self.GraceTime = true
	self:ResetMap()
	for k,v in ipairs(player.GetAll()) do
		v:SetNWBool("Curator",false)
		v:SetNWInt("money",0)
		v:StripWeapons()
		v:KillSilent()
		v:SetTeam(TEAM_THIEF)
		v:SetNoDraw(false)
		v.ItemList = {}
		v:SendItems()
	end
	local old = self.Curator
	if old and old:IsValid() then SelectionWeights[old] = 0 end
	self.Curator = nil
	self.Curator = table.WeightedRandom(SelectionWeights)
	if old and old:IsValid() then SelectionWeights[old] = 1 old:SetDeaths(SelectionWeights[old]) end
	self.Curator:SetDeaths(SelectionWeights[self.Curator])
	SelectionWeights[self.Curator] = 0
	self.Curator:SetNWBool("Curator",true)
	self.Curator:SetNWInt("money",10000)
	self.Curator:SetTeam(TEAM_CURATOR)
	self.Curator:SetNoDraw(true)
	
	local tbl = ents.FindByClass("info_curator_start")
	if tbl[1] then
		self.Curator:SetPos(table.Random(tbl):GetPos())
	end
    umsg.Start("SetupCuratorSpawnMenu", self.Curator)
    umsg.End()
	timer.Simple(1,function()
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		local ent = ents.Create("thief_shop")
		ent:SetPos(v:GetPos())
		ent:Spawn()
	end
	
	
	
	local JItems = Junk.GetItems()
	for k,v in ipairs(ents.FindByClass("info_junk_spawn")) do
		local item = table.Random(JItems)
		item:OnSpawn(GetWorldEntity(),v:GetPos(),Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)))
	end
	
	for k,v in ipairs(ents.FindByClass("info_art_spawn")) do
		local item = table.Random(_G[table.Random{"Family","Fancy","Enthusist"}].GetItems())
		item:OnSpawn(self.Curator,v:GetPos(),Angle(0,0,0))
	end
	self.GraceTime = false
	end
	)
end
--[[
local function FadingShouldCollide(e1,e2)
	if ((e1:IsPlayer() or e2:IsPlayer()) and (e1.Fading or e2.Fading)) or (e1:IsPlayer() and e2:IsPlayer()) then
		return false
	else
		return true
	end
end
hook.Add("ShouldCollide","CuratorFadingShouldCollide",FadingShouldCollide)]]

function GM:PlayerSwitchFlashlight(ply,switch)
	if ply ~= self.Curator then return true end
	return false
end

function GM:CanPlayerSuicide(ply)
	return false
end

function GM:RoundEnd()
	self.GraceTime = true
	for k,v in ipairs(player.GetAll()) do
		v:Lock()
		v:ConCommand("OpenEndGameWindow")
		SelectionWeights[v] = SelectionWeights[v] + 1
		v:SetDeaths(SelectionWeights[v])
		v:SetNWBool("Curator",false)
		v:KillSilent()
		for kz,vz in pairs(v.ItemList) do
			if vz.Entity and vz.Entity:IsValid() then vz.Entity:StopFade() end
		end
		v.ItemList = {}
		v:SendItems()
	end
	
	timer.Simple(RoundTimer.GraceTime,function()
		for k,v in ipairs(player.GetAll()) do
			v:UnLock()
			v:ConCommand("CloseEndGameWindow")
		end
	end)
end

local function FixStrings(...)
	local tbl = {...}
	for k,v in pairs(tbl) do
		tbl[k] = tonumber(v)
	end
	return unpack(tbl)
end

local Down = Vector(0,0,-170)
local trace = {}


concommand.Add("curator_spawn_object",function(ply,cmd,args)
    local AType = args[1]
    local name = args[2]
    local ang = Angle(FixStrings(unpack(string.Explode(" ",args[3]))))
    local pos = Vector(FixStrings(unpack(string.Explode(" ",args[4]))))
    local item = _G[AType].GetItems()[name]
    
    if ply == GAMEMODE.Curator and ply:GetNWInt("money") >= item:GetPrice() then
		if item:LimitCheck() < item:GetLimit() then
			if pos:IsInMuseum() then
				trace.start = pos
				trace.endpos = pos+Down
				trace.mask = MASK_SOLID_BRUSHONLY
				local tr = util.TraceLine(trace)
				if (tr.Hit and tr.HitWorld) or AType == "Security" then
					ply:SetNWInt("money",ply:GetNWInt("money") - item:GetPrice())
					item:OnSpawn(ply,pos,ang)
				else
					ply:ChatPrint("You can't spawn that "..item:GetName().." so high off the ground! Now that would just be unsporting!")
				end
			else
				ply:ChatPrint("You can't spawn that "..item:GetName().." outside the museum!")
			end
		else
			ply:ChatPrint("You've hit the limit for "..item:GetName()..". Its limit is "..item:GetLimit()..".")
		end
	else
		ply:ChatPrint("You don't have enough money for that "..item:GetName()..". It costs $"..item:GetPrice()..".")
    end

end)

concommand.Add("CuratorUpdateEnt",function(ply,cmd,args)
	local idx = args[1]
	local ent = ents.GetByIndex(idx)
	if ply == GAMEMODE.Curator and ent and ent.RequestItem then
		ent:RequestItem()
	end
end)

concommand.Add("CuratorMoveDone",function(ply,cmd,args)
	local ent = ents.GetByIndex(args[1])
    local ang = Angle(FixStrings(unpack(string.Explode(" ",args[2]))))
    local pos = Vector(FixStrings(unpack(string.Explode(" ",args[3]))))
	if not pos:IsInMuseum() then
		ply:ChatPrint("You cannot move that object outside the museum!")
	elseif ply == GAMEMODE.Curator and ent and ent:IsValid() and string.find(ent:GetClass(),"curator_") then
		trace.start = pos
		trace.endpos = pos+Down
		trace.mask = MASK_SOLID_BRUSHONLY
		local tr = util.TraceLine(trace)
		if tr.Hit and tr.HitWorld then 
			local temp = ents.Create("prop_physics")
			temp:SetModel(ent:GetModel())
			temp:SetPos(pos)
			temp:SetAngles(ang)
			temp:Spawn()
			temp:Activate()
			temp:SetColor(255,255,255,100)
			temp:GetPhysicsObject():EnableMotion(false)
			timer.Simple(7,function(temp,ent,pos,ang) 
				if temp and temp:IsValid() then temp:Remove() end
				if ent and ent:IsValid() then
					ent:SetPos(pos)
					ent:SetAngles(ang)
				end
			end,temp,ent,pos,ang)
		else
			ply:ChatPrint("You cannot place that so far off the ground, the building inspector forbids it.")
		end
	else
		ply:ChatPrint("You cannot move that object!")
	end
end)

concommand.Add("UpdateItems",function(ply,com,arg)
	ply:SendItems()
end)

concommand.Add("SellItem", function(ply,cmd,arg)
	ply:SellItem(arg[1])
	ply:SendItems()
end)

concommand.Add("BuyItem", function(ply,cmd,arg)
	ply:BuyItem(arg[1])
	print("Buying",arg[1])
	ply:SendItems()
end)

concommand.Add("CuratorSellOff",function(ply,cmd,arg) 
	local ent = ents.GetByIndex(arg[1])
	if ent and ent:IsValid() and string.find(ent:GetClass(),"curator_") and ent.Item then
		if (not ent.Fading) or Security.GetItem(ent.Item:GetName()) then
			ply:SetNWInt("money",ply:GetNWInt("money")+(ent.Item:GetPrice()*0.25))
			if timer.IsTimer(ent:EntIndex().."Reenable") then timer.Destroy(ent:EntIndex().."Reenable") end
			ent:Remove()
		else
			ply:ChatPrint("You can't sell what is being stolen!")
		end
	else
		ply:ChatPrint("You can't sell that off!")
	end
end)

concommand.Add("CuratorHardenSecurity",function(ply,cmd,arg)
	local ent = ents.GetByIndex(arg[1])
	if ent and ent:IsValid() and string.find(ent:GetClass(),"curator_") and ent.Item then
		if ply:GetNWInt("money") >= math.Clamp(ent.Item:GetPrice()*0.5,500,math.huge) then
			if Security.GetItem(ent.Item:GetName()) then
				ply:SetNWInt("money",ply:GetNWInt("money")-math.Clamp(ent.Item:GetPrice()*0.5,500,math.huge))
				ent.Hardened = true
			else
				ply:ChatPrint("You can't harden something that is not security!")
			end
		else
			ply:ChatPrint("You don't have enough money to harden that "..ent.Item:GetName().." you need $"..math.Clamp(ent.Item:GetPrice()*0.5,500,math.huge))
		end
	else
		ply:ChatPrint("You can't harden that!")
	end
end)

hook.Add("RoundStarted","CuratorRoundStart",function() 
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		if v.StartRelayName then
			for k,v in ipairs(ents.FindByName(v.StartRelayName)) do
				v:Input("FireUser1",GetWorldEntity(),GetWorldEntity())
			end
		end
	end
	GAMEMODE:RoundBegin()
end)

hook.Add("GraceTime","CuratorGraceTime", function()
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		if v.EndRelayName then
			for k,v in ipairs(ents.FindByName(v.EndRelayName)) do
				v:Input("FireUser2",GetWorldEntity(),GetWorldEntity())
			end
		end
	end
	GAMEMODE:RoundEnd()
end)

--Redistributable datastream fix.
local META = FindMetaTable("CRecipientFilter")
if META then
	function META:IsValid()
		return true
	end
else
	ErrorNoHalt(os.date().." Failed to fix datastream fuckup: \"CRecipientFilter\"'s metatable invalid.")
end

local Vec = FindMetaTable("Vector")
function Vec:IsInMuseum()
	for k,v in ipairs(ents.FindByClass("trigger_museum")) do
		if v:IsPosInBounds(self) then
			return true
		end
	end
	return false
end


function Vec:IsInLadder()
	for k,v in ipairs(ents.FindByClass("trigger_ladder")) do
		if v:IsPosInBounds(self) then
			return true
		end
	end
	return false
end

local Entity = FindMetaTable("Entity")
function Entity:RequestItem()
	if self.Item and GAMEMODE.Curator then
		SendUserMessage("RecieveCuratorEntItem",GAMEMODE.Curator,self:EntIndex(),self.Item:GetName(),self.IType)
	end
end
