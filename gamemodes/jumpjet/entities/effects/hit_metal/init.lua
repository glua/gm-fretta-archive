
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local norm = data:GetNormal()

	local emitter = ParticleEmitter( pos )
	
	for i=1, 20 do
	
		local particle = emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( VectorRand() * math.random( 150, 250 ) + norm * math.random( 50, 150 ) )
		particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 3, 6 ) )
		particle:SetEndSize( 0 )
		particle:SetStartLength( 0.1 )
		particle:SetEndLength( 0.2 )
		particle:SetRoll( 0 )
		particle:SetColor( 255, 255, 255 )
		
		particle:SetAirResistance( math.random( 15, 30 ) )
		particle:SetVelocityScale( true )
		particle:SetGravity( Vector( 0, 0, -600 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.75 )
	
	end
	
	local particle = emitter:Add( "sprites/light_glow02_add", pos )
	particle:SetDieTime( math.Rand( 0.3, 0.6 ) )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 30 )
	particle:SetEndSize( 0 )
	particle:SetColor( 255, 255, 200 )
	
	emitter:Finish()
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 200
		dlight.b = 150
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 2048
		dlight.size = 256 * math.Rand( 0.5, 1.5 )
		dlight.DieTime = CurTime() + 0.5
		
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end
