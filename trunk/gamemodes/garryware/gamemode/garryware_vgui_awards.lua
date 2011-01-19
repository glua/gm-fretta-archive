PANEL.Base = "DPanel"

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	self:SetPaintBackground( false )
	self:SetVisible( false )
	
	self.colors = {}
	self.colors.Background = Color(0, 0, 0, 128)
	self.colors.Good   = Color(   0, 164, 237 )
	
	self.m_display = false
	self.m_timehide = 0
	
	self.dLeftPanel = vgui.Create( "DPanel", self )
	self.dRightPanel = vgui.Create( "DPanel", self )
	
	--self.dGamemodeName = vgui.Create( "DImage", self.dLeftPanel )
	--self.dGamemodeName:SetZPos( 2500 )
	--self.dGamemodeName:SetImage( "vgui/ware/garryware_logo_alone" )
	
	self.dScoreTitle = vgui.Create("GWLabel", self.dLeftPanel)
	self.dScoreTitle:SetText("Summary")
	self.dScoreTitle:SetFont( "garryware_largetext" )
	self.dScoreTitle:SetColor( color_white )
	self.dScoreTitle:SetZPos( 2000 )
	self.dScoreTitle:SetContentAlignment( 5 )
	self.dScoreTitle:SetBorderColor( self.colors.Border )
	self.dScoreTitle:SetBackgroundColor( self.colors.Good )
	
	self:InvalidateLayout( true )
	
end

function PANEL:PerformLayout()
	self:SetSize( ScrW(), ScrH() )
	
	local widthcalc = (ScrW() - 500) / 2
	widthcalc = (widthcalc < (ScrW() * 0.3)) and (ScrW() * 0.3) or widthcalc
	
	self.dLeftPanel:SetSize( widthcalc, ScrH() )
	self.dRightPanel:SetSize( widthcalc, ScrH() )
	
	self.dLeftPanel:SetPos( -self.dLeftPanel:GetWide(), 0 )
	self.dRightPanel:SetPos( ScrW(), 0 )
	
	self.dScoreTitle:SetSize( self.dLeftPanel:GetWide(), 32 )
	self.dScoreTitle:Center()
	self.dScoreTitle:AlignTop( 5 )
	
	--self.dGamemodeName:SizeToContents()
	--self.dGamemodeName:AlignTop( 5 )
	--self.dGamemodeName:AlignLeft( 32 )
	
	self:SetPos( 0, 0 )
	
end

function PANEL:Think()
	if not self.m_display and CurTime() > self.m_timehide and self:IsVisible() then
		self:SetVisible( false )
	end
	
end

function PANEL:Show()
	if self.m_display then return end
	
	self:InvalidateLayout( true )
	
	--DEBUG REMOVE
	--self:PerformScoreData()
	
	self:SetVisible( true )
	self.dLeftPanel:MoveTo( 0, 0, 0.2, 0, 2)
	self.dRightPanel:MoveTo( ScrW() - self.dRightPanel:GetWide(), 0, 0.2, 0, 2)
	
	self.m_display = not self.m_display

end

function PANEL:Hide()
	if not self.m_display then return end
	
	self.m_timehide = CurTime() + 1.0
	
	self.dLeftPanel:MoveTo( -self.dRightPanel:GetWide(), 0, 0.2, 0, 2)
	self.dRightPanel:MoveTo( ScrW(), 0, 0.2, 0, 2)
	
	self.m_display = not self.m_display

end

function PANEL:PerformScoreData()
	print("performing")

	-- There's also a similar one in the server
	local players = team.GetPlayers( TEAM_HUMANS )
	if #players < 2 then return end
	
	table.sort( players, WARE_SortTableStateBlind )
	
	local best_score         = players[1]:Frags()
	local best_scorer__combo = players[1]:GetBestCombo()
	local best_combo_by_t    = { }
	local best_combo         = 0
	
	local tie    = { }
	local almost = { }
	for _,ply in pairs( players ) do
		if ply:Frags() == best_score then
			if ply:GetBestCombo() == best_scorer__combo then
				table.insert( tie , ply )
				
			else
				table.insert( almost , ply )
				
			end
			
		end
		
		if ply:GetBestCombo() > best_combo then
			best_combo_by_t = { ply }
			best_combo = ply:GetBestCombo()

		elseif ply:GetBestCombo() == best_combo then
			table.insert( best_combo_by_t , ply )
		
		end
		
	end
	
	local place = 1
	local stx,sty = self.dScoreTitle:GetPos()
	local stack = sty + self.dScoreTitle:GetTall() + 8
	for k,ply in pairs(tie) do
		local label = vgui.Create("GWFinalPlayerLabel", self.dLeftPanel)
		label:SetPlayer( ply )
		label:SetSize( self.dLeftPanel:GetWide() - 32, 32 )
		label:SetPos( (self.dLeftPanel:GetWide() - label:GetWide()) * 0.5, stack )
		stack = stack + label:GetTall()
		
		label:SetLeftPlatineData("1st")
		--label:SetRightPlatineData( ply:Frags() + ply:Deaths() )
		
		label:InvalidateLayout( )
		label:Show()
	end
	place = place + #tie
	for k,ply in pairs(almost) do
		local label = vgui.Create("GWFinalPlayerLabel", self.dLeftPanel)
		label:SetPlayer( ply )
		label:SetSize( self.dLeftPanel:GetWide() - 32, 18 )
		label:SetPos( (self.dLeftPanel:GetWide() - label:GetWide()) * 0.5, stack )
		stack = stack + label:GetTall()
		label:SetFont( "garryware_averagetext" )
		
		label:SetLeftPlatineData( (place == 2 and "2nd" or place == 3 and "3rd" or (place.. "'")) )
		--label:SetRightPlatineData( ply:Frags() + ply:Deaths() )
		
		label:InvalidateLayout( )
		label:Show()
	end
	place = place + #almost
	
	local cumulator = 0
	for k,ply in pairs(players) do
		if k > (#tie + #almost) then
			local label = vgui.Create("GWFinalPlayerLabel", self.dLeftPanel)
			label:SetPlayer( ply )
			label:SetSize( self.dLeftPanel:GetWide() - 32, 16 )
			label:SetPos( (self.dLeftPanel:GetWide() - label:GetWide()) * 0.5, stack )
			stack = stack + label:GetTall()
			label:SetFont( "garryware_smalltext" )
			
			label:SetLeftPlatineData( (place == 2 and "2nd" or place == 3 and "3rd" or (place.. "'")) )
			--label:SetRightPlatineData( ply:Frags() + ply:Deaths() )
			
			if (ply:Frags() == players[ k - 1 ]:Frags()) and (ply:GetBestCombo() == players[ k - 1 ]:GetBestCombo()) then
				cumulator = cumulator + 1
			
			else
				place = place + cumulator + 1
				cumulator = 0
				
			end
			
			label:InvalidateLayout( )
			label:Show()
		end
	end

end

function PANEL:Paint()
	local lx,ly =  self.dLeftPanel:GetPos()
	local rx,ry = self.dRightPanel:GetPos()
	
	draw.RoundedBox(0, lx, ly,  self.dLeftPanel:GetWide(),  self.dLeftPanel:GetTall(), self.colors.Background)
	draw.RoundedBox(0, rx, ry, self.dRightPanel:GetWide(), self.dRightPanel:GetTall(), self.colors.Background)
	
end
