// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Effect that occurs when a team based explosion occurs, e.g. rocket or burstnade.

EFFECT.ParticleMat = "LaserTag/impactparticle"
EFFECT.SmokeMat = "particle/particle_smokegrenade1"
EFFECT.BaseMat = Material("LaserTag/impactburst")
EFFECT.RingMat = Material("LaserTag/impactring")		// Todo: complete or remove material files.

/*-------------------------------------------------------------------
	[ Init ]
	When the entity is first initialised.
-------------------------------------------------------------------*/
function EFFECT:Init(data)
	self.StartPos 	= data:GetOrigin() 						// Location of effect burst. (Probably a rocket or hitpos)
	self.Magnitude 	= data:GetMagnitude()					// Magnitude corresponds to how big the explosion is overall in this instance.
	self.Owner	 	= data:GetEntity()						// Player that 'owns' the effect. Determines color.
	self.Offset 	= Vector(8,8,8)							// The max offset from the position that particles can potentially spawn.
	self.Color 		= Color(255,255,255,255)				// Color of the overall effect.
	self.Alpha 		= 255									// Alpha that also fades over time.
	self.Width		= 15 * self.Magnitude						// Width of the sprite at the location.
	
	self.Entity:SetRenderBoundsWS(self.StartPos - Vector(32,32,32),self.StartPos + Vector(32,32,32))
	
	if self.Owner and self.Owner:IsValid() and self.Owner:IsPlayer() then self.Color = team.GetColor(self.Owner:Team()) end
	
	self.Emitter = ParticleEmitter(self.StartPos)
		for i=1, self.Magnitude*32 do
			self:BurstParticle(self.StartPos)
		end
		
		for i=1, 32 do
			self:SmokeParticle(self.StartPos)
		end
	self.Emitter:Finish()
	
end

/*-------------------------------------------------------------------
	[ Think ]
	Think cycle; gradually reduces alpha and increases width until we end drawing (return false).
-------------------------------------------------------------------*/
function EFFECT:Think()
	self.Alpha = self.Alpha - FrameTime() * 500
	self.Width = self.Width + FrameTime() * 350
	
	self.Entity:SetAngles(Angle(0,0,math.random(0,360)))
	
	if self.Alpha < 0 then return false end
	return true
end

/*-------------------------------------------------------------------
	[ BurstParticle ]
	Small colors that fire quickly out from the burst origin.
-------------------------------------------------------------------*/
function EFFECT:BurstParticle(startpos)
	local offset = Vector(math.Rand(-self.Offset.x,self.Offset.x),math.Rand(-self.Offset.y,self.Offset.y),math.Rand(-self.Offset.z,self.Offset.z))
	local pos = startpos + offset
	local particle = self.Emitter:Add(self.ParticleMat,startpos)
	
	if particle then
		particle:SetColor(ExpColor(LerpColor(math.Rand(0,1),self.Color,color_white))) // Explode returns the .r,.g,.b values of the color struct, lerpcolor tweens between our color and white.
		particle:SetDieTime(1)
		
		particle:SetStartSize(2)
		particle:SetEndSize(0)
		
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		
		particle:SetRoll(math.random(0,360))
		particle:SetRollDelta(math.random(1,10))
		
		particle:SetVelocity((pos - startpos)*(self.Magnitude*5)) // How this works is we choose a random position within an offset around us
		particle:SetAirResistance(50)
	end
end

/*-------------------------------------------------------------------
	[ SmokeParticle ]
	The hazey-smokey particles that fade out after the main 'bewm' effects.
-------------------------------------------------------------------*/
function EFFECT:SmokeParticle(startpos)
	local offset = Vector(math.Rand(-self.Offset.x,self.Offset.x),math.Rand(-self.Offset.y,self.Offset.y),math.Rand(-self.Offset.z,self.Offset.z))
	local pos = startpos + offset
	local particle = self.Emitter:Add(self.SmokeMat,startpos)
	
	if particle then
		particle:SetDieTime(2)
		
		particle:SetStartSize(math.random(15,30))
		particle:SetEndSize(math.random(15,30))
		
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		
		particle:SetRoll(math.random(0,360))
		particle:SetRollDelta(math.random(-5,5))
		
		particle:SetVelocity((pos - startpos)*(self.Magnitude*2))
		particle:SetGravity(Vector(0,0,math.random(-25,25)))
	end
end

/*-------------------------------------------------------------------
	[ Render ]
	The visible aspect of the effect.
-------------------------------------------------------------------*/
function EFFECT:Render( )
	if self.Alpha < 1 then return end
	local white = Color(255,255,255,self.Alpha)
	
	// Exploding core.
	render.SetMaterial(self.BaseMat)
	render.DrawSprite(self.StartPos, self.Width, self.Width, Color(self.Color.r,self.Color.g,self.Color.b,self.Alpha))
	render.DrawSprite(self.StartPos, self.Width/2, self.Width/2, white)
end

