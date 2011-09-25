// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Effect that spawns when a player gets a powerup.

EFFECT.GlowMat = "effects/energyball"
EFFECT.SpriteMat = Material("sprites/blueglow2")
//EFFECT.GlowMat = Material("effects/yellowflare")

/*-------------------------------------------------------------------
	[ Init ]
	When the entity is first initialised.
-------------------------------------------------------------------*/
function EFFECT:Init(data)
	self.StartPos 	= data:GetOrigin() 				// Location of the powerup.
	self.Player 	= data:GetEntity()				// The player who picked it up.
	self.Magnitude 	= data:GetMagnitude() * 100		// The magnitude, more means the effect fades quicker.
	self.Offset 	= Vector(10,10,10)				// The max offset from the position of the powerup that particles can potentially spawn.
	self.Color 		= Color(255,255,255,255)		// Color of the overall effect.
	self.Alpha 		= 255							// Alpha that also fades over time.
	self.OrigWidth 	= 80							// Width of the sprite at the powerup location.
	self.Width 		= 80
	
	if not self.Player or not self.Player:IsValid() then return false end
	
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
	local particle = self.Emitter:Add(self.GlowMat,pos)
	
	if particle then
		
		// The material I'm using does not work with alpha (argh)
		//particle:SetStartAlpha(self.Alpha)
		//particle:SetEndAlpha(0)
		particle:SetColor(self.Color.r,self.Color.g,self.Color.b,self.Alpha)
		particle:SetDieTime(3)
		
		particle:SetStartSize(15)
		particle:SetEndSize(0)
		
		particle:SetRoll(math.random(0,360))
		particle:SetRollDelta(5)
		
		particle:SetVelocity((pos - startpos)*5)
		particle:SetAirResistance(50)
		particle:SetCollide(true)
		
		// Particle think.
		local nextthink = CurTime() + 0.5
		local basespeed = math.random(5,15)
		particle:SetNextThink(CurTime() + 0.05)
		particle:SetThinkFunction(function(particle)
			
			particle:SetNextThink(CurTime() + 0.05)
			if CurTime() < nextthink then return end
			if not self.Player then return particle:SetDieTime(2) end
			
			local min,max = self.Player:WorldSpaceAABB()
			local tpos = Vector(math.Rand(min.x,max.x),math.Rand(min.y,max.y),math.Rand(min.z,max.z))
			
			if particle:GetPos():Distance(tpos) <= 32 then particle:SetDieTime(2) end
			particle:SetVelocity((tpos - particle:GetPos()) * (basespeed*(CurTime()-nextthink)))
			
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
	render.DrawSprite(self.StartPos, self.Width, self.Width, Color(255,255,255, self.Alpha))
	render.DrawSprite(self.EndPos, pwidth*2, pwidth*2, Color(255,255,255, self.Alpha)) // Player's one grows.
end

