// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Shield flickering effect when an explosion occurs nearby a player.

EFFECT.ParticleMat = "LaserTag/shieldflutter"
EFFECT.GlowMat = Material("effects/strider_muzzle")


/*-------------------------------------------------------------------
	[ Init ]
	When the entity is first initialised.
-------------------------------------------------------------------*/
function EFFECT:Init(data)
	// Basic internals
	self.Ply		= data:GetEntity()
	self.Offset		= Vector(16,16,32)
	self.Size 		= 256
	self.Alpha 		= 255
	
	// Check if we have a legitimate target.
	if not self.Ply or not self.Ply:IsValid() then return end
	
	// Basic internals that rely on self.Ply
	self.Color = team.GetColor(self.Ply:Team())
	self.Pos = self.Ply:GetPos()+Vector(0,0,36)
	
	// Set renderbounds.
	local low,high = self.Ply:WorldSpaceAABB()
	self.Entity:SetRenderBoundsWS(low,high)
	
	// Create the particle emitter that we'll use for the duration of the effect.
	self.Emitter = ParticleEmitter(self.Pos)
	
	for i=1,5 do
		self:Particle(self.Pos)
	end
end


/*-------------------------------------------------------------------
	[ Think ]
	Think cycle; gradually reduces alpha and increases width until we end drawing (return false).
-------------------------------------------------------------------*/
function EFFECT:Think()
	self.Alpha = self.Alpha - FrameTime() * 200
	self.Pos = self.Ply:GetPos()+Vector(0,0,36)
	
	local low,high = self.Ply:WorldSpaceAABB()
	self.Entity:SetRenderBoundsWS(low,high)
	
	for i=1,5 do
		self:Particle(self.Pos)
	end
	
	if self.Alpha < 0 then
		self.Emitter:Finish()
		return false
	end
	
	return true
end

/*-------------------------------------------------------------------
	[ Particle ]
	Create particle.
-------------------------------------------------------------------*/
function EFFECT:Particle(startpos)
	local offset = Vector(math.Rand(-self.Offset.x,self.Offset.x),math.Rand(-self.Offset.y,self.Offset.y),math.Rand(-self.Offset.z,self.Offset.z))
	local particle = self.Emitter:Add(self.ParticleMat,startpos + offset)
	
	if particle then
		particle:SetColor(ExpColor(self.Color))
		particle:SetDieTime(0.3)
		
		particle:SetStartSize(15)
		particle:SetEndSize(0)
		
		particle:SetStartAlpha(self.Alpha)
		//particle:SetEndAlpha(0)
		
		particle:SetRoll(math.random(0,360))
		particle:SetRollDelta(math.random(-5,5))
		particle:SetCollide(true)
	end
end

/*-------------------------------------------------------------------
	[ Render ]
	The visible aspect of the effect.
-------------------------------------------------------------------*/
function EFFECT:Render()
	if self.Alpha < 1 then return end
	//local texcoord = CurTime() * -0.2
	local alpha = math.Rand(0,1) * self.Alpha
	local col = Color(self.Color.r, self.Color.g, self.Color.b, alpha)
	
	render.SetMaterial(self.GlowMat)
	render.DrawSprite(self.Pos,self.Size/2,self.Size,col)
end
