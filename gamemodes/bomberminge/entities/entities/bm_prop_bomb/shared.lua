
ENT.Type 			= "anim"
ENT.Base 			= "base_multimodel"

function ENT:AddCollisionRule(ent, shouldcollide)
	if not self.CollisionRules then
		self.CollisionRules = {}
		setmetatable(self.CollisionRules, {__mode="k"})
	end
	
	self.CollisionRules[ent] = shouldcollide
	
	if SERVER then
		umsg.Start("AddCollisionRule")
			umsg.Short(self:EntIndex())
			umsg.Short(ent:EntIndex())
			umsg.Bool(shouldcollide)
		umsg.End()
	end
end

if CLIENT then

local PendingCollisionMessages = {}

usermessage.Hook("AddCollisionRule", function(msg)
	local id1 = msg:ReadShort()
	local id2 = msg:ReadShort()
	local ent1 = ents.GetByIndex(id1)
	local ent2 = ents.GetByIndex(id2)
	local shouldcollide = msg:ReadBool()
	
	if not ValidEntity(ent2) then return end
	
	if not ValidEntity(ent1) then
		PendingCollisionMessages[id1] = {ent2, shouldcollide, CurTime() + 0.5}
	elseif ent1.AddCollisionRule then
		ent1:AddCollisionRule(ent2, shouldcollide)
	end
end)

hook.Add("Think", "CollisionMessagesThink", function()
	for k,v in pairs(PendingCollisionMessages) do
		local ent = ents.GetByIndex(k)
		if ValidEntity(ent) then
			if ent.AddCollisionRule then ent:AddCollisionRule(v[1], v[2]) end
			PendingCollisionMessages[k] = nil
		elseif CurTime()>v[3] then -- message expired, remove it from the table
			MsgN("WARNING : Message to entity "..tostring(k).." expired")
			PendingCollisionMessages[k] = nil
		end
	end
end)

end