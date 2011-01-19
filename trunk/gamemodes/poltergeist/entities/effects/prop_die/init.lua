
function EFFECT:Init( data )

	local Low = data:GetOrigin()
	local High = data:GetStart()
	local NumParticles = data:GetMagnitude()
	NumParticles = math.Clamp(  NumParticles * 5, 50, 300 )
		
	local emitter = ParticleEmitter( Low )
	
	for i=0, NumParticles do
	
		local vPos = Vector( math.Rand( Low.x, High.x ), math.Rand( Low.y, High.y ), math.Rand( Low.z, High.z ) )
			
		local particle = emitter:Add( "effects/spark", vPos )
		particle:SetVelocity( Vector(0,0,0) )
		particle:SetLifeTime( 0 )
		particle:SetColor( 255, math.random( 10, 100 ) , 0 )
		particle:SetDieTime( math.Rand( 1, 3 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -50, 50 ) )
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, math.random( -50, 50 ) ) )
		particle:SetCollide( true )
		particle:SetBounce( 1.0 )
		
	end
	
	emitter:Finish()
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()

end
