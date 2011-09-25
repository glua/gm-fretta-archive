

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Magnitude = data:GetMagnitude() or 1
	
	self.Emitter = ParticleEmitter( self.Pos )
	self.DieTime = CurTime() + 15
	self.Interval = 0

end


function EFFECT:Think( )

	if self.Interval < CurTime() then
	
		self.Interval = CurTime() + 0.2
		
		local particle = self.Emitter:Add( "particles/smokey", self.Pos + VectorRand() * 10 )

		particle:SetVelocity( Vector( math.Rand(-3,3), math.Rand(-3,3), math.Rand(20,40) ) + WindVector )
		particle:SetDieTime( math.Rand( 10, 15 ) + self.Magnitude )
		particle:SetStartAlpha( math.random( 25, 50 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 25 ) * self.Magnitude )
		particle:SetEndSize( math.Rand( 50, 200 ) * self.Magnitude )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		
		local rand = math.random(10,50)
		particle:SetColor( rand, rand, rand ) 

	end
		
	if self.DieTime > CurTime() then
	
		return true
		
	else
	
		self.Emitter:Finish()
		return false
		
	end
	
end

function EFFECT:Render()
	
end
