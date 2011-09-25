ENT.Type = "point"

function ENT:Initialize()

end

function ENT:KeyValue( key, value )

	if string.lower( key ) == "angles" then
	
		local tbl = string.Explode( " ", value )
		
		self.Entity:SetSpawnAngles( Angle( tonumber( tbl[1] ), tonumber( tbl[2] ), tonumber( tbl[3] ) ) )
	
	end

end

function ENT:SetSpawnAngles( ang )

	self.SpawnAngles = ang

end

function ENT:GetSpawnAngles()

	return self.SpawnAngles or Angle(0,0,0)

end