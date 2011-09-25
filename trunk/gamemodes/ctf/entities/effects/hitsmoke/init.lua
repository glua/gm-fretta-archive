

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	local Scale = data:GetScale()
	
	local SurfaceColor = render.GetSurfaceColor( Pos+Norm, Pos-Norm*100 ) * 255
	
	SurfaceColor.r = math.Clamp( SurfaceColor.r+40, 0, 255 )
	SurfaceColor.g = math.Clamp( SurfaceColor.g+40, 0, 255 )
	SurfaceColor.b = math.Clamp( SurfaceColor.b+40, 0, 255 )
	
	local Dist = LocalPlayer():GetPos():Distance( Pos )

	local FleckSize = math.Clamp( Dist * 0.01, 8, 64 )
		
	local emitter = ParticleEmitter( Pos + Norm * 32 )
	
	emitter:SetNearClip( 0, 128 )
	
		//for i=0, 2 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Norm * 10 )
				particle:SetVelocity( Norm * math.Rand( 100, 200 ) + VectorRand() * 60 )
				particle:SetDieTime( 2.5 )
				particle:SetStartAlpha( math.Rand( 150, 200 ) )
				particle:SetStartSize( math.Rand( 24, 32 ) )
				particle:SetEndSize( math.Rand( 50, 70 ) )
				particle:SetRoll( 0 )
				particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )
				particle:SetAirResistance( 100 )
		
		//end

		for i=0, 2 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Norm * 32 )
			
				particle:SetVelocity( Norm * 300 + VectorRand() * 200 )
				particle:SetDieTime( math.Rand( 2, 4.5 ) )
				particle:SetStartAlpha( 150 )
				particle:SetStartSize( math.Rand( 12,18 ) )
				particle:SetEndSize( 36 )
				particle:SetRoll( 0 )
				particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )
				particle:SetGravity( Vector( 0, 0, math.Rand( -200, -150 ) ) )
				particle:SetAirResistance( 100 )
				
		end
		
	emitter:Finish()
		
	local emitter = ParticleEmitter( Pos, true )
	
		for i =0, 5 * Scale do
		
			local particle
			
			if ( math.random( 0, 1 ) == 1 ) then
				particle = emitter:Add( "effects/fleck_cement1", Pos )
			else
				particle = emitter:Add( "effects/fleck_cement2", Pos )
			end

				particle:SetVelocity( (Norm + VectorRand() * 1) * math.Rand( 50, 200 ) )
				//particle:SetLifeTime( i )
				particle:SetDieTime( 1.5 )
				particle:SetStartAlpha( 150 )
				particle:SetEndAlpha( 150 )
				local Size = FleckSize * math.Rand( 1.0, 3.0 )
				particle:SetStartSize( Size )
				particle:SetEndSize( 0 )
				particle:SetLighting( true )
				particle:SetGravity( Vector( 0, 0, -800 ) )
				particle:SetAirResistance( 5 )
				particle:SetAngles( Angle( math.Rand( 0, 360 ), math.Rand( 0, 360 ), math.Rand( 0, 360 ) ) )
				particle:SetAngleVelocity( Angle( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) * 1600 )
				particle:SetCollide( true )
				particle:SetBounce( 0.2 )
				
				if ( math.fmod( i, 2 ) == 0 ) then
					particle:SetColor( 0, 0, 0 )
				end
		
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



