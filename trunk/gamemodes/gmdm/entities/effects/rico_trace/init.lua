

EFFECT.Mat = Material( "effects/yellowflare" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.TracerTime = 0.4
	
	// Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
	
	// Play ricochet sound with random pitch
	WorldSound( "weapons/fx/rics/ric4.wav", self.StartPos, 80, math.random( 110, 180 ) )
	
	local vGrav = Vector( 0, 0, -450 )
	local Dir = self.Dir:GetNormalized()
	
	local emitter = ParticleEmitter( self.StartPos )
	
	for i=1, 20 do
	
		local particle = emitter:Add( "effects/yellowflare", self.StartPos )
		
			particle:SetVelocity( (Dir + VectorRand()*0.5) * math.Rand(100, 500) )
			particle:SetDieTime( math.Rand( 0.5, 2 ) )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand( 8, 16 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( 0 )
			particle:SetGravity( vGrav * 0.4 )
			particle:SetBounce( 0.8 )
			particle:SetAirResistance( 50 )
			particle:SetStartLength( 0.2 )
			particle:SetEndLength( 0 )
			particle:SetVelocityScale( true )
			particle:SetCollide( false )
			
	end
	
		local particle = emitter:Add( "effects/yellowflare", self.StartPos )

			particle:SetDieTime( 0.1 )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( 512 )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 )  )
			
		local particle = emitter:Add( "effects/yellowflare", self.StartPos )

			particle:SetDieTime( 0.4 )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( 64 )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 )  )
				
	emitter:Finish()

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if ( CurTime() > self.DieTime ) then return false end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 )
			
	render.SetMaterial( self.Mat )

	local color = Color( 255, 255, 255, 255 * fDelta )
	
	render.DrawBeam( self.StartPos, 		
					 self.EndPos,
					 32 * fDelta,					
					 0.5,					
					 0.5,				
					 color )
					 
end
