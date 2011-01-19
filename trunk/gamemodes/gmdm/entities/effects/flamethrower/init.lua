

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	local Pos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	
	local Velocity 	= data:GetNormal()
	
	Pos = Pos + data:GetNormal() * 4
	
	// Todo: Particle collisions
			
	local emitter = ParticleEmitter( Pos )
		
		for i=0, 8 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Velocity * i * 1 )

				particle:SetVelocity( Velocity * 0.99 * math.Rand( 1000, 1100 ) )
				particle:SetDieTime( math.Rand( 0.4, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 150, 250 ) )
				particle:SetStartSize( math.Rand( 1, 4 ) )
				particle:SetEndSize( math.Rand( 32, 64 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
				particle:VelocityDecay( false )
			
		end
		
		for i=0, 2 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Velocity * i * 16 )

				particle:SetVelocity( Velocity * math.Rand( 500, 600 ) )
				particle:SetDieTime( math.Rand( 0.2, 0.3 ) )
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( math.Rand( 4, 8 ) )
				particle:SetEndSize( math.Rand( 16, 32 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
				particle:SetColor( 120, math.Rand( 100, 160 ), 255 )
				particle:VelocityDecay( false )
			
		end
				
	emitter:Finish()
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	// Die instantly
	return false
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end



