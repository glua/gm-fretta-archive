ENT.Type = "point"

function ENT:Initialize()
	local Weapon = ents.Create("ss_weapon")
	Weapon:SetPos(self.Entity:GetPos())
	Weapon:Spawn()
	Weapon:Activate()
	self:Remove()
end
