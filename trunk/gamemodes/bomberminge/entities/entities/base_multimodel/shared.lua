
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

function ENT:SetupDataTables()  
	self:DTVar("Int", 0, "MultiModel");
	self:DTVar("Int", 1, "ParentBone");
	self:DTVar("Entity", 0, "ParentEntity");
end  

function ENT:AttachToEntity(e,b)
	self.dt.ParentEntity = e
	self.dt.ParentBone = e:LookupBone(b)
	--self:SetNWEntity("ParentEntity", e)
	--self:SetNWString("ParentBone", b)
end

function ENT:SetMultiModel(mdl)
	if SERVER then
		--self:SetNWString("MultiModel", mdl, true)
		self.dt.MultiModel = multimodel.GetModelID(mdl)
		
		--[[umsg.Start("SetMultiModel")
			umsg.Short(self:EntIndex())
			umsg.String(mdl)
		umsg.End()]]
	else
		local m = multimodel.CreateInstance(mdl)
		if m then
			self.MultiModel = m
			self.AnimStartTime = CurTime()
		end
	end
end
