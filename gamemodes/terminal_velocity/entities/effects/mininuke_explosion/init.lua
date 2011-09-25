
local matRefraction	= Material( "refract_ring" )

function EFFECT:Init( data )

	self.Entity:SetRenderBounds( Vector() * -1024, Vector() * 1024 )
	
	self.Pos = data:GetOrigin()
	self.Emitter = ParticleEmitter( self.Pos )
	self.Size = 50
	self.Refract = 0
	self.DieTime = CurTime() + 0.5
	
	for i=1, 30 do
	
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )

		particle:SetVelocity( VectorRand() * 20 + Vector(0,0,1) * math.random( 20, 40 ) )
		particle:SetDieTime( math.Rand( 1.0, 1.5 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 50, 100 ) )
		particle:SetEndSize( math.Rand( 300, 600 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.2, 0.2 ) )
		particle:SetColor( math.random( 150, 255 ), math.random( 100, 150 ), 100 )
		
		if i % 3 == 0 then
		
			local particle = self.Emitter:Add( "effects/fire_cloud"..math.random(1,2), self.Pos + VectorRand() * 50 )

			particle:SetVelocity( VectorRand() * 50 )
			particle:SetDieTime( math.Rand( 0.5, 1.5 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 40, 80 ) )
			particle:SetEndSize( math.Rand( 100, 200 ) )
			particle:SetRoll( math.Rand( -360, 360 ) )
			particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
			particle:SetColor( math.random( 150, 255 ), math.random( 100, 150 ), 100 )
		
		end
		
		local particle = self.Emitter:Add( "particle/particle_smokegrenade", self.Pos )
		
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		
		if i % 2 == 1 then
			particle:SetVelocity( Vector( math.random(-100,100), math.random(-100,100), math.random(0,50) ) )
			particle:SetStartSize( math.Rand( 50, 100 ) )
			particle:SetEndSize( math.Rand( 250, 500 ) )
		else
			particle:SetVelocity( Vector( math.random(-200,200), math.random(-200,200), 0 ) )
			particle:SetStartSize( math.Rand( 50, 100 ) )
			particle:SetEndSize( math.Rand( 200, 400 ) )
		end
		
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		
		local dark = math.random( 10, 50 )
		particle:SetColor( dark, dark, dark )
		
		if i % 5 == 0 and math.random(1,4) != 1 then
		
			local vec = Vector( math.Rand(-8,8), math.Rand(-8,8), math.Rand(6,12) )
			local particle = self.Emitter:Add( "effects/fire_cloud2", self.Pos + vec * 10 )
	
			particle:SetVelocity( vec * 100 )
			particle:SetDieTime( 1.0 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 100 )
			particle:SetStartSize( 8 )
			particle:SetEndSize( 0 )
			particle:SetColor( math.random( 150, 255 ), math.random( 100, 150 ), 100 )
			
			particle:SetGravity( Vector( 0, 0, math.random( -700, -500 ) ) )
			particle:SetAirResistance( math.random( 20, 60 ) )
			particle:SetCollide( true )
	
			particle:SetLifeTime( 0 )
			particle:SetThinkFunction( CloudThink )
			particle:SetNextThink( CurTime() + 0.1 )
		
		end
	
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Pos
		dlight.r = 250
		dlight.g = 200
		dlight.b = 50
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 578
		dlight.size = 2560
		dlight.DieTime = CurTime() + 5
		
	end
	
	self.Emitter:Finish()
	
end

function EFFECT:Think( )

	self.Refract = self.Refract + 1.5 * FrameTime()
	self.Size = self.Refract * 5000

	if self.DieTime < CurTime() then
	
		self.Emitter:Finish()
		return false
	
	end
	
	return true
	
end

function EFFECT:Render()

	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawQuadEasy( self.Pos + Vector(0,0,1),
					 Vector(0,0,1),
					 self.Size, self.Size,
					 Color( 255, 255, 255, 255 ) )

end

function CloudThink( part )

	part:SetNextThink( CurTime() + 0.12 )

	local scale = 1 - part:GetLifeTime()
	local pos = part:GetPos()
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "particle/particle_smokegrenade", pos  )
	
	particle:SetVelocity( VectorRand() * 3 + ( WindVector * ( 3 * ( 1 - scale ) ) ) )
	particle:SetDieTime( math.Rand( 2.0, 3.0 ) + scale * 1.0 )
	particle:SetStartAlpha( math.random( 100, 150 ) )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 1, 3 ) + scale * math.random( 20, 50 ) )
	particle:SetEndSize( math.random( 1, 5 ) + scale * math.random( 30, 50 ) )
	
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
	
	local dark = math.random( 10, 50 )
	particle:SetColor( dark, dark, dark )
	
	emitter:Finish()

end
