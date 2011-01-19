

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
		
	local emitter = ParticleEmitter( Pos )
	
	for i=1,15 do

		local particle = emitter:Add( "effects/blueflare1", Pos + Norm * -8 )
			particle:SetVelocity( Norm * math.random(-100,-80) + VectorRand() * 90 )
			particle:SetDieTime( 1 )
			particle:SetColor( 0, 200, 255, 255 )
			particle:SetStartAlpha( 200 )
			particle:SetStartSize( math.Rand( 2, 4 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			
			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, -200 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.9 )
			
	end
				
	emitter:Finish()
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()	
end



