
include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
end

function ENT:OnRemove()

	if self.Emitter then 
	
		self.Emitter:Finish()
	
	end

end

function ENT:Think()

	local particle = self.Emitter:Add( "particles/smokey", self.Entity:LocalToWorld( self.Entity:OBBCenter() ) ) 
	
	particle:SetVelocity( VectorRand() * 50 )
	particle:SetDieTime( math.Rand(0.1,0.3) ) 
	particle:SetStartAlpha( 150 ) 
	particle:SetEndAlpha( 0 ) 
	particle:SetStartSize( math.random(1,10) ) 
	particle:SetEndSize( math.random(15,30) ) 
	particle:SetColor( 255, 255, 255 ) 
	
	particle:SetAirResistance( 25 )
	particle:SetGravity( Vector( 0, 0, -50 ) )
	
end

function ENT:Draw()

	self.Entity:DrawModel()
	
end

