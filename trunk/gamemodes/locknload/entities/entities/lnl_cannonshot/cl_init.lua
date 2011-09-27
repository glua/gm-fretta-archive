include ('shared.lua')

function ENT:Initialize ()
	self.Emitter = ParticleEmitter (self.Entity:GetPos())
end

function ENT:UpdateColor ()
	self.Color = Color (255, 255, 255, 255)
	local ltr = self.Entity:GetNWString ("fm")
	if ltr == "e" then
		self.Color = Color (255,200,200,255)
	elseif ltr == "r" then
		self.Color = Color (255,255,200,255)
	elseif ltr == "a" then
		self.Color = Color (200,200,255,255)
	end
end

local Mat = Material( "effects/select_ring" ) 

function ENT:Draw ()
	self:SetModelScale (Vector(2,2,2))
	self.BaseClass.Draw (self)
end

function ENT:Think()
	self:UpdateColor ()
	
	local Gravity = Vector( 0, 0, -10 )
	local Velocity = self:GetVelocity()
		
	if self.Emitter then
			self.LastParticlePos = self.LastParticlePos or self:GetPos()
			local vDist = self:GetPos() - self.LastParticlePos
			local Length = vDist:Length()
			local vNorm = vDist:GetNormalized()
			
			for i=0, Length, 8 do
				self.LastParticlePos = self.LastParticlePos + vNorm * 8
			
				self.ParticlesSpawned = self.ParticlesSpawned or 1
				self.ParticlesSpawned = self.ParticlesSpawned + 1
				
				local particle = self.Emitter:Add( "particles/smokey", self.LastParticlePos ) 
	 		 	
				particle:SetVelocity( VectorRand() * 5 ) 
				particle:SetLifeTime( 0 ) 
				particle:SetDieTime( math.Rand(0.35,0.5) ) 
				particle:SetStartAlpha( math.Rand(150,200) ) 
				particle:SetEndAlpha( 0 ) 
				particle:SetStartSize( math.random(5,7) ) 
				particle:SetEndSize( math.random(10,14) ) 
				local dark = math.Rand(50,75)
				particle:SetColor( self.Color.r - dark, self.Color.g - dark, self.Color.b - dark ) 
				
				particle:SetAirResistance( 50 )
				particle:SetGravity( Vector( 0, 0, math.random(-50,50) ) )
				particle:SetCollide( true )
				particle:SetBounce( 0.2 )
		
				// This is to fix z order problems with different particles
				// Make a new emitter every x particles
				if self.ParticlesSpawned > 8 then
				
					self.Emitter:Finish()
					self.Emitter = ParticleEmitter (self.Entity:GetPos())
					self.ParticlesSpawned = 0
					
				end
				
			end

	
	end
end