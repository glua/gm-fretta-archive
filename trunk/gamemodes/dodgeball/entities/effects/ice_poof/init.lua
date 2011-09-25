

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	
	local emitter = ParticleEmitter(pos)
	
	for i=1, math.random(10,20) do
	
		local vertical = Vector(0,0,1) * math.random(10,70)
		
		local particle = emitter:Add( "particles/smokey", pos + vertical + VectorRand() * 30 )
		particle:SetVelocity( VectorRand() * 50 )
		particle:SetDieTime( math.Rand(1.5,2) )
		particle:SetStartAlpha( math.Rand(60,125) )
		particle:SetEndAlpha( 1 )
		particle:SetStartSize( math.Rand(10,20) )
		particle:SetEndSize( math.Rand(30,40) )
		particle:SetRoll( math.Rand(-360,360) )
		particle:SetRollDelta( math.Rand(-0.1,0.1) )
		particle:SetColor( 150, 150, 250 )
		
	end
	
	for i=1, math.random(30,50) do
	
		local vertical = Vector(0,0,1) * math.random(10,70)
	
		local particle = emitter:Add("effects/fleck_glass"..math.random(1,3), pos + vertical + VectorRand() * 30  )
		particle:SetVelocity( VectorRand() * 250 )
		particle:SetDieTime( math.Rand(3,5) )
		particle:SetStartAlpha( math.random(150,250) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(1,5) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(-360,360) )
		particle:SetRollDelta( math.Rand(-0.1,0.1) )
		particle:SetColor( 150, 150, 255 )
		
		particle:SetGravity( Vector(0,0,-500) )
		particle:SetCollide( true )
		particle:SetBounce( 0.8 ) 
		
	end
	
	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
	
end


function EFFECT:Render()
	
end
