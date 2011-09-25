ENT.Type = "point"

function ENT:Initialize()

	GAMEMODE:AddSpawnPosition( self.Entity:GetPos() )
	
	self.Entity:Remove()

end

function ENT:KeyValue( key, value )

end

