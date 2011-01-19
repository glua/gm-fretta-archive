
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( pos )
	
	for i=1, 25 do
	
		local particle = emitter:Add( "particles/smokey", pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,0,1) * math.random(100,200) )
		particle:SetDieTime( math.Rand(1.0,2.5) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(10,20) )
		particle:SetEndSize( math.Rand(25,100) )
		particle:SetRoll( math.Rand(-360,360) )
		particle:SetRollDelta( math.Rand(-0.1,0.1) )
		particle:SetColor( 255, 255, 255 )
		
		particle:SetGravity( Vector(0,0,-400) )
		particle:SetCollide( true )
		particle:SetBounce( 0.25 ) 
	
	end
	
	for i=1, math.random(5,10) do
	
		local particle = emitter:Add( "effects/fleck_cement"..math.random(1,2) , pos )
		particle:SetVelocity( VectorRand() * 300 + Vector(0,0,1) * math.random(100,300) )
		particle:SetDieTime( math.Rand(1.5,3.0) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(3,6) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(-360,360) )
		particle:SetRollDelta( math.Rand(-0.1,0.1) )
		particle:SetColor( 255, 255, 255 )
		
		particle:SetGravity( Vector(0,0,-400) )
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
