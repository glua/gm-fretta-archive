
local matRefraction	= Material( "refract_ring" )

function EFFECT:Init( data )

	self.Entity:SetRenderBounds( Vector() * -1024, Vector() * 1024 )
	
	self.Pos = data:GetOrigin()
	self.Norm = data:GetNormal()
	self.Emitter = ParticleEmitter( self.Pos )
	self.DieTime = CurTime() + 5
	
	for i=1, math.random(3,6) do
	
		local vec = self.Norm + VectorRand() * 0.7
		vec.x = math.Clamp( vec.x, -1.0, 0 )
		
		local particle = self.Emitter:Add( "effects/fire_cloud2", self.Pos )
		
		particle:SetVelocity( vec * math.random( 400, 600 ) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 5 )
		particle:SetEndSize( 0 )
		particle:SetColor( math.random( 150, 255 ), math.random( 100, 150 ), 100 )
		
		particle:SetGravity( Vector( 0, 0, math.random( -700, -500 ) ) )
		particle:SetAirResistance( math.random( 20, 60 ) )
		particle:SetCollide( true )
		
		particle:SetLifeTime( 0 )
		particle:SetThinkFunction( CloudThink )
		particle:SetNextThink( CurTime() + 0.1 )
	
	end
	
	for i=1, 15 do
	
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )

		particle:SetVelocity( self.Norm * math.random(50,100) + VectorRand() * math.random(50,100) )
		particle:SetDieTime( 0.7 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 20, 40 ) )
		particle:SetEndSize( math.Rand( 100, 200 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.2, 0.2 ) )
		particle:SetColor( math.random( 150, 255 ), math.random( 100, 150 ), 100 )
		
		local particle = self.Emitter:Add( "particle/particle_smokegrenade", self.Pos )
		
		particle:SetDieTime( math.Rand( 1.5, 2.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 20, 40 ) )
		particle:SetEndSize( math.Rand( 100, 150 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		
		local vec = VectorRand()
		vec.x = math.Rand( -0.1, 0.1 )
		
		if i % 2 == 0 then
		
			particle:SetVelocity( self.Norm * math.random(100,150) + vec * math.random(40,80) )
		
		else
		
			particle:SetVelocity( vec * math.random(100,150) )
		
		end
		
		local dark = math.random( 10, 50 )
		particle:SetColor( dark, dark, dark )
		
		particle:SetGravity( Vector(0,0,-50) )
		particle:SetCollide( true )
	
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Pos
		dlight.r = 250
		dlight.g = 200
		dlight.b = 50
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 2048
		dlight.size = 2048
		dlight.DieTime = CurTime() + 5
		
	end
	
	self.Emitter:Finish()
	
end

function EFFECT:Think( )

	return self.DieTime > CurTime() 
	
end

function EFFECT:Render()

end

function CloudThink( part )

	part:SetNextThink( CurTime() + 0.05 )

	local scale = 1 - part:GetLifeTime()
	local pos = part:GetPos()
	local emitter = ParticleEmitter( pos )
	local vec = VectorRand()
	vec.x = math.Rand( -0.1, 0 )
	
	local particle = emitter:Add( "particle/particle_smokegrenade", pos  )
	
	particle:SetVelocity( vec * 3 + ( WindVector * ( 2 * ( 1 - scale ) ) ) )
	particle:SetDieTime( math.Rand( 2.0, 3.0 ) + scale * 1.0 )
	particle:SetStartAlpha( math.random( 100, 150 ) )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 1, 3 ) + scale * 20 )
	particle:SetEndSize( math.random( 1, 5 ) + scale * 30 )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
	
	local dark = math.random( 10, 50 )
	particle:SetColor( dark, dark, dark )
	
	emitter:Finish()

end
