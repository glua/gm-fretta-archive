ENT.Author = "Ghor"
ENT.Type = "point"
ENT.Base = "base_point"
ENT.Enabled = true
ENT.SpawnPoint = NULL
ENT.AutoDisable = false

--This entity can be combined with trigger_multiple, disabling the spawn on player enter and enabling the spawn on player leave so you can prevent a player from spawning in a room occupied by another player

function ENT:Initialize()
	if self.Enabled && !self.SpawnPoint:IsValid() then
		self:CreateChild()
	end
end

function ENT:CreateChild()
	if !self.SpawnPoint:IsValid() then
		self.SpawnPoint = ents.Create("gtv_tspawn")
		self.SpawnPoint:SetPos(self:GetPos())
		self.SpawnPoint:SetAngles(self:GetAngles())
		self.SpawnPoint:SetParent(self)
		self.SpawnPoint:Spawn()	
		gamemode.Call("BuildSpawnPointList")
	end
end

function ENT:RemoveChild()
	if self.SpawnPoint:IsValid() then
		self.SpawnPoint:Remove()
	end
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	if key == "startenabled" then
		self.Enabled = (value != "0")
	elseif key == "autodisable" then
		self.AutoDisable = (value != "0")
	end
end

function ENT:AcceptInput(name,activator,caller,data)
	name = string.lower(name)
	if name == ("enable") then
		self.Enabled = true
		self:CreateChild()
	elseif name == ("disable") then
		self.Enabled = false
		self:RemoveChild()
	end
end


local ENT = {} --holy shit this is messy
ENT.Type = "point"
ENT.Base = "base_point"

scripted_ents.Register(ENT,"gtv_tspawn")