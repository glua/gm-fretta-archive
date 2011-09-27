local PANEL = {}

PANEL.Tex = surface.GetTextureID("hud/ammo-inner")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
end

function PANEL:PerformLayout()
	if !ValidEntity(LocalPlayer()) then return end
	self:SetPos(132,ScrH()-83)
	local wep = LocalPlayer():GetActiveWeapon()
	if self:IsVisible() and ValidEntity(wep) then
		local aFrac = wep:GetNetworkedInt("ammo") / 30.0
		self:SetSize(64,9+44*(1 - aFrac))
	end
end

function PANEL:Paint()
	surface.SetTexture(self.Tex)
	surface.SetDrawColor(0,0,0,220)
	surface.DrawTexturedRect(0,0,64,64)
end

derma.DefineControl("AmmoClip","",PANEL,"DPanel")