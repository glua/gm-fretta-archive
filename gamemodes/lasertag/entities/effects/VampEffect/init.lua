// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Effect that occurs when a player equipped with Vampire hits another player and takes health.

//EFFECT.GlowMat = "effects/fluttercore"
//EFFECT.SpriteMat = Material("sprites/flare1")
EFFECT.ParticleMat = "LaserTag/impactparticle"
EFFECT.SpriteMat = Material("sprites/blueglow2")
//EFFECT.SpriteMat = Material("sprites/light_glow01")
//EFFECT.GlowMat = Material("effects/yellowflare")

/*-------------------------------------------------------------------
	[ Init ]
	When the entity is first initialised.
-------------------------------------------------------------------*/
function EFFECT:Init(data)
	self.StartPos 	= data:GetOrigin() + Vector(0,0,32) 	// Location of the target.
	self.Player 	= data:GetEntity()						// The player.
	self.Magnitude 	= data:GetMagnitude() * 100				// The magnitude, more means the effect fades quicker.
	self.Offset 	= Vector(8,8,32)						// The max offset from the position that particles can potentially spawn.
	//self.Color 		= Color(255,255,255,255)				// Color of the overall effect.
	self.EndColor 	= Color(255,255,255,255)				// Color the particles will turn to.
	self.Alpha 		= 255									// Alpha that also fades over time.
	self.OrigWidth 	= 80									// Width of the sprite at the powerup location.
	self.Width 		= 80
	
	if not self.Player or not self.Player:IsValid() then return false end
	self.EndColor = team.GetColor(self.Player:Team()) or self.EndColor
	
	self.EndPos = self.Player:GetPos() + Vector(0,0,32)
	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)
	
	self.Emitter = ParticleEmitter(self.StartPos)
		for i=0, 20 do
			self:Particle(self.StartPos,self.EndPos)
		end
	//self.Emitter:Finish()
	
end

/*-------------------------------------------------------------------
	[ Think ]
	Think cycle; gradually reduces alpha and increases width until we end drawing (return false).
-------------------------------------------------------------------*/
function EFFECT:Think()
	self.Alpha = self.Alpha - FrameTime() * self.Magnitude
	self.Width = self.OrigWidth * (self.Alpha/255)
	
	self.EndPos = self.Player:GetPos() + Vector(0,0,32)
	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)
	
	if self.Alpha < 0 then return false end
	return true
end

/*-------------------------------------------------------------------
	[ Particle ]
	Create particle.
-------------------------------------------------------------------*/
function EFFECT:Particle(startpos,endpos)
	local offset = Vector(math.Rand(-self.Offset.x,self.Offset.x),math.Rand(-self.Offset.y,self.Offset.y),math.Rand(-self.Offset.z,self.Offset.z))
	local pos = startpos + offset
	local particle = self.Emitter:Add(self.ParticleMat,pos)
	local initialdistance = pos:Distance(self.EndPos)
	
	if particle then
		
		particle:SetColor(ExpColor(self.EndColor))
		particle:SetDieTime(5)
		
		local size = math.random(1,3)
		particle:SetStartSize(size)
		particle:SetEndSize(size/2)
		
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		
		particle:SetRoll(math.random(0,180))
		particle:SetRollDelta(math.random(-5,5))
		
		particle:SetVelocity((pos - self.EndPos)*5)
		particle:SetAirResistance(50)
		
		// Particle think.
		local start = CurTime()
		local basespeed = math.random(3,10)
		particle:SetNextThink(CurTime() + 0.05)
		
		particle:SetThinkFunction(function(particle)
		
			particle:SetNextThink(CurTime() + 0.1)
			if not self.Player then return particle:SetDieTime(2) end
			
			local min,max = self.Player:WorldSpaceAABB()
			local tpos = Vector(math.Rand(min.x,max.x),math.Rand(min.y,max.y),math.Rand(min.z,max.z))
			local dist = particle:GetPos():Distance(tpos)
			
			if dist <= 32 then particle:SetDieTime(2) end
			particle:SetVelocity((tpos - particle:GetPos()) * (basespeed*(CurTime()-start))) // Particles need to get faster as they move else the player will just outrun them.
			
		end)
	end
end

/*-------------------------------------------------------------------
	[ Render ]
	The visible aspect of the effect.
-------------------------------------------------------------------*/
function EFFECT:Render( )
	if self.Alpha < 1 then return end
	local pwidth = self.OrigWidth - self.Width
	
	// End sprite.
	render.SetMaterial(self.SpriteMat)
	render.DrawSprite(self.EndPos, pwidth*2, pwidth*2, Color(self.EndColor.r,self.EndColor.g,self.EndColor.b,self.Alpha)) // Player's one grows.
	//render.DrawSprite(self.StartPos, self.Width, self.Width, Color(255,255,255, self.Alpha))
end

