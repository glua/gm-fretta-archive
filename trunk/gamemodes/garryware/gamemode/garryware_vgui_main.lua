PANEL.Base = "DPanel"

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	self:SetPaintBackground( false )
	self:SetVisible( false )
	
	self.m_state = -1
	
	self.colors = {}
	self.colors.Gold  = Color( 255, 255, 128 )
	self.colors.Win   = Color(   0, 164, 237 )
	self.colors.Fail  = Color( 255,  87,  87 )
	self.colors.Black = Color(   0,   0,   0,  87 )
	self.colors.White = Color( 255, 255, 255, 192 )
	self.colors.Stale    = Color( 192, 192, 192 )
	self.colors.Mystery  = Color( 90, 220, 220 )
	
	self.dCentric = vgui.Create("GWArrow", self)
	self.dCentric:SetZPos( 9005 )
	self:UseGeneric()
	
	self.dWinBox = vgui.Create("DPanel", self)
	self.dWinBox:SetPaintBackground( false )
	self.dWinBox:SetZPos( 9002 )
	self.dWinImage = vgui.Create("DImage", self.dWinBox)
	self.dWinImage:SetImage("ware/interface/ui_scoreboard_winner_noloss")
	self.dWinText = vgui.Create("DLabel", self.dWinImage)
	self.dWinText:SetText("Winners")
	self.dWinText:SetFont( "garryware_mediumtext" )
	self.dWinText:SetColor( color_white )

	self.dWinPart = vgui.Create("GWArrow", self.dWinBox)
	self.dWinPart:SetZPos( 9003 )
	self.dWinPart:UseLeft( false )
	self.dWinPart:SetRightInnerColor( self.colors.Win )
	self.dWinPart:SetRightOuterColor( self.colors.Black )
	
	
	self.dFailBox = vgui.Create("DPanel", self)
	self.dFailBox:SetPaintBackground( false )
	self.dFailBox:SetZPos( 9002 )
	self.dFailImage = vgui.Create("DImage", self.dFailBox)
	self.dFailImage:SetImage("ware/interface/ui_scoreboard_failure_noloss")
	self.dFailText = vgui.Create("DLabel", self.dFailImage)
	self.dFailText:SetText("Failures")
	self.dFailText:SetFont( "garryware_mediumtext" )
	self.dFailText:SetColor( color_white )
	
	self.dFailPart = vgui.Create("GWArrow", self.dFailBox)
	self.dFailPart:SetZPos( 9003 )
	self.dFailPart:UseLeft( true )
	self.dFailPart:SetLeftInnerColor( self.colors.Fail )
	self.dFailPart:SetLeftOuterColor( self.colors.Black )
	
	self.iLastWinFailRatio = 0.5
	self.iDrawKeep = 0.4
	
	self.bLastIsWin = false
	self.bLastIsLocked = false
	
end

function PANEL:UseGeneric()
	if self.m_state == 0 then return end
	
	self.dCentric:SetLeftInnerColor(  self.colors.Win )
	self.dCentric:SetRightInnerColor( self.colors.Fail )
	
	self.m_state = 0
	
end

function PANEL:UseStale()
	if self.m_state == 1 then return end
	
	self.dCentric:SetLeftInnerColor(  self.colors.Stale )
	self.dCentric:SetRightInnerColor( self.colors.Stale )
	
	self.m_state = 1
	
end

function PANEL:UseMystery()
	if self.m_state == 2 then return end
	
	self.dCentric:SetLeftInnerColor(  self.colors.Win )
	self.dCentric:SetRightInnerColor( self.colors.Mystery )
	
	self.m_state = 2
	
end


