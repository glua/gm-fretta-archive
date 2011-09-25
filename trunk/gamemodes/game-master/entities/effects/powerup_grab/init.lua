

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local vPos = data:GetOrigin()
	local max = Vector( 2, 2, 2 )

	local col = data:GetStart()
		
	local emitter = ParticleEmitter( vPos )
	
		for i = 0, 400 do
			
			local offset = VectorRand() * math.Rand( 1, 16 )
			local particle = emitter:Add( "sprites/light_glow02_add", vPos + offset )
			
			if ( particle ) then
			
				particle:SetVelocity( offset * math.Rand( 1, 19 ) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.4, 1.0 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 13 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				particle:SetColor( col.x, col.y, col.z )
				//particle:SetAirResistance( 10 )
				particle:SetGravity( vector_origin )
				
			end
			
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
