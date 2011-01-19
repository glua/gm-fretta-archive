
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local startpos = data:GetStart()
	local pos = data:GetOrigin()
	
	local dir = (pos - startpos):Normalize()
	local len = startpos:Distance(pos)
	
	local num = math.Clamp(len / 10, 40, 80)
		
	local emitter = ParticleEmitter( pos )
		for i=0, 20 do
			local particle = emitter:Add( "effects/blueflare1", pos + VectorRand() * 20 )
			particle:SetVelocity( VectorRand() * 80 )
			particle:SetColor( 255, math.Rand(0,50), 0, 255 )
			particle:SetDieTime( math.Rand( 1, 3 ) )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(2,4) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(0,360) )
			particle:SetRollDelta( 0 )
				
			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, -200 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.9 )
		end
		
		for i=0, num do
			local particle = emitter:Add( "effects/blueflare1", startpos + dir * math.Rand(1,len) )
			particle:SetVelocity( VectorRand() * 5 )
			particle:SetColor( 255, math.Rand(0,50), 0, 255 )
			particle:SetDieTime( math.Rand( 2, 3 ) )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(2,4) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(0,360) )
			particle:SetRollDelta( 0 )
				
			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, -50 ) )
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
