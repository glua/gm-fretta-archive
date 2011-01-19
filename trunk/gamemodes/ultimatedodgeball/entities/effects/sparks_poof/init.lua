

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
		
	local emitter = ParticleEmitter( Pos )

	for i=1,15 do
	
		local particle = emitter:Add( "effects/spark", Pos )
			particle:SetVelocity( VectorRand() * 80 )
			particle:SetDieTime( 1 )
			particle:SetColor( 255, 255, 255, 255 )
			particle:SetStartAlpha( 200 )
			particle:SetStartSize( math.Rand( 3, 6 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			
			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, -500 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.6 )
			
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



