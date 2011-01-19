ENT.Type = "anim"

function ENT:SetEndPos( endpos )

	self.Entity:SetNWVector( "endpos", endpos )	
	self.Entity:SetCollisionBoundsWS( self.Entity:GetPos( ), endpos, Vector( ) * 0.25 )
	
end

function ENT:GetEndPos()

	return self.Entity:GetNWVector( "endpos", Vector() )
	
end

function ENT:GetActiveTime()

	return self.Entity:GetNWFloat( "Active", 0 )

end

function ENT:SetActiveTime( t )

	self.Entity:SetNWFloat( "Active", t )

end