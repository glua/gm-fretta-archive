local PANEL = {}

PANEL.Tex = surface.GetTextureID("coinbattle/HUD/health_inner")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
end

function PANEL:PerformLayout()
	if !ValidEntity(LocalPlayer()) then return end
	self:SetPos(32,ScrH()-160)
	if self:IsVisible() then
		local hFrac = LocalPlayer():Health() / 100
		self:SetSize(128,19+88*(1 - hFrac))
	end
end

function PANEL:Paint()
	surface.SetTexture(self.Tex)
	surface.SetDrawColor(255,255,255,220)
	surface.DrawTexturedRect(0,0,128,128)
end

derma.DefineControl("HealthDisplay","",PANEL,"DPanel")