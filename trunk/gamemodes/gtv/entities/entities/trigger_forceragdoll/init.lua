ENT.Base = "base_brush"
ENT.Type = "brush"
ENT.Delay = 5
ENT.RagdollKillDelay = 15
ENT.GlassRagdoll = true

local function playerautokill(pl,lifenumber)
	if pl:IsValid() && pl:Alive() && (pl.LifeNumber == lifenumber) then
		pl:Kill()
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() && !ent:GetParent():IsValid() then
		local rag = ents.Create("prop_ragdoll")
		rag:SetPos(ent:GetPos())
		rag:SetModel(ent:GetModel())
		rag:SetSkin(ent:GetSkin())
		rag.Owner = ent
		rag.GlassRagdoll = self.GlassRagdoll
		rag:Spawn()
		rag:Fire("Kill",nil,self.RagdollKillDelay)
		for i=0,rag:GetPhysicsObjectCount()-1 do
			local bone = rag:TranslatePhysBoneToBone(i)
			local phys = rag:GetPhysicsObjectNum(i)
			if phys then
				local bpos,bang = ent:GetBonePosition(bone)
				phys:SetPos(bpos)
				phys:SetAngle(bang)
				phys:SetVelocity(ent:GetVelocity())
			end
		end
		ent:SetParent(rag)
		ent:SetModel("models/blackout.mdl")
		//ent:Freeze()
		ent:StripWeapons()
		ent:Spectate(OBS_MODE_CHASE)
		ent:SpectateEntity(rag)
		ent.LastRagdoll = rag
		timer.Simple(self.Delay,playerautokill,ent,ent.LifeNumber)
		//ent:SetNoDraw(true)
	end
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	if key == "autokilldelay" then --A player that has been ragdolled by this entity will automatically die in 10 seconds if nothing else kills them first. This autokill delay can be changed with this number key.
		self.Delay = tostring(value)
	elseif key == "glassragdoll" then --GlassRagdoll is a boolean value (default true). When set, if the ragdoll takes any amount of damage its player will die.
		self.GlassRagdoll = (value == "1")
	elseif key == "ragdollkilldelay" then
		self.RagdollKillDelay = tostring(value)
	end
end

hook.Add("EntityTakeDamage","ragtoplayerdamage",function(ent,inflictor,attacker,amount,dmginfo) if (ent:GetClass() == "prop_ragdoll") && ent.Owner && ent.Owner:IsValid() && ent.GlassRagdoll then ent.Owner:Kill() ent.Owner = nil end end)