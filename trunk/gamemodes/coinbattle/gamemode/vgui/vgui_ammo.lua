local PANEL = {}

PANEL.Tex = surface.GetTextureID("coinbattle/HUD/ammo_inner")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
end

function PANEL:PerformLayout()
	if !ValidEntity(LocalPlayer()) then return end
	self:SetPos(ScrW()-160,ScrH()-160)
	local wep = LocalPlayer():GetActiveWeapon()
	if self:IsVisible() and ValidEntity(wep) then
		local aFrac = wep.dt.Energy / wep.MaxEnergy
		self:SetSize(128,19+88*(1 - aFrac))
	end
end

function PANEL:Paint()
	surface.SetTexture(self.Tex)
	surface.SetDrawColor(255,255,255,220)
	surface.DrawTexturedRect(0,0,128,128)
end

derma.DefineControl("AmmoDisplay","",PANEL,"DPanel")