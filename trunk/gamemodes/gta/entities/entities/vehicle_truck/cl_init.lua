include('shared.lua')

language.Add( "vehicle_truck", "Vehicle" )

function ENT:Initialize()

	self.SmokeOffset = 100
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
end