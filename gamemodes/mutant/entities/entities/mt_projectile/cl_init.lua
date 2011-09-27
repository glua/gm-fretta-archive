include("shared.lua")

local glowMat = Material("sprites/mt-proj-glow")

function ENT:Initialize()
	ParticleEffectAttach("mt_projectile_trail_" .. self.ParticleSuffix,PATTACH_ABSORIGIN_FOLLOW,self,0)
end

function ENT:Draw()
	render.SetMaterial(glowMat)
	local sz = 20 + 3*self:GetNetworkedInt("size") + math.random(1,5)
	render.DrawSprite(self:GetPos(),sz,sz,self:SpriteColor())
	render.DrawSprite(self:GetPos(),sz*.6,sz*.6,self:SpriteColor())
	
	local dl = DynamicLight(self:EntIndex())
	if dl then
		dl.Pos = self:GetPos()
		if self.ParticleSuffix == "m" then
			dl.r = 160
			dl.g = 255
			dl.b = 60
		else
			dl.r = 255
			dl.g = 120
			dl.b = 40
		end
		dl.Brightness = 2
		dl.Size = 100
		dl.Decay = 160
		dl.DieTime = CurTime() + .2
	end
end

function ENT:SpriteColor()
	return Color(255,math.random(90,150),math.random(30,70),255)
end

function ENT:Think()
	
end
