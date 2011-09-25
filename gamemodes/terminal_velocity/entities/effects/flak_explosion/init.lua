
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter( pos )
	
	for i=1, 25 do
	
		local name = "000"..math.random(1,9)
		
		if i % 2 == 0 then
		
			name = "00"..math.random(10,16)
		
		end
		
		local particle = emitter:Add( "particle/smokesprites_"..name, pos + VectorRand() * 50 )
		
		particle:SetVelocity( VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 3.5, 5.0 ) )
		particle:SetStartAlpha( math.random( 150, 200 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 40, 80 ) )
		particle:SetEndSize( math.random( 200, 400 ) )
		particle:SetRoll( math.random( -180, 180 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( 10, 10, 10 )
		
		if i % 4 == 0 then
		
			local particle = emitter:Add( "effects/fire_cloud"..math.random(1,2), pos + VectorRand() * 25 )
			
			particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
			particle:SetStartAlpha( math.random( 150, 200 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 20 )
			particle:SetEndSize( math.random( 40, 80 ) )
			particle:SetRoll( math.random( -360, 360 ) )
			particle:SetRollDelta( math.Rand( -0.3, 0.3 ) )
			particle:SetColor( 255, 200, 100 )
		
		end
	
	end
	
	emitter:Finish()

end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end



