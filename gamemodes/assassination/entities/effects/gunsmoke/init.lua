

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
	Velocity.z = 0
	
	Pos = Pos + data:GetNormal() * 8
	
	local LightColor = render.GetLightColor( Pos ) * 255
	LightColor.r = math.Clamp( LightColor.r, 90, 255 )
	LightColor.g = math.Clamp( LightColor.g, 90, 255 )
	LightColor.b = math.Clamp( LightColor.b, 90, 255 )
	
	local emitter = ParticleEmitter( Pos )
		
			local particle = emitter:Add( "particles/smokey", Pos )

				particle:SetVelocity( Velocity * math.Rand( 1, 10 ) )
				particle:SetDieTime( math.Rand( 2, 6 ) )
				particle:SetStartAlpha( math.Rand( 10, 50 ) )
				particle:SetStartSize( math.Rand( 2, 8 ) )
				particle:SetEndSize( math.Rand( 24, 64 ) )
				particle:SetRoll( math.Rand( -25, 25 ) )
				particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
				particle:SetColor( LightColor.r, LightColor.g, LightColor.b )
				
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



