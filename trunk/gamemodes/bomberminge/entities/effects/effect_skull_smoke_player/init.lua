
function EFFECT:Init(data)
	local pl = data:GetEntity()
	
	self.Parent = pl
	if not ValidEntity(self.Parent) then
		return
	end
	
	self.MinDieTime = CurTime() + 1
end

function EFFECT:DoParticleEffects()
	local emitter, b, pos
	
	emitter = ParticleEmitter(self.Parent:GetPos())
	for i=0,100 do
		b = self.Parent:TranslatePhysBoneToBone(i)
		if b<0 then break end
		
		pos = self.Parent:GetBoneMatrix(b):GetTranslation()
		
		local particle = emitter:Add("particle/particle_smokegrenade", pos)
		particle:SetGravity(Vector(0,0,200))
		particle:SetVelocity(Angle(math.Rand(-90,90), math.Rand(-180,180), 0):Forward() * math.Rand(5,50) + 2*self.Parent:GetVelocity())
		particle:SetAirResistance(300)
		particle:SetDieTime(math.Rand(0.5,1.1))
		particle:SetStartSize(math.Rand(5,8))
		particle:SetEndSize(math.Rand(8,10))
		particle:SetRoll(math.Rand(150,180))
		particle:SetRollDelta(0.6*math.random(-1,1))
		particle:SetColor(100,20,255,255)
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
	end
	emitter:Finish()
end

function EFFECT:Think()
	if not ValidEntity(self.Parent) or not self.Parent:Alive() or (CurTime()>self.MinDieTime and self.Parent:GetNWInt("SkullState")==0) then
		return false
	end
	
	if not self.NextEmit or CurTime()>self.NextEmit then
		self:DoParticleEffects()
		self.NextEmit = CurTime() + 0.08
	end
	return true
end

function EFFECT:Render()
	
end
