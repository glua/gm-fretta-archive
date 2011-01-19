local PANEL = {}

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	self:SetPaintBackground( false )
	self:SetVisible( false )

	self.m_first = false
	self.m_state = -1
	self.m_achiev = -1
	--self.m_color = nil
	--self.m_bordercolor = nil
	self.m_player = nil
	
	self._STY_Border = 2
	self._STY_ArrowSpacing = 2
	
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
	
	self.dFirstArrow = vgui.Create("GWArrow", self.dLabel)
	self.dFirstArrow:UseLeft( true )
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
	
	self.dFailArrow = vgui.Create("GWArrow", self.dLabel)
	self.dFailArrow:UseLeft( false )
	self.dFailArrow:SetLeftInnerColor( self.colors.Fail )
	self.dFailArrow:SetRightInnerColor( self.colors.Fail )
	self.dFailArrow:SetLeftOuterColor( self.colors.Locked )
	self.dFailArrow:SetRightOuterColor( self.colors.Locked )

	self.dComboArrow = vgui.Create("GWArrow", self.dLabel)
	self.dComboArrow:UseLeft( false )
	self.dComboArrow:SetLeftInnerColor( self.colors.Orangey )
	self.dComboArrow:SetRightInnerColor( self.colors.Orangey )
	self.dComboArrow:SetLeftOuterColor( self.colors.Locked )
	self.dComboArrow:SetRightOuterColor( self.colors.Locked )
	

	self.dCLittleArrow = vgui.Create("GWArrow", self.dLabel)
	self.dCLittleArrow:UseLeft( false )
	self.dCLittleArrow:SetLeftInnerColor( self.colors.Orangey )
	self.dCLittleArrow:SetRightInnerColor( self.colors.Orangey )
	self.dCLittleArrow:SetLeftOuterColor( self.colors.Locked )
	self.dCLittleArrow:SetRightOuterColor( self.colors.Locked )
	
	self.dAvatar = vgui.Create("AvatarImage", self.dLabel)
	
	self.dText = vgui.Create("DLabel", self.dLabel)
	self.dText:SetText("x")
	self.dText:SetColor( color_white )
	
	self:SetFont( "garryware_smalltext" )
	
	self:SetText("")
	self:UseStale()

	--self.bLastIsWin = false
	self.bLastIsLocked = false
	
end

function PANEL:SetFont( sFont )
	self.dFirstArrow:SetFont( sFont )
	self.dWinArrow:SetFont( sFont )
	self.dFailArrow:SetFont( sFont )
	self.dComboArrow:SetFont( sFont )
	self.dCLittleArrow:SetFont( sFont )
	self.dText:SetFont( sFont )

end


function PANEL:PerformLayout()
	self.dLabel:SetSize( self:GetWide(), self:GetTall() )
	self.dLabel:SetPos( 0, 0 )

	self.dText:SetSize( self:GetWide() * 0.7, self:GetTall() )
	self.dText:Center()
	self.dText:AlignLeft( self:GetTall() + 8 )
	--self.dAvatar:SetSize( self:GetTall() - self._STY_Border * 2 , self:GetTall() - self._STY_Border * 2 )
	self.dAvatar:SetSize( self:GetTall() , self:GetTall() )
	
	self.dFirstArrow:SetSize( self:GetTall()*2.2 , self:GetTall() )
	self.dWinArrow:SetSize( self:GetTall()*2 , self:GetTall() )
	self.dFailArrow:SetSize( self:GetTall()*2 , self:GetTall() )
	self.dComboArrow:SetSize( self:GetTall()*2 , self:GetTall() )
	self.dCLittleArrow:SetSize( self:GetTall()*2 - self._STY_Border * 2 , self:GetTall() - self._STY_Border * 2 )
	
	self.dFirstArrow:Center()
	self.dWinArrow:Center()
	self.dFailArrow:Center()
	self.dComboArrow:Center()
	self.dCLittleArrow:Center()
	
	self.dFirstArrow:AlignRight( self._STY_ArrowSpacing * 4 + self:GetTall() * 4 + 2)
	self.dWinArrow:AlignRight( self._STY_ArrowSpacing * 3 + self:GetTall() * 3)
	self.dFailArrow:AlignRight( self._STY_ArrowSpacing * 2 + self:GetTall() * 2 )
	self.dComboArrow:AlignRight( self._STY_ArrowSpacing * 1 + self:GetTall() * 1 )
	self.dCLittleArrow:AlignRight( self._STY_ArrowSpacing * 0 + self:GetTall() * 0 )
	
end

function PANEL:SetPlayer( ent )
	if ValidEntity( ent ) /*and ent:IsPlayer()*/ then
		self.m_player = ent
		self.dAvatar:SetPlayer( self.m_player )
	end
	
end

function PANEL:SetText( sText )
	self.dText:SetText( sText )
	
end


