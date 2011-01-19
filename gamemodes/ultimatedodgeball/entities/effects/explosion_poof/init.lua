local matRefraction	= Material( "sprites/heatwave" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	local pos = data:GetOrigin()
	
	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	util.Effect("Explosion", effectdata)
	
	local SurfaceColor = render.GetSurfaceColor( pos, pos + Vector(0,0,5) ) * 255
	
	SurfaceColor.r = math.Clamp( SurfaceColor.r+40, 0, 255 )
	SurfaceColor.g = math.Clamp( SurfaceColor.g+40, 0, 255 )
	SurfaceColor.b = math.Clamp( SurfaceColor.b+40, 0, 255 )
		
	local emitter = ParticleEmitter( pos )
		for i=0, 10 do
			local particle = emitter:Add( "particles/smokey", pos + VectorRand() * 30 )
			particle:SetVelocity( VectorRand() * 50 )
			particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )
			particle:SetDieTime( 1 )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(10,20) )
			particle:SetEndSize( math.Rand(40,80) )
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
function EFFECT:Render( )
end
