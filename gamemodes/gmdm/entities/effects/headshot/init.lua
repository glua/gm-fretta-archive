cl_gmdm_headshot_blood_core_emitters = CreateClientConVar( "cl_gmdm_headshot_blood_core_emitters", 4, true, false )
cl_gmdm_headshot_blood_emitters = CreateClientConVar( "cl_gmdm_headshot_blood_emitters", 8, true, false )
cl_gmdm_headshot_smoke = CreateClientConVar( "cl_gmdm_headshot_smoke", 1, true, false )
cl_gmdm_headshot_bloodstream_max = CreateClientConVar( "cl_gmdm_headshot_bloodstream_max", 2, true, false )


/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Player = data:GetEntity()
	
	if ( self.Player == LocalPlayer() ) then
		LocalPlayer():HeadShot()
	end
	
	// Play headshot sound(s)
	if ( self.Player != NULL ) then
		self.Player:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 100, 100 )
		self.Player:EmitSound( "physics/flesh/flesh_squishy_impact_hard4.wav", 110, 110 )
		self.Player:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 120, 120 )
	end
	
	// Keep the start and end pos - we're going to interpolate between them
	local NumParticles = 0
	local Velocity 	= data:GetNormal()
	local Pos = data:GetOrigin() - Velocity * 16
	Velocity.z = 0
	
	local LightColor = render.GetLightColor( Pos ) * 255
	LightColor.r = math.Clamp( LightColor.r, 70, 255 )
	LightColor.g = math.Clamp( LightColor.g, 70, 255 )
	LightColor.b = math.Clamp( LightColor.b, 70, 255 )
	
	local emitter = ParticleEmitter( Pos )
	
		for i= 0, cl_gmdm_headshot_blood_core_emitters:GetInt() do
			local particle = emitter:Add( "effects/blood_core", Pos + VectorRand() * math.Rand( -8, 8 ) )
				particle:SetVelocity( VectorRand() * math.Rand( -100, 100 ) )
				particle:SetDieTime( math.Rand( 0.1, 0.4 ) )
				particle:SetStartAlpha( 250 )
				particle:SetStartSize( math.Rand( 8, 16 ) )
				particle:SetEndSize( math.Rand( 48, 64 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
				particle:SetColor( LightColor.r*0.5, 0, 0 )
		end
	
		// Random blood sqirts
		for i=0, cl_gmdm_headshot_blood_emitters:GetInt() do
		
			local particle = emitter:Add( "effects/blood", Pos )

				particle:SetVelocity( Velocity * math.Rand( 150, 200 ) + VectorRand() * math.Rand( 50, 100 ) )
				particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
				particle:SetStartAlpha( 200 )
				particle:SetEndAlpha( 128 )
				particle:SetStartSize( math.Rand( 8, 16 ) )
				particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
				particle:SetColor( LightColor.r*0.5, 0, 0 )
			
		end
		
		if( cl_gmdm_headshot_smoke:GetBool() ) then
			local particle = emitter:Add( "particles/smokey", Pos )
				particle:SetVelocity( Vector(0,0,0) )
				particle:SetDieTime( math.Rand( 5, 60 ) )
				particle:SetStartAlpha( 50 )
				particle:SetStartSize( math.Rand( 8, 16 ) )
				particle:SetEndSize( math.Rand( 32, 64 ) )
				particle:SetRollDelta( math.Rand( -0.2, 0.2 ) )
				particle:SetColor( LightColor.r*0.5, 0, 0 )
		end
		
	emitter:Finish()
	
	
	// Make Bloodstream effects
	if( cl_gmdm_headshot_bloodstream_max:GetInt() > 0 ) then
		for i= 0, math.random(1, cl_gmdm_headshot_bloodstream_max:GetInt()) do
		
			local effectdata = EffectData()
				effectdata:SetOrigin( data:GetOrigin() )
				effectdata:SetEntity( data:GetEntity() )
				effectdata:SetNormal( data:GetNormal() )
			util.Effect( "bloodstream", effectdata )
			
		end
	end
	
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



