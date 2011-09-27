include("shared.lua")

function ENT:Think()
	local s = self.dt.MultiModel
	if self.LastMultiModel ~= s then
		self:SetMultiModel(multimodel.GetModelFromID(s))
		self.LastMultiModel = s
	end
	
	if self.MultiModel then
		multimodel.DoFrameAdvance(self.MultiModel, CurTime()-self.AnimStartTime, self)
	end
end

function ENT:Draw()
	multimodel.Draw(self.MultiModel, self)
end

function ENT:RestartAnimation(anim)
	self.Animation = anim
	self.AnimStartTime = CurTime()
end
	
usermessage.Hook("RestartAnimation", function(msg)
	local ent = msg:ReadEntity()
	local anim = msg:ReadChar()
	
	if ent.RestartAnimation then
		ent:RestartAnimation(anim)
	end
end)