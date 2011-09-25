
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local norm = data:GetNormal()

	local emitter = ParticleEmitter( pos )
	
	for i=1, 10 do
	
		local particle = emitter:Add( "effects/fleck_glass"..math.random(1,3), pos )
		particle:SetVelocity( VectorRand() * math.random( 50, 100 ) + norm * math.random( 50, 100 ) )
		particle:SetDieTime( math.Rand( 1.5, 3.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 3, 6 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -180, 180 ) )
		particle:SetColor( 200, 200, 255 )
		
		particle:SetGravity( Vector( 0, 0, -600 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.5 )
	
	end
	
	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end
