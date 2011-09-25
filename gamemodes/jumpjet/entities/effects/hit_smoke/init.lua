
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local col = math.random( 40, 80 )

	local emitter = ParticleEmitter( pos )
	
	for i=1, 10 do
	
		local particle = emitter:Add( "effects/fleck_cement"..math.random(1,2), pos )
		particle:SetVelocity( VectorRand() * math.random( 150, 250 ) + norm * math.random( 100, 200 ) )
		particle:SetDieTime( math.Rand( 1.5, 3.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 2, 5 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -180, 180 ) )
		particle:SetColor( col, col, col )
		
		particle:SetGravity( Vector( 0, 0, -600 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.5 )
	
	end
	
	local particle = emitter:Add( "particles/smokey", pos )
	particle:SetDieTime( math.Rand( 0.3, 0.6 ) )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 10 )
	particle:SetEndSize( math.random( 50, 100 ) )
	particle:SetColor( col, col, col )
	
	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end
