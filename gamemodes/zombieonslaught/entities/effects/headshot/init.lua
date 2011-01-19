
function EFFECT:Init( data )
	
	local num = 0
	
	local vel = data:GetNormal()
	local pos = data:GetOrigin() - vel * 5
	vel.z = 0
	
	self.Entity:SetRenderBounds( Vector() * -250, Vector() * 250 )
	
	if LocalPlayer():GetShootPos():Distance(pos) < 100 then
		AddStain()
	end
	
	local emitter = ParticleEmitter( pos )
	
	for i=1, math.random( 3, 6 ) do
	
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
	
	// blood spray
	for i=1, math.random( 3, 6 ) do
	
		local particle = emitter:Add( "effects/blood", pos )
		particle:SetVelocity( VectorRand() * math.Rand( 20, 40 ) )
		particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
		particle:SetStartAlpha( 150 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 20 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( 100, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -600 ) )
	
	end
	
	// Brain chunk
	for i=0, math.random( 1, 3 ) do
	
		local particle = emitter:Add( "decals/flesh/blood"..math.random(1,3), pos )
		particle:SetVelocity( vel * math.Rand( -300, 300 ) + VectorRand() * 150 )
		particle:SetDieTime( 2.0 )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( math.Rand( 0.5, 2.5 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( math.random( 50, 100 ), 0, 0 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		
	end
	
	// Random blood squirts (backwards)
	for i=1, math.random( 15, 25 ) do
		
		local particle = emitter:Add( "effects/blooddrop", pos )
		particle:SetVelocity( vel * math.Rand( -250, -100 ) + VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 2, 4 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartLength( 2 )
		particle:SetEndLength( 0 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetColor( 100, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		
	end
	
	// Random blood squirts (forward)
	for i=1, math.random( 15, 25 ) do
	
		local particle = emitter:Add( "effects/blooddrop", pos )
		particle:SetVelocity( vel * math.Rand( 100, 250 ) + VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 2, 4 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartLength( 2 )
		particle:SetEndLength( 0 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetColor( 100, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
	
	end
	
	local particle = emitter:Add( "particle/particle_smokegrenade1", pos )
	particle:SetVelocity( Vector( 0, 0, 0 ) )
	particle:SetDieTime( math.Rand( 10, 20 ) )
	particle:SetStartAlpha( 50 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 30, 60 ) )
	particle:SetEndSize( math.Rand( 1, 10 ) )
	particle:SetColor( 100, 0, 0 )

	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end



