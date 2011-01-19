PANEL.Base = "GWMessage"

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	self:SetPaintBackground( true )
	self:SetVisible( true )
	
end

function PANEL:PerformLayout()
	self:SetWidth(  self._INS_Wb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
	self:SetHeight( self._INS_Hb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
	self:SetPos( (ScrW() - self:GetWide()) * 0.5, ScrH() * 12 / 16.0 - self:GetTall() * 0.5 )
	
end

--Derma_Hook( PANEL, "Paint", "Paint", "GWInstructions" )