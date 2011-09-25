include('shared.lua')
local mat = Material("effects/yellowflare")

function ENT:Draw()
	//render.SetMaterial(mat)
	//render.DrawSprite(self:GetPos()-(self:GetLocalAngles():Forward()*16),64,64,color_green)
end

function ENT:Think()
end

function ENT:OnRemove()
	//self.loop:Stop()
end