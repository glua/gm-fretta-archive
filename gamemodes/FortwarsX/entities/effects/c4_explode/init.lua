
//I admit, some of this code is from Garry's Bombs 3.

local SmokeParticleUpdate = function( particle )

	if particle:GetStartAlpha() == 0 and particle:GetLifeTime() >= 0.5 * particle:GetDieTime() then
		particle:SetStartAlpha( particle:GetEndAlpha() )
		particle:SetEndAlpha(0)
		particle:SetNextThink(-1)
	else
		particle:SetNextThink( CurTime() + 0.1 )
	end

	return particle

end


function EFFECT:Init( data )

	self.Scale = 0.4
	self.ScaleSlow = math.sqrt( self.Scale )
	self.ScaleSlowest = math.sqrt( self.ScaleSlow )
	self.Normal = data:GetNormal()
	self.Position = data:GetOrigin() - 12 * self.Normal
	self.Position2 = self.Position + self.Scale * 64 * self.Normal

	local CurrentTime = CurTime()
	self.Duration = 0.5 * self.Scale 
	self.KillTime = CurrentTime + self.Duration

	local emitter = ParticleEmitter(self.Position)

		for i = 1, math.ceil( self.Scale * 60 ) do
			
			    local vecang = VectorRand() * 8
		        local spawnpos = self.Position 	
                local velocity = math.Rand( 50, 300 ) * vecang			
				local particle = emitter:Add( "particle/particle_smokegrenade", spawnpos - vecang * 9 * k )
                local dietime = math.Rand( 8.5, 8.9 ) * self.Scale
				particle:SetVelocity( velocity * self.Scale )
				particle:SetDieTime( dietime )
                particle:SetAirResistance( 150 )
                particle:SetStartAlpha( 100 )
				particle:SetStartSize( math.Rand( 300, 300 ) * self.ScaleSlow )
			    particle:SetEndSize( math.Rand( 300, 300 ) * self.ScaleSlow )
			    particle:SetRoll( math.Rand( 0, 360 ) )
			    particle:SetRollDelta( math.random( -0.6, 0.6 ) )
		
		end

		for i = 1, math.ceil( self.Scale * 10 ) do
			
			    local vecang = VectorRand() * 8
		        local spawnpos = self.Position 	
                local velocity = math.Rand( 50, 150 ) * vecang			
				local particle = emitter:Add( "effects/fw/firecloud", spawnpos - vecang * 9 * k )
                local dietime = math.Rand( 0.5, 0.9 ) * self.Scale
				particle:SetVelocity( velocity * self.Scale )
				particle:SetDieTime( dietime )
                particle:SetAirResistance( 150 )
                particle:SetStartAlpha( 100 )                        
				particle:SetStartSize( math.Rand( 300, 300 ) * self.ScaleSlow )
			    particle:SetEndSize( math.Rand( 300, 300 ) * self.ScaleSlow )
				particle:SetRoll( math.Rand( -80, 80 ) )
			    particle:SetRollDelta( 0.6 * math.random(-1,1) )
		
		end
		
		for i = 1, math.ceil( self.Scale * 80 ) do
				
			    local vecang = VectorRand() * 8
		        local spawnpos = self.Position 	
                local velocity = math.Rand( 350, 450 ) * vecang			
				local particle = emitter:Add( "effects/fw/firestream", spawnpos - vecang * 9 * k )
                local dietime = math.Rand( 1.5, 1.9 ) * self.Scale
				particle:SetVelocity( velocity * self.Scale )
				particle:SetDieTime( dietime )
                particle:SetAirResistance( 10 )
                particle:SetStartAlpha( 100 )                        
				particle:SetStartSize( math.Rand( 30, 40 ) * self.ScaleSlow )
				particle:SetStartLength( math.Rand( 90, 100 ) * self.ScaleSlow )
			    particle:SetEndSize( 0 )
				particle:SetStartLength( math.Rand( 90, 100 ) * self.ScaleSlow )
				particle:SetRoll( math.Rand( 0, 360 ) )
			    particle:SetRollDelta( 0 )
				
		end
		
	emitter:Finish()

end

function EFFECT:Think()
	
	return false
	
end

function EFFECT:Render()
end



