

local meta = FindMetaTable( "Player" )
if (!meta) then return end

function meta:Level()
	return self:GetNWInt("level")
end
function meta:SetLevel(num)
	self:SetNWInt("level", num)
	levels[num]["func"](self)
end

function meta:AddUpgrade(strUpgrade)
	table.insert(self.Upgrades, strUpgrade)
end
function meta:RemoveUpgrade(strUpgrade)
	if table.HasValue(self.Upgrades, strUpgrade) then
		for a,b in pairs(upgrades) do
			if b["name"] == strUpgrade then
				b["func_undo"](self)
				for c,d in pairs(self.Upgrades) do
					if d == strUpgrade then
						table.remove(self.Upgrades,c)
					end
				end
			end
		end
	end
	PrintTable(self.Upgrades)
end
function meta:GiveValidUpgrade()

	local hasallupgrades = false
	local temp_upgrades = {}
	
	if #temp_upgrades == #upgrades then
		hasallupgrades = false
	else
		hasallupgrades = true
	end
	for k,v in pairs(upgrades) do
		if not table.HasValue(self.Upgrades, v["name"]) then
			table.insert(temp_upgrades,v)
		end
	end
	
	local allowed = table.Random(temp_upgrades)
	
	if hasallupgrades == false then
		self:AddUpgrade(allowed["name"])
		allowed["func"](self)
		self:ChatPrint("You have gained the "..string.upper(allowed["name"]).." upgrade! "..allowed["desc"])
	else
		self:ChatPrint("You have every upgrade!")
	end
	PrintTable(self.Upgrades)
	
end

function meta:CaughtCactus(ent)
	
	if ValidEntity(ent:GetParent()) and ent:GetParent():GetClass() == "chainlink_ghost" and ent:GetParent():GetOwner() != self then return end
	
	if ent:GetClass() != "cactus" then return end
	ent.IsSpamming = 0
	local entdata = {}
	entdata["type"] = ent:GetCactusType()
	entdata["score"] = ent.CactusData[ent:GetCactusType()]["score"]
	
	if ValidEntity(ent) then
		
		if entdata["type"] != "explosive" then
			
			SafeRemoveEntity( ent )
			
			if entdata["type"] == "golden" then
				for k,v in pairs(player.GetAll()) do
					v:ChatPrint(self:Name().." caught the "..string.upper(entdata["type"]).." cactus!")
				end
			else
				self:ChatPrint("You caught a "..string.upper(entdata["type"]).." cactus!")
			end
			
			if entdata["type"] == "powerup" then
				self:GiveValidUpgrade()
			end
			
			self:SetCactiTypeCaught(entdata["type"],self:GetCactiTypeCaught(entdata["type"])+1)
			
			self:SetCactiCaught(self:GetCactiCaught(entdata["type"])+1)
			
		end
		
		if entdata["type"] == "explosive" then
			self:ChatPrint("You caught an "..string.upper(entdata["type"]).." cactus!")
			if ent.CountingDown == false then
				ent:PreExplode()
				self:ChatPrint("YOU HAVE 10 SECONDS BEFORE IT EXPLODES! GET RID OF IT!")
			elseif ent.CountingDown == true then
				self:ChatPrint("YOU HAVE "..ent.CountDown.." SECONDS BEFORE IT EXPLODES! GET RID OF IT!")-- COUNTDOWN TO DETONATION HAS ALREADY BEEN INITIATED! GET RID OF IT!")
			end
		end
		
		self:AddFrags(entdata["score"])
		for i=1,6 do
			if self:Level() <= i /*or self:Frags() < levels[i]["Score"]*/ then return end
			if self:Frags() >= levels[i]["Score"] then
				self:SetLevel(i)
				self:ChatPrint("You are in the "..string.upper(levels[i]["Name"]).." class!")
			end
		end
		print(self:Frags(), self:Level())
	end
end

function meta:GetTotalScore()
	return self:GetNWInt("totalscore")
end
function meta:SetTotalScore(num)
	self:SetNWInt("totalscore", num)
end

function meta:GetCactiCaught()
	return self:GetNWInt("totalcacticaught")
end
function meta:SetCactiCaught(num)
	self:SetNWInt("totalcacticaught", num)
end

function meta:GetCactiTypeCaught(strType)
	return self:GetNWInt(strType.."cacticaught")
end
function meta:SetCactiTypeCaught(strType, num)
	self:SetNWInt(strType.."cacticaught", num)
end

function meta:GetCanAutoGrab()
	return self:GetNWInt("canautograb")
end
function meta:SetCanAutoGrab(bool)
	self:SetNWInt("canautograb", bool)
end

function meta:GetInvincible()
	return self:GetNWInt("invincible")
end
function meta:SetInvincible(bool)
	self:SetNWInt("invincible", bool)
end
