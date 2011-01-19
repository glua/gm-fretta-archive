
function EFFECT:Init( data )
	
	local norm = data:GetNormal()
	local pos = data:GetOrigin() + norm * 5
	local dist = pos:Distance( EyePos() )
	local mul = dist / 1024
	
	self.Entity:SetRenderBounds( Vector() * -250, Vector() * 250 )
	
	if LocalPlayer():GetShootPos():Distance(pos) < 100 then
		AddStain()
	end
	
	local emitter = ParticleEmitter( pos )
	
		// Big fast splash
		local particle = emitter:Add( "effects/blood_core", pos )
		particle:SetDieTime( 0.2 )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( 5 )
		particle:SetEndSize( 15 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetColor( 50, 0, 0 )
		
		local particle = emitter:Add( "effects/blood_core", pos )
		particle:SetDieTime( 0.4 )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( 5 )
		particle:SetEndSize( 20 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetColor( 50, 0, 0 )
		
		local particle = emitter:Add( "effects/blood_core", pos + norm * 5 )
		particle:SetDieTime( 0.5 )
		particle:SetStartAlpha( 250 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 5 )
		particle:SetEndSize( 30 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetColor( 50, 0, 0 )
		
		local particle = emitter:Add( "effects/blood_core", pos + norm * 5 )
		particle:SetDieTime( 0.5 )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( 20 )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetColor( 50, 0, 0 )
		
		// Blood cloud
		local particle = emitter:Add( "particle/particle_smokegrenade1", pos )
		particle:SetDieTime( math.Rand( 10, 20 ) )
		particle:SetStartAlpha( 50 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 30, 60 ) )
		particle:SetEndSize( math.Rand( 1, 10 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( 50, 0, 0 )
		
		if math.random(1,3) == 1 then
		
			// Guts chunk
			for i=0, math.random( 1, 3 ) do
			
				local particle = emitter:Add( "decals/flesh/blood"..math.random(1,3), pos )
				particle:SetVelocity( VectorRand() * 100 )
				particle:SetDieTime( 2.0 )
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( math.Rand( 0.5, 3.5 ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
				particle:SetColor( math.random( 50, 100 ), 0, 0 )
				
				particle:SetGravity( Vector( 0, 0, -500 ) )
				
			end
		end
		
	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end

