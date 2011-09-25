local refang = Angle(0,0,0)

function EFFECT:Init(data)
	self.Value = data:GetScale()
	self.Created = CurTime()
	self:EmitSound("weapons/crossbow/bolt_skewer1.wav",100,255)
	ParticleEffect("gtv_lightburst",self:GetPos(),refang,self)
end

function EFFECT:Think()
	if self.Created+1 < CurTime() then
		return false
	end
	return true
end

function EFFECT:Render()
	local pos = self:GetPos():ToScreen()
	cam.Start2D()
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("CV24")
		local text = ("+"..self.Value)
		local w,h = surface.GetTextSize(text)
		surface.SetTextPos(pos.x-w/2,pos.y-(CurTime()-self.Created)*48)
		surface.DrawText(text)
	cam.End2D()
	return true
end