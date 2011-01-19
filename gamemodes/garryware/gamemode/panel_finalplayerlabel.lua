local PANEL = {}

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	self:SetPaintBackground( false )
	self:SetVisible( false )

	self.m_nocombo = false
	--self.m_color = nil
	--self.m_bordercolor = nil
	self.m_player = nil
	
	self._STY_ArrowAlter = 0.6
	self._STY_Border = 2
	
	self.colors = {}
	self.colors.Gold  = Color( 255, 255, 128 )
	self.colors.Orangey  = Color( 255, 164, 92 )
	self.colors.Win   = Color(   0, 164, 237 )
	self.colors.Fail  = Color( 255,  87,  87 )
	self.colors.Black = Color(   0,   0,   0,  87 )
	self.colors.White = Color( 255, 255, 255, 192 )
	self.colors.Stale    = Color( 192, 192, 192 )
	self.colors.Mystery  = Color( 90, 220, 220 )
	
	self.colors.PlatineBlack  = Color( 20, 20, 20 )
	self.colors.Platine  = Color( 255, 255, 255 )
	self.colors.Invisible  = Color( 0, 0, 0, 0 )
	
	self.colors.Locked  =  Color( 255, 255, 255, 192 )
	self.colors.Unlocked  =  Color( 0, 0, 0, 128 )
	
	self.dLabel = vgui.Create("GWLabel", self)
	self.dLabel:SetBackgroundColor( self.colors.Win )
	self.dLabel:SetBorderColor( self.colors.Locked )
	
	self.dFirstArrow = vgui.Create("GWArrow", self.dLabel)
	self.dFirstArrow:UseLeft( false )
	self.dFirstArrow:SetLeftInnerColor( self.colors.Invisible )
	self.dFirstArrow:SetRightInnerColor( self.colors.Platine )
	self.dFirstArrow:SetLeftOuterColor( self.colors.Invisible )
	self.dFirstArrow:SetRightOuterColor( self.colors.Unlocked )
	self.dFirstArrow:SetColor( self.colors.PlatineBlack )
	
	self.dWinArrow = vgui.Create("GWArrow", self.dLabel)
	self.dWinArrow:UseLeft( false )
	self.dWinArrow:SetLeftInnerColor( self.colors.Win )
	self.dWinArrow:SetRightInnerColor( self.colors.Win )
	self.dWinArrow:SetLeftOuterColor( self.colors.Locked )
	self.dWinArrow:SetRightOuterColor( self.colors.Locked )

	self.dComboArrow = vgui.Create("GWArrow", self.dLabel)
	self.dComboArrow:UseLeft( false )
	self.dComboArrow:SetLeftInnerColor( self.colors.Orangey )
	self.dComboArrow:SetRightInnerColor( self.colors.Orangey )
	self.dComboArrow:SetLeftOuterColor( self.colors.Locked )
	self.dComboArrow:SetRightOuterColor( self.colors.Locked )
	
	/*self.dCLittleArrow = vgui.Create("GWArrow", self.dLabel)
	self.dCLittleArrow:UseLeft( false )
	self.dCLittleArrow:SetLeftInnerColor( self.colors.Platine )
	self.dCLittleArrow:SetRightInnerColor( self.colors.Platine )
	self.dCLittleArrow:SetLeftOuterColor( self.colors.PlatineBlack )
	self.dCLittleArrow:SetRightOuterColor( self.colors.PlatineBlack )
	self.dCLittleArrow:SetColor( self.colors.PlatineBlack )*/
	
	self.dAvatar = vgui.Create("AvatarImage", self.dLabel)
	
	self.dText = vgui.Create("DLabel", self.dLabel)
	self.dText:SetText("x")
	self.dText:SetFont( "garryware_smalltext" )
	self.dText:SetColor( color_white )
	
	self:SetFont( "garryware_mediumtext" )
	
	self:SetText("")

	--self.bLastIsWin = false
	self.bLastIsLocked = false
	
end

