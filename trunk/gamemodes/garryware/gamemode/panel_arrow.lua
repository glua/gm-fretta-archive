local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground( false )
	self.bIsUsingLeft = false

	self.dLeftOuter = vgui.Create("DImage", self)
	self.dLeftOuter:SetImage("ware/interface/ui_scoreboard_arrow_left_outer")
	self.dLeftInner = vgui.Create("DImage", self.dLeftOuter)
	self.dLeftInner:SetImage("ware/interface/ui_scoreboard_arrow_left_inner")
	
	self.dRightOuter = vgui.Create("DImage", self)
	self.dRightOuter:SetImage("ware/interface/ui_scoreboard_arrow_right_outer")
	self.dRightInner = vgui.Create("DImage", self.dRightOuter)
	self.dRightInner:SetImage("ware/interface/ui_scoreboard_arrow_right_inner")
	
	self.dText = vgui.Create("DLabel", self)
	self.dText:SetText("x")
	self.dText:SetFont( "garryware_largetext" )
	self.dText:SetColor( color_white )
	
	self:SetText("")
	self:UseLeft( true )
	
end

function PANEL:SetFont( sFont )
	self.dText:SetFont( sFont )

end

function PANEL:SetColor( cColor )
	self.dText:SetColor( cColor )

end

function PANEL:UseLeft( bUseLeft )
	if self.bIsUsingLeft == bUseLeft then return end
	
	if bUseLeft then
		self.dLeftInner:SetVisible( true )
		self.dLeftOuter:SetVisible( true )
		self.dRightInner:SetVisible( false )
		self.dRightOuter:SetVisible( false )
	
	else
		self.dLeftInner:SetVisible( false )
		self.dLeftOuter:SetVisible( false )
		self.dRightInner:SetVisible( true )
		self.dRightOuter:SetVisible( true )
		
	end
	
	self.bIsUsingLeft = bUseLeft
	
end

function PANEL:SetText( sText )
	self.dText:SetText( sText )
	self:InvalidateLayout()
	
end

function PANEL:SetLeftInnerColor( cColor )
	self.dLeftInner:SetImageColor( cColor )
	
end

function PANEL:SetLeftOuterColor( cColor )
	self.dLeftOuter:SetImageColor( cColor )
	
end

function PANEL:SetRightInnerColor( cColor )
	self.dRightInner:SetImageColor( cColor )
	
end

function PANEL:SetRightOuterColor( cColor )
	self.dRightOuter:SetImageColor( cColor )
	
end

function PANEL:Think()

end

function PANEL:PerformLayout()
	self.dLeftInner:SetSize( self:GetSize() )
	self.dLeftOuter:SetSize( self:GetSize() )
	self.dRightInner:SetSize( self:GetSize() )
	self.dRightOuter:SetSize( self:GetSize() )
	self.dText:SizeToContents()
	
	self.dLeftInner:Center()
	self.dLeftOuter:Center()
	self.dRightInner:Center()
	self.dRightOuter:Center()
	self.dText:Center()
	
end

vgui.Register( "GWArrow", PANEL, "DPanel" )