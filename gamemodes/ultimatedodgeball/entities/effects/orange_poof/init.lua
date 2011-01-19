
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
		
	local emitter = ParticleEmitter( pos )
		for i=0, 20 do
			local particle = emitter:Add( "effects/blueflare1", pos + VectorRand() * 20 )
			particle:SetVelocity( VectorRand() * 80 )
			particle:SetLifeTime( 0 )
			particle:SetColor( 255, 155, 0, 255 )
			particle:SetDieTime( math.Rand( 1, 2 ) )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(2,4) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(0,360) )
			particle:SetRollDelta( 0 )
				
			particle:SetAirResistance( 200 )
			particle:SetGravity( Vector( 0, 0, -200 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.9 )
		end
	emitter:Finish()
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end
