include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Think()
	self.BaseClass.Think(self)
	
	local i = self:GetNWInt("GravHoldType")
	if i>0 and (not self.NextGravEmit or CurTime()>self.NextGravEmit) then
		local effect = EffectData()
			effect:SetOrigin(self:GetPos())
			effect:SetAttachment(i)
		util.Effect("effect_gravgun_hold", effect)
		self.NextGravEmit = CurTime()+0.1
	end
end
