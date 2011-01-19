ENT.Type = "anim"

function ENT:SetEndPos( endpos )
	self.Entity:SetNetworkedVector( "endpos", endpos )	
	self.Entity:SetCollisionBoundsWS( self.Entity:GetPos( ), endpos, Vector( ) * 0.25 )
end

function ENT:GetEndPos( )
	return self.Entity:GetNetworkedVector( "endpos" )
end

function ENT:SetActiveTime( at )
	self.Entity:SetNetworkedFloat( 0, at )
end

function ENT:GetActiveTime( )
	return self.Entity:GetNetworkedFloat( 0 )
end
