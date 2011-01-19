ENT.Type = "point"

function ENT:OnRemove( )
	GAMEMODE:MakeLandmarkEffect(self:GetPos())
end
