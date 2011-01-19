cl_gmdm_bodyshot_callback_effect = CreateClientConVar( "cl_gmdm_bodyshot_callback_effect", 1, true, false )
cl_gmdm_bodyshot_emitters = CreateClientConVar( "cl_gmdm_bodyshot_emitters", 2, true, false )

local function Callback_BloodSplash( Particle, HitPos, Normal )

	Particle:SetLifeTime( 0 )
	Particle:SetDieTime( 0 )
	
	util.Decal( "Blood", HitPos, HitPos + Normal * -1 )
	
	if( cl_gmdm_bodyshot_callback_effect:GetBool() ) then
		local emitter = ParticleEmitter( HitPos )
		
			local particle = emitter:Add( "effects/blood_core", HitPos )
				particle:SetDieTime( 1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 16 )
				particle:SetEndSize( 32 )
				particle:SetRoll( math.Rand( -360, 360 ) )
				particle:SetColor( 50 * math.Rand(0.8, 1), 0, 0 )
		
		emitter:Finish()
	end
	
end

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Player 	= data:GetEntity()
	local Normal 	= data:GetNormal()
	
	if ( Player == LocalPlayer() ) then
		LocalPlayer():BodyShot()
	end
	
	// Keep the start and end pos - we're going to interpolate between them
	local Pos = data:GetOrigin() + Normal * 8
	local Dist = Pos:Distance( EyePos() )
	
	local SizeMul = Dist / 1024
	
	local NumParticles = 0
	
	local emitter = ParticleEmitter( Pos )
	
		for i=0, cl_gmdm_bodyshot_emitters:GetFloat() do
	
			local delta = i / 16
		
			local particle = emitter:Add( "effects/blood_core", Pos )
				particle:SetVelocity( VectorRand() * 100 )
				particle:SetLifeTime( delta * -0.1 )
				particle:SetDieTime( math.Rand( 1, 2 ) )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 32 )
				particle:SetEndSize( 128 )
				particle:SetRoll( math.Rand( -360, 360 ) )
				particle:SetGravity( Vector( 0, 0, -200 ) )
				particle:SetAirResistance( 50 )
				particle:SetColor( 90 * math.Rand(0.8, 1), 0, 0 )
	
		end
		
		for i=0, cl_gmdm_bodyshot_emitters:GetFloat() do
	
			local delta = i / 16
		
			local particle = emitter:Add( "effects/blood_core", Pos )
				particle:SetVelocity( VectorRand() * 500 )
				particle:SetLifeTime( delta * -0.1 )
				particle:SetDieTime( 5 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 255 )
				particle:SetStartSize( 8 )
				particle:SetEndSize( 4 )
				particle:SetGravity( Vector( 0, 0, -800 ) )
				particle:SetAirResistance( 10 )
				particle:SetColor( 90 * math.Rand(0.8, 1), 0, 0 )
				particle:SetStartLength( 0.1 )
				particle:SetEndLength( 0.1 )
				particle:SetVelocityScale( true )
				
				particle:SetCollide( true )
				particle:SetCollideCallback( Callback_BloodSplash )
	
		end
	
		local particle = emitter:Add( "effects/blood_core", Pos )
			particle:SetDieTime( 0.2 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 64 )
			particle:SetEndSize( 256 )
			particle:SetAngleVelocity( VectorRand() * 3) // Rotate the particle in 3D mode
			particle:SetColor( 60 * math.Rand(0.8, 1), 0, 0 )
				
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



