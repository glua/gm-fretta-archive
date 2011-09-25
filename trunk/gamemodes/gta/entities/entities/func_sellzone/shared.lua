 	
ENT.Type 		= "brush"

AddCSLuaFile( "shared.lua" )

function ENT:Initialize()

end

function ENT:Think()

	if not ValidEntity( self.Point ) then
	
		self.Point = ents.Create( "info_sellzone" )
		self.Point:SetPos( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
		self.Point:Spawn()
	
	end

end

function ENT:PassesTriggerFilters( entity )

	return string.find( entity:GetClass(), "vehicle" )
	
end

function ENT:StartTouch( entity )

	if ( self.Entity:PassesTriggerFilters( entity ) ) then
		
		GAMEMODE:SellCar( entity )
		
	end

end

function ENT:KeyValue( key, value )
	
end

