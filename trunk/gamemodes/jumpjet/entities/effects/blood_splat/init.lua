

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local scale = math.Clamp( data:GetMagnitude(), 10, 50 ) / 50

	self.Emitter = ParticleEmitter( pos )
	
	util.Decal( "Blood", pos + norm * 10, pos - norm * 10 )
	
	local particle = self.Emitter:Add( "effects/blood_core", pos )
	particle:SetVelocity( norm * 20 )
	particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
	particle:SetStartAlpha( 255 )
	particle:SetStartSize( math.Rand( 5, 10 ) )
	particle:SetEndSize( math.Rand( 30, 60 ) )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( 100, 0, 0 )
	
	for i=1, math.random(1,3) do
	
		local particle = self.Emitter:Add( "effects/blood", pos )
		particle:SetVelocity( norm * 50 + VectorRand() * 25 )
		particle:SetDieTime( 0.75 )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( math.Rand( 20, 40 ) * scale )
		particle:SetEndSize( math.Rand( 40, 100 ) * scale )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( 100, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end

	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end



