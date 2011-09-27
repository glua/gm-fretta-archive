
ENT.Type			= "anim"
ENT.Base			= "base_anim"

function ENT:SetupDataTables()
	
	self:DTVar("Int", 0, "CurTeam")
	
end

function ENT:Team()
	return self.dt.CurTeam
end