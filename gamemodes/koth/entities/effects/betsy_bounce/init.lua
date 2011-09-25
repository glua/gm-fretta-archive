
function EFFECT:Init( d )
	self.Pos = d:GetOrigin()
	self.Norm = d:GetNormal()
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1, 25 do
	
		local particle = emitter:Add( "effects/spark", self.Pos )
		particle:SetVelocity( self.Norm * math.Rand( 150, 200 ) + VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 0.3, 0.6 ) )
		particle:SetStartAlpha( math.Rand( 200, 250 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 1, 5 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(0, 360) )
		particle:SetRollDelta( math.Rand(-10, 10) )
		particle:SetColor( 255,255,225 )
			
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector(0,0,-400) )
		particle:SetCollide( true )
		particle:SetBounce( math.Rand( 0.9, 1.1 ) )
			
	end
	
	emitter:Finish( )
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end