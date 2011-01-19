

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Player = data:GetEntity()
	if ( Player == NULL ) then return end
	
	local Pos = Player:GetPos()
	local Norm = Vector( 0, 0, 1 )
	
	local LightColor = render.GetLightColor( Pos ) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
		
	local emitter = ParticleEmitter( Pos )
	
		for i=1, 32 do
	
			local Pos = Player:GetPos() + Player:OBBMaxs() * math.Rand(0,1) + Player:OBBMins() * math.Rand(0,1)
			
			local particle = emitter:Add( "effects/ashes", Pos )
				particle:SetVelocity( VectorRand() * 2 + Vector( 0, 0, math.Rand( -50, -40 ) ) )
				particle:SetDieTime( 2 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 255 )
				particle:SetStartSize( math.Rand( 8, 12) )
				particle:SetEndSize( math.Rand( 8, 12) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetColor( 0, 0, 0 )
				
		end
				
	emitter:Finish()
	
	self.Entity:EmitSound( "player/pl_burnpain3.wav" )
			
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

	// Do nothing - this effect is only used to spawn the particles in Init
	
end



