ENT.Author = "Ghor"
ENT.Type = "point"
ENT.Base = "base_point"
ENT.LastTaken = 0
ENT.Child = NULL
ENT.ModelName = ""
ENT.RespawnTime = 30
ENT.ItemType = 0

function ENT:Initialize()
	if !self.NoAutoSpawn then
		self:CreateChild()
	end
end

function ENT:Think()
	self:NextThink(CurTime()+0.1)
	if (self.LastTaken+self.RespawnTime < CurTime()) && !self.Child:IsValid() && !self.NoAutoSpawn then
		self:CreateChild()
		self:NextThink(CurTime()+self.RespawnTime) --we won't be able to respawn for this long no matter what so why waste time thinking?
	end
	return true
end

function ENT:CreateChild()
	if self.Child:IsValid() then
		return
	end
	self.Child = ents.Create("gtv_item")
	self.Child.dt.ItemType = self.ItemType
	self.Child:SetPos(self:GetPos())
	self.Child.GTV_itemowner = self
	self.Child:SetParent(self)
	if gtv_itemtable[self.ItemType].CustomInit then
		gtv_itemtable[self.ItemType].CustomInit(self.Child)
	end
	self.Child:Spawn()
end

function ENT:RemoveChild()
	if !self.Child:IsValid() then
		return
	end
	self.Child:Remove()
	self:NextThink(CurTime()+0.1)
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	if key == "itemtype" then --this key will accept an item number or string
		if !tonumber(value) then --if it's not convertable to a number, then it's probably an item name, so translate it first
			value = gtvitem_translate[value]
		end
		self.ItemType = tonumber(value)
	elseif key == "respawntime" then
		self.RespawnTime = tonumber(value)
	elseif key == "noautospawn" then
		self.NoAutoSpawn = (value != "0")
	end
end

function ENT:AcceptInput(name,activator,caller,data)
	name = string.lower(name)
	if name == "spawn" then
		self:CreateChild()
	end
	if name == "unspawn" then
		self:RemoveChild()
	end
end