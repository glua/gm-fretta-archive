EFFECT.Normal = nil
EFFECT.Magnitude = 1
EFFECT.SpawnedTime = nil
EFFECT.Mutant = false

EFFECT.RndRot1 = 0
EFFECT.RndRot2 = 0

local SplashMat = Material("sprites/mt-proj-splash")
local WarpMat = Material("sprites/mt-proj-splash-warp")

function EFFECT:Init(data)
	self:SetPos(data:GetOrigin())
	self.Normal = data:GetNormal()
	self.Magnitude = data:GetMagnitude()
	
	if data:GetAttachment() == 1 then self.Mutant = true end
	
	self.SpawnedTime = CurTime()
	
	self.RndRot1 = math.random(0,360)
	self.RndRot2 = math.random(0,360)
	
	local ePos = self:GetPos()
	local em = ParticleEmitter(ePos,false)
	for i=1,4 + math.ceil(2*self.Magnitude) do
		local particle = em:Add("sprites/mt-proj-splash",ePos + VectorRand() * math.random(4,5) * self.Magnitude)
		if particle then
			if self.Mutant then particle:SetColor(math.random(140,180),255,math.random(90,120)) else particle:SetColor(255,math.random(80,160),math.random(30,60)) end
			particle:SetStartSize(math.random(10,16) + 4*self.Magnitude)
			particle:SetEndSize(particle:GetStartSize() * .5)
			particle:SetLifeTime(0)
			particle:SetDieTime(.3 + math.random() * .2)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetRoll(math.random() * 2 * math.pi)
			particle:SetRollDelta((math.random() * 2 - 1) * math.pi / 3)
		end
	end
	
	-- OB splash stuff
	ParticleEffect("mt_projectile_splarkles_" .. (self.Mutant and "m" or "h"),self:GetPos(),data:GetAngle(),nil)
end

function EFFECT:Render()
	if self.SpawnedTime == nil then return end

	local tFrac = (CurTime() - self.SpawnedTime) / .5
	local sMul = 1 - math.pow(tFrac,3)
	render.SetMaterial(SplashMat)
	local sz = (24 + 10*self.Magnitude) * (.5 + .5*sMul)
	render.DrawQuadEasy(self:GetPos() + self.Normal,self.Normal,sz,sz,self.Mutant and Color(140,255,90,255*sMul) or Color(255,80,30,255*sMul),self.RndRot1)
	render.DrawQuadEasy(self:GetPos() + self.Normal,self.Normal,sz,sz,self.Mutant and Color(180,255,120,255*sMul) or Color(255,160,60,255*sMul),self.RndRot2)
end

function EFFECT:Think()
	if self.SpawnedTime and CurTime() > self.SpawnedTime + .5 then return false end
	return true
end