function PANEL:PerformLayout()
	local width  = ScrW() * 0.7
	if width > 768 then width = 768 end
	local height = (width * 0.5) / 512 * 64
	
	self:SetSize( width, height )
	self:SetPos( (ScrW() - width) * 0.5, 8 )

	--NOTE : CONVERT THE CENTRIC TO ITS OWN PANEL! ... or not
	self.dCentric:SetWide( self:GetWide() * 0.5 * 0.25 )
	self.dCentric:SetTall( self:GetTall() )
	self.dCentric:Center( )
	self.dCentric:InvalidateLayout( )
	
	
	self.dWinBox:SetWide( self:GetWide() * 0.5 )
	self.dWinBox:SetTall( self:GetTall() )
	self.dWinBox:AlignLeft( )
	self.dWinBox:CenterVertical( )
	self.dWinImage:SetWide( self.dWinBox:GetWide() )
	self.dWinImage:SetTall( self.dWinBox:GetTall() )
	--self.dWinImage:AlignLeft( )
	--self.dWinImage:CenterVertical( )
	self.dWinText:SizeToContents( )
	self.dWinText:AlignLeft( 16 )
	self.dWinText:CenterVertical( )
	
	self.dWinPart:SetWide( self:GetWide() * 0.5 * 0.25 )
	self.dWinPart:SetTall( self:GetTall() )
	self.dWinPart:AlignLeft( 0 )
	self.dWinPart:CenterVertical( )
	
	
	self.dFailBox:SetWide( self:GetWide() * 0.5 )
	self.dFailBox:SetTall( self:GetTall() )
	self.dFailBox:AlignRight()
	self.dFailBox:CenterVertical( )
	self.dFailImage:SetWide( self.dFailBox:GetWide() )
	self.dFailImage:SetTall( self.dFailBox:GetTall() )
	--self.dFailImage:AlignRight( )
	--self.dFailImage:CenterVertical( )
	self.dFailText:SizeToContents( )
	self.dFailText:AlignRight( 16 )
	self.dFailText:CenterVertical( )

	self.dFailPart:SetWide( self:GetWide() * 0.5 * 0.25 )
	self.dFailPart:SetTall( self:GetTall() )
	self.dFailPart:AlignRight( 0 )
	self.dFailPart:CenterVertical( )
	
end

function PANEL:EvaluateLocked( )	
	local bIsLocked = LocalPlayer():GetLocked()
	if bIsLocked ~= self.bLastIsLocked then
		if bIsLocked then
			if LocalPlayer():GetCombo() >= 3 then
				self.dCentric:SetLeftOuterColor(  self.colors.Gold )
				self.dCentric:SetRightOuterColor( self.colors.Gold )
				
			else
				self.dCentric:SetLeftOuterColor(  self.colors.White )
				self.dCentric:SetRightOuterColor( self.colors.White )
				
			end
			
		else
			self.dCentric:SetLeftOuterColor(  self.colors.Black )
			self.dCentric:SetRightOuterColor( self.colors.Black )
		
		end
		self.bLastIsLocked = bIsLocked
		
	end
	
end

function PANEL:EvaluateAchieved( )	
	local bIsWin = LocalPlayer():GetAchieved()
	if bIsWin ~= self.bLastIsWin then
		if bIsWin then
			self.dCentric:UseLeft( true )
			
		else
			self.dCentric:UseLeft( false )
		
		end
		self.bLastIsWin = bIsWin
		
	end
	
end



function PANEL:Think()
	if not ValidEntity( LocalPlayer() ) or not LocalPlayer().GetAchieved then return end
	
	if LocalPlayer():GetAchieved() == nil then
		if not LocalPlayer():GetLocked() then
			self:UseMystery()
			
		else
			self:UseStale()
			
		end
		
	else
		self:UseGeneric()
		
	end

	
	do --ScoreboardTopShift
		local tCount = team.GetPlayers( TEAM_HUMANS )
		local iCount = 0
		for k,ply in pairs( team.GetPlayers( TEAM_HUMANS ) ) do
			if not ply:GetAchieved() then
				iCount = iCount + 1
			end
		end
		local iWinFailRatio = iCount / #tCount
		
		if iWinFailRatio ~= self.iLastWinFailRatio then
			local displacement = (0.5 - self.iDrawKeep * 0.5) + iWinFailRatio * self.iDrawKeep
			self.dWinImage:MoveTo( displacement * self.dWinImage:GetWide(), 0, 0.3, 0, 2)
			self.dFailImage:MoveTo( (1 - displacement) * -self.dFailImage:GetWide(), 0, 0.3, 0, 2)
			self.iLastWinFailRatio = iWinFailRatio
			
		end
		
		self.dFailPart:SetText( iCount )
		self.dWinPart:SetText( #tCount - iCount )
	end
	
	self:EvaluateLocked( )
	self:EvaluateAchieved( )
	
	self.dCentric:SetText( LocalPlayer():GetCombo() )
	
end

function PANEL:Show()
	if self:IsVisible() then return end
	
	self:SetVisible( true )

end

function PANEL:Hide()
	if not self:IsVisible() then return end
	
	self:SetVisible( false )

end

Derma_Hook( PANEL, "Paint", "Paint", "GWMain" )