

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	
	local SurfaceColor = render.GetSurfaceColor( Pos, Pos + Norm * -50 )
	
	SurfaceColor.r = math.Clamp( SurfaceColor.r + 25, 0, 255 )
	SurfaceColor.g = math.Clamp( SurfaceColor.g + 25, 0, 255 )
	SurfaceColor.b = math.Clamp( SurfaceColor.b + 25, 0, 255 )
		
	local emitter = ParticleEmitter( Pos )
	
		local particle = emitter:Add( "particles/smokey", Pos + Norm * -15 )
			particle:SetVelocity( Norm * math.Rand( 1, 5 ) * -1 )
			particle:SetDieTime( math.Rand( 1, 5 ) )
			particle:SetStartAlpha( math.Rand( 50, 150 ) )
			particle:SetStartSize( math.Rand( 10, 30 ) )
			particle:SetEndSize( math.Rand( 50, 100 ) )
			particle:SetRoll( 0 )
			particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )

		local particle = emitter:Add( "particles/smokey", Pos + Norm * -30 )
			particle:SetVelocity( Norm * -100 )
			particle:SetDieTime( 0.4 )
			particle:SetStartAlpha( 200 )
			particle:SetStartSize( 30 )
			particle:SetEndSize( math.Rand( 50, 100 ) )
			particle:SetRoll( 0 )
			particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )
				
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



