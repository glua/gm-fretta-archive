
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	
	local SurfaceColor = render.GetSurfaceColor( pos, pos + Vector(0,0,5) ) * 255
	
	SurfaceColor.r = math.Clamp( SurfaceColor.r+40, 0, 255 )
	SurfaceColor.g = math.Clamp( SurfaceColor.g+40, 0, 255 )
	SurfaceColor.b = math.Clamp( SurfaceColor.b+40, 0, 255 )
		
	local emitter = ParticleEmitter( pos )
		for i=0, 20 do
			local particle = emitter:Add( "particles/smokey", pos + VectorRand() * 80 )
			particle:SetVelocity( VectorRand() * 100 )
			particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )
			particle:SetDieTime( math.Rand( 1, 2 ) )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(20,30) )
			particle:SetEndSize( math.Rand(100,200) )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0 )
				
			particle:SetAirResistance( 10 )
			particle:SetGravity( Vector( 0, 0, 0 ) )
			particle:SetCollide( false )
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
