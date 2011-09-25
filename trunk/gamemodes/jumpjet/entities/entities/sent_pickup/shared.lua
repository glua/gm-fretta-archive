
ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetActiveTime( t )

	self.Entity:SetNetworkedFloat( 0, t )
	
end

function ENT:GetActiveTime()

	return self.Entity:GetNetworkedFloat( 0 )
	
end