function PANEL:UseStale()
	if self.m_state == 1 then return end
	
	self.dLabel:SetBackgroundColor( self.colors.Stale )
	
	self.m_state = 1
	
end

function PANEL:UseStale()
	if self.m_state == 1 then return end
	
	self.dLabel:SetBackgroundColor( self.colors.Stale )
	
	self.m_state = 1
	
end

function PANEL:UseMystery()
	if self.m_state == 2 then return end
	
	self.dLabel:SetBackgroundColor( self.colors.Mystery )
	
	self.m_state = 2
	
end


function PANEL:UseWin()
	if self.m_state == -1 then return end
	
	self.dLabel:SetBackgroundColor( self.colors.Win )
	
	self.m_state = -1
	
end


function PANEL:UseFail()
	if self.m_state == -2 then return end
	
	self.dLabel:SetBackgroundColor( self.colors.Fail )
	
	self.m_state = -2
	
end

function PANEL:UseLocked()
	if self.m_achiev == -2 then return end
	
	self.dLabel:SetBorderColor( self.colors.Locked )
	
	self.m_achiev = -2
	
end

function PANEL:UseUnlocked()
	if self.m_achiev == -1 then return end
	
	self.dLabel:SetBorderColor( self.colors.Unlocked )
	
	self.m_achiev = -1
	
end



function PANEL:Show()
	if self:IsVisible() then return end
	
	self:SetVisible( true )

end

function PANEL:Hide()
	if not self:IsVisible() then return end
	
	self:SetVisible( false )

end

function PANEL:EvaluateAchieved( )
	local bnIsWin = self.m_player:GetAchieved()
	if bnIsWin == nil then
		if not LocalPlayer():GetLocked() then
			self:UseMystery()
			
		else
			self:UseStale()
			
		end
		
	else
		if bnIsWin then
			self:UseWin( )
			
		else
			self:UseFail( )
		
		end
		
	end
	-- Don't do the check (don't know why)
	
end

function PANEL:EvaluateLocked( )	
	local bIsLocked = self.m_player:GetLocked()
	if bIsLocked ~= self.bLastIsLocked then
		if bIsLocked then
			self:UseLocked()
			
			--[[if self.m_player:GetCombo() >= 3 then
				self.dCentric:SetLeftOuterColor(  self.colors.Gold )
				self.dCentric:SetRightOuterColor( self.colors.Gold )
				
			else
				self.dCentric:SetLeftOuterColor(  self.colors.White )
				self.dCentric:SetRightOuterColor( self.colors.White )
				
			end]]--
			
		else
			self:UseUnlocked()
			
			--self.dCentric:SetLeftOuterColor(  self.colors.Black )
			--self.dCentric:SetRightOuterColor( self.colors.Black )
		
		end
		self.bLastIsLocked = bIsLocked
		
	end
	
end

function PANEL:Think()
	if self.m_player == nil then
		print("Developer BUG : A player label was thinking while being NIL ! Removed.")
		self:Remove()
		return
	end
	if not ValidEntity(self.m_player) or not self.m_player:IsPlayer() then
		self:Remove()
		return
	end
	
	--if not self.m_player:IsWarePlayer() then
	--	self:Hide()
	--	
	--else
	--	self:Show()
	--	
	--end
	
	if self.m_player:IsWarePlayer() then
		self:EvaluateLocked()
		self:EvaluateAchieved()
		self:SetText( self.m_player:Name() )
		
	else
		self:UseStale()
		self:UseLocked()
		if self.m_player:Team() == TEAM_SPECTATOR then
			self:SetText( self.m_player:Name() .. " (SPEC)" )
			
		elseif self.m_player:Team() == TEAM_UNASSIGNED then
			self:SetText( self.m_player:Name() .. " (LOBBY)" )
		
		else
			self:SetText( self.m_player:Name() )
		
		end
		
	end
	
	self.dWinArrow:SetText( self.m_player:Frags() )
	self.dFailArrow:SetText( self.m_player:Deaths() )
	self.dComboArrow:SetText( self.m_player:GetBestCombo() )
	self.dCLittleArrow:SetText( self.m_player:GetCombo() )
	
	if self.m_player:IsFirst() and not self.m_first then
		self.dFirstArrow:SetText( "1st" )
		self.dFirstArrow:UseLeft( false )
		self.m_first = not self.m_first

	elseif not self.m_player:IsFirst() and self.m_first then
		self.dFirstArrow:SetText( "" )
		self.dFirstArrow:UseLeft( true )
		self.m_first = not self.m_first
		
	end
	
end
/*
function PANEL:Paint()
	if not ValidEntity( self.m_player ) then return end
	
	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), self.m_bordercolor)
	draw.RoundedBox(0, self._STY_Border, self._STY_Border, self:GetWide() - self._STY_Border * 2, self:GetTall() - self._STY_Border * 2, self.m_color)

end
*/
vgui.Register( "GWPlayerLabel", PANEL, "DPanel" )