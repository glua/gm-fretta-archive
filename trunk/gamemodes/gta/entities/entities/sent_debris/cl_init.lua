
include('shared.lua')

function ENT:Initialize()

	self.Velocity = Vector(0,0,1)
	self.SmokeTime = 0
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
end

function ENT:OnRemove()

	if not self.Emitter then return end

	self.Emitter:Finish()

end

function ENT:Think()
	
	if self.SmokeTime < CurTime() then
	
		self.SmokeTime = CurTime() + 0.25
	
		local col = math.random( 50, 100 )
		local particle = self.Emitter:Add( "particles/smokey", self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + VectorRand() * 10 )

		particle:SetVelocity( ( self.Velocity * math.Rand( 20, 40 ) ) + WindVector )
		particle:SetDieTime( math.Rand( 10, 15 ) )
		particle:SetStartAlpha( math.Rand( 20, 40 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 50 ) )
		particle:SetEndSize( math.Rand( 50, 150 ) )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( col, col, col )
		
	end

end

function ENT:Draw()

	self.Entity:DrawModel()
	
end

