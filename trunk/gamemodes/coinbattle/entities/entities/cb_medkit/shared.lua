
ENT.Type = "anim"
ENT.Base = "base_anim"

util.PrecacheModel("models/Items/HealthKit.mdl")
util.PrecacheModel("models/healthvial.mdl")

function ENT:SetupDataTables()
	
	self:DTVar("Int",0,"HScale")
	
end