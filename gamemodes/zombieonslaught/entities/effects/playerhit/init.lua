

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local ply = data:GetEntity()
	
	if ply and ply:IsValid() and LocalPlayer() == ply then
	
		for i=1, 5 do
			AddStain()
		end
		
		ViewWobble = 0.5
		DisorientTime = CurTime() + 10
		MotionBlur = 0.6
		Sharpen = 4.5
		ColorModify[ "$pp_colour_mulr" ] = 1.5
		
	end
	
	local emitter = ParticleEmitter( pos )
	
	for i=1, math.random( 5, 10 ) do
	
		local particle = emitter:Add( "effects/blood_core", pos + VectorRand() * 5 )
		particle:SetVelocity( VectorRand() * 30 )
		particle:SetDieTime( math.Rand( 0.2, 0.4 ) )
		particle:SetStartAlpha( 200 )
		particle:SetStartSize( math.Rand( 10, 20 ) )
		particle:SetEndSize( math.Rand( 30, 60 ) )
		particle:SetRoll( math.Rand( 0, 180 ) )
		particle:SetRollDelta( math.Rand( -0.2, 0.2 ) )
		particle:SetColor( 100, 0, 0 )
	
	end
	
	// Random blood squirts 
	for i=1, math.random( 20, 40 ) do
		
		local particle = emitter:Add( "effects/blooddrop", pos )
		particle:SetVelocity( VectorRand() * math.random( 200, 350 ) )
		particle:SetDieTime( math.Rand( 2, 4 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartLength( 2 )
		particle:SetEndLength( 0 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetColor( 100, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		
	end

	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end