function PANEL:SetFont( sFont )
	self.dFirstArrow:SetFont( sFont )
	self.dWinArrow:SetFont( sFont )
	self.dComboArrow:SetFont( sFont )
	--self.dCLittleArrow:SetFont( sFont )
	self.dText:SetFont( sFont )

end


function PANEL:PerformLayout()
	self.dLabel:SetSize( self:GetWide(), self:GetTall() )
	self.dLabel:SetPos( 0, 0 )


	self.dFirstArrow:SetSize( self:GetTall() * 2.2 , self:GetTall() )
	self.dFirstArrow:Center()
	self.dFirstArrow:AlignLeft( 0 )
	
	self.dAvatar:SetSize( self:GetTall() , self:GetTall() )
	self.dAvatar:AlignLeft( 8 + self.dFirstArrow:GetWide() )
	
	self.dText:SetSize( self:GetWide() * 0.7, self:GetTall() )
	self.dText:Center()
	self.dText:AlignLeft( self.dFirstArrow:GetWide() + self.dAvatar:GetWide() + 8 )
	--self.dAvatar:SetSize( self:GetTall() - self._STY_Border * 2 , self:GetTall() - self._STY_Border * 2 )
	
	self.dFirstArrow:SetSize( self:GetTall()*2.2 , self:GetTall() )
	self.dWinArrow:SetSize( self:GetTall()*2 , self:GetTall() )
	self.dComboArrow:SetSize( self:GetTall()*2 , self:GetTall() )
	--self.dCLittleArrow:SetSize( self:GetTall()*2.2 , self:GetTall() - self._STY_Border * 2 )
	
	self.dWinArrow:Center()
	self.dComboArrow:Center()
	--self.dCLittleArrow:Center()
	
	if not self.m_nocombo then
		--self.dWinArrow:AlignRight( self.dComboArrow:GetWide()*self._STY_ArrowAlter + self.dCLittleArrow:GetWide()*self._STY_ArrowAlter + 8 )
		--self.dComboArrow:AlignRight( self.dCLittleArrow:GetWide()*self._STY_ArrowAlter + 8 )
		self.dWinArrow:AlignRight( self.dComboArrow:GetWide()*self._STY_ArrowAlter )
		self.dComboArrow:AlignRight( 0 )
		
	else
		--self.dWinArrow:AlignRight( self.dCLittleArrow:GetWide()*self._STY_ArrowAlter + 8 )
		self.dWinArrow:AlignRight( 0 )
		self.dComboArrow:SetVisible( false )
	
	end
	--self.dCLittleArrow:AlignRight( 0 )
	
end

function PANEL:SetPlayer( ent )
	if ValidEntity( ent ) then
		self.m_player = ent
		self.dAvatar:SetPlayer( self.m_player )
	end
	
end

function PANEL:SetText( sText )
	self.dText:SetText( sText )
	
end

function PANEL:UseNoCombo( sText )
	self.m_nocombo = true
	self:InvalidateLayout()
	
end

function PANEL:SetLeftPlatineData( sText )
	self.dFirstArrow:SetText( sText )
	
end
/*
function PANEL:SetRightPlatineData( sText )
	self.dCLittleArrow:SetText( sText )
	
end
*/
function PANEL:Show()
	if self:IsVisible() then return end
	
	self:SetVisible( true )

end

function PANEL:Hide()
	if not self:IsVisible() then return end
	
	self:SetVisible( false )

end

function PANEL:Think()
	if self.m_player == nil then
		print("Developer BUG : A player label was thinking while being NIL ! Removed.")
		self:Remove()
		return
	end
	if not ValidEntity(self.m_player) or not self.m_player:IsPlayer() then
		--self:Remove()
		-- DO NOT REMOVE INVALID PLAYERS. USE THEIR OLD DATA STORED IN THE LABELS
		return
	end
	
	self:SetText( self.m_player:Name() )
	self.dWinArrow:SetText( self.m_player:Frags() )
	self.dComboArrow:SetText( self.m_player:GetBestCombo() )
	
end

vgui.Register( "GWFinalPlayerLabel", PANEL, "DPanel" )