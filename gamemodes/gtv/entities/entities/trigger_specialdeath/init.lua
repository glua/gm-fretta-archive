ENT.Base = "base_brush"
ENT.Type = "brush"
ENT.DeathType = 0

local DEATH_DEFAULT = 0
local DEATH_IMPALE = 1
local DEATH_LAVA = 2
local DEATH_CREATURES = 3
local DEATH_GIB = 4

local DeathTypes = {}
	DeathTypes[DEATH_DEFAULT] = function(self,ent)
		if ent:GetClass() == "prop_ragdoll" then
			if ent.Owner && ent.Owner:IsValid() then
				ent.Owner:Kill()
				ent.Owner = nil
			end
		else
			ent:Kill()
		end
	end

	DeathTypes[DEATH_IMPALE] = function(self,ent)
		if ent:GetClass() == "prop_ragdoll" then
			local closestbone = 0
			local shortestdist = 10000
			local pos = self:GetPos()
			for i=1,ent:GetPhysicsObjectCount()-1 do
				local phys = ent:GetPhysicsObjectNum(i)
				local dist = phys:GetPos():Distance(self:GetPos())
				if dist < shortestdist then
					shortestdist = dist
					closestbone = i
				end
			end
			ent:GetPhysicsObjectNum(closestbone):EnableMotion(false)
			if ent.Owner && ent.Owner:IsValid() then
				ent.Owner:Kill()
				ent.Owner = nil
			end
		end
	end
	
	DeathTypes[DEATH_LAVA] = function(self,ent)
		if ent:GetClass() == "prop_ragdoll" then
			ent:SetMaterial("models/Charple/Charple1_sheet")
			ent:Ignite(15)
			if ent.Owner && ent.Owner:IsValid() then
				ent.Owner:Kill()
				ent.Owner = nil
			end
		else
			ent:Kill()
			if ent:GetRagdollEntity() && ent:GetRagdollEntity():IsValid() then
				ent:GetRagdollEntity():Ignite(15)
				ent:GetRagdollEntity():SetMaterial("models/Charple/Charple1_sheet")
			end
		end
		ent:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav")
	end
	
	local gibupvel = Vector(0,0,100)
	
	DeathTypes[DEATH_GIB] = function(self,ent)
		if ent:GetClass() == "prop_ragdoll" then
			if ent.Owner && ent.Owner:IsValid() then
				ent.Owner:SetPos(ent:GetPos())
				ent.Owner.GibOnDeath = true
				ent.Owner:Kill()
				ent.Owner:Spectate(OBS_MODE_FIXED)
				ent.Owner:SetViewEntity(ent.Owner)
				ent.Owner = nil
			end
			ent:Remove()
		else
			ent.NoRagdoll = true
			GibPlayer(ent,gibupvel,ent:GetPos())
			ent:Kill()
		end
	end	

function ENT:KeyValue(key,value)
	key = string.lower(key)
	if (key == "deathtype") then
		value = tonumber(value)
		if DeathTypes[value] then
			self.DeathType = value
		else
			MsgAll("Unkown special death type: "..value)
		end
	end
end	

function ENT:StartTouch(ent)
	if ((ent:IsPlayer() && ent:Alive()) || (ent:GetClass() == "prop_ragdoll")) && !ent:GetParent():IsValid() then	
		local func = DeathTypes[self.DeathType]
		func(self,ent)
	end
end



//hook.Add("EntityTakeDamage","ragtoplayerdamage",function(ent,inflictor,attacker,amount,dmginfo) if (ent:GetClass() == "prop_ragdoll") && ent.Owner && ent.Owner:IsValid() then ent.Owner:TakeDamageInfo(dmginfo) end end)