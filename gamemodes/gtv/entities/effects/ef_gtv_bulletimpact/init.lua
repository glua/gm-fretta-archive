local mat = Material("effects/yellowflare")
EFFECT.LifeTime = 0.4

function EFFECT:Init(data)
	self.Created = CurTime()
	self.Dir = data:GetNormal()
	self.col = Color(255,255,255,255)
end

function EFFECT:Think()
	if self.Created+self.LifeTime < CurTime() then
		return false
	end
	return true
end

function EFFECT:Render()
	if self.LifeTime != 0 then
		self.col.a = math.Clamp(((self.LifeTime+self.Created)-CurTime())*255,0,255)
	end
	render.SetMaterial(mat)
	render.DrawBeam(self:GetPos()-self.Dir*8,self:GetPos()+self.Dir*(CurTime()-self.Created)*160,24,0.5,1,self.col)
	return true
end