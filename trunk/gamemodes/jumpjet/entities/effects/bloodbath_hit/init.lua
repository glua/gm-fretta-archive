

function EFFECT:Init( data )

	self.DieTime = CurTime() + 1.5
	
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter( pos )
	
	for i=1, 4 do
	
		local particle = emitter:Add( "jumpjet/splash00" .. math.random(1,2) .. table.Random{"a","b"}, pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,0,75) )
		particle:SetDieTime( math.Rand( 0.8, 1.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 20 ) )
		particle:SetEndSize( math.Rand( 40, 80 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 100, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end

	emitter:Finish()
	
end

function EFFECT:Think( )

	return self.DieTime > CurTime()
	
end

function EFFECT:Render()
	
end




