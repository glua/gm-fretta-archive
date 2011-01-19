local PANEL = {}

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	
	self:SetText("")
	
	self._STY_Border = 2
	self.m_bordercolor = nil
	self.m_color       = nil
	
	self:InvalidateLayout()
	
end

function PANEL:SetBorderColor( cColor )
	self.m_bordercolor = cColor
end

function PANEL:SetBackgroundColor( cColor )
	self.m_color = cColor
end

function PANEL:Paint()
	if self.m_bordercolor then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), self.m_bordercolor)
	end
	
	if self.m_color then
		draw.RoundedBox(0, self._STY_Border, self._STY_Border, self:GetWide() - self._STY_Border * 2, self:GetTall() - self._STY_Border * 2, self.m_color)
	end
	
end

vgui.Register( "GWLabel", PANEL, "DLabel" )