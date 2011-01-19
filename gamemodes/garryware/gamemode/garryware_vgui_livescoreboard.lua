PANEL.Base = "DPanel"

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	self:SetPaintBackground( false )
	self:SetVisible( false )
	

	self.SortRefreshDelay = 0.1
	self.SortRefreshTime  = 0
	
	self.LabelMakeRefreshDelay = 2.0
	self.LabelMakeRefreshTime  = 0
	
	self.m_playerlist = {}
	self._STY_LabelHeight = 16
	self._STY_PADding     = 8
	
	self.m_secondary_sort = false
	
	self:InvalidateLayout()
	
end

	-- Sakuya can read source code


function PANEL:PerformLayout()
	local width  = ScrW() * 0.7
	if width > 768 then width = 768 end
	local main_height = (width * 0.5) / 512 * 64
	width = width - 128
	
	if not self.m_secondary_sort then
		local heightcalc = ScrH() * 0.35 - 8 - main_height
		heightcalc = heightcalc - heightcalc % self._STY_LabelHeight
		self:SetSize( width, heightcalc )
		
	else
		local heightcalc = ScrH() - 8 + main_height
		self:SetSize( width, heightcalc )
		
	end
	self:SetPos( (ScrW() - width) * 0.5, 8 + main_height )
	
end

function PANEL:UseSecondarySort()
	self.m_secondary_sort = true
	self:InvalidateLayout()
	
end

function PANEL:UseNormalSort()
	self.m_secondary_sort = false
	self:InvalidateLayout()
	
end

function PANEL:LabelRefresh( bForce )
	if not bForce and (CurTime() < (self.LabelMakeRefreshDelay + self.LabelMakeRefreshTime)) then return end
	
	if bForce then
		self.m_playerlist = {}
	end
	
	for k,ply in pairs( player.GetAll() ) do
		if bForce then
			if ply._cl_label then
				ply._cl_label:Remove()
				ply._cl_label = nil
			end
		end
		
		if not ply._cl_label then
			ply._cl_label = vgui.Create("GWPlayerLabel", self)
			ply._cl_label:SetSize( self:GetWide() * 0.5 - self._STY_PADding, self._STY_LabelHeight )
			ply._cl_label:SetPlayer( ply )
			ply._cl_label:SetPos( 0, 0 )
			ply._cl_label:SetZPos( 1337 )
			ply._cl_label:InvalidateLayout( )
			
			table.insert( self.m_playerlist, ply )
			
		end
		
	end
	
	self.LabelMakeRefreshTime = CurTime()
	
end

function PANEL:SortPlayerList()
	if CurTime() < (self.SortRefreshDelay + self.SortRefreshTime) then return end
			
	local k = 1
	while k <= #self.m_playerlist do
		if not ValidEntity( self.m_playerlist[k] ) then
			table.remove( self.m_playerlist, k )
			
		else
			k = k + 1
			
		end
		
	end
	
	if #self.m_playerlist > 1 then
		if not self.m_secondary_sort then
			table.sort( self.m_playerlist , WARE_SortTable )
		
		else
			table.sort( self.m_playerlist , WARE_SortTableStateBlind )
		
		end
		
	end
	
	local iNumPlayers = team.NumPlayers( TEAM_HUMANS )
	local iWinStack  = 0
	local iFailStack = 0
	for k,ply in pairs( self.m_playerlist ) do
		if ply:IsWarePlayer() then
			ply._cl_label:Show()
			if not self.m_secondary_sort then
				if ply:GetAchieved() then
					if not (ply._cl_label.m_tpos == iWinStack) or not (ply._cl_label.m_tcol == 1) then
						ply._cl_label:MoveTo( 0, iWinStack * ply._cl_label:GetTall() , 0.2, 0, 2)
					
						ply._cl_label.m_tpos = iWinStack
						ply._cl_label.m_tcol = 1
						
					end
					
					iWinStack = iWinStack + 1
					
				else				
					if not (ply._cl_label.m_tpos == iFailStack) or not (ply._cl_label.m_tcol == -1) then
						ply._cl_label:MoveTo( self:GetWide() - ply._cl_label:GetWide(), iFailStack * ply._cl_label:GetTall() , 0.2, 0, 2)
						
						ply._cl_label.m_tpos = iFailStack
						ply._cl_label.m_tcol = -1
						
					end
					
					iFailStack = iFailStack + 1
					
				end
				
			else
				if not (ply._cl_label.m_tpos == iWinStack) or not (ply._cl_label.m_tcol == 0) then
					ply._cl_label:MoveTo( self:GetWide() * 0.5 - ply._cl_label:GetWide() * 0.5, iWinStack * ply._cl_label:GetTall() , 0.2, 0, 2)
				
					ply._cl_label.m_tpos = iWinStack
					ply._cl_label.m_tcol = 0
					
				end
				iWinStack = iWinStack + 1
				
			end
		else
			if not self.m_secondary_sort then
				if ply._cl_label:IsVisible() then
					ply._cl_label:SetPos( (ScrW() - ply._cl_label:GetWide()) / 2, -ply._cl_label:GetTall() )
					ply._cl_label:Hide()
				
				end
				
			else
				if not ply._cl_label:IsVisible() then
					ply._cl_label:Show()
					ply._cl_label:MoveTo( self:GetWide() * 0.5 - ply._cl_label:GetWide() * 0.5, (iNumPlayers + iFailStack) * ply._cl_label:GetTall() , 0.2, 0, 2)
				end
				
				local iTheoStack = (iNumPlayers + iFailStack)
				if not (ply._cl_label.m_tpos == iTheoStack) or not (ply._cl_label.m_tcol == 0) then
					ply._cl_label:MoveTo( self:GetWide() * 0.5 - ply._cl_label:GetWide() * 0.5, iTheoStack * ply._cl_label:GetTall() , 0.2, 0, 2)
					
					ply._cl_label.m_tpos = iNumPlayers + iFailStack
					ply._cl_label.m_tcol = 0
				end
				
				iFailStack = iFailStack + 1
				
			end
			
		end
		
		
	end
	
	self.SortRefreshTime = CurTime()
	
end

function PANEL:Think()

	self:LabelRefresh()
	self:SortPlayerList()
	
end

function PANEL:Show()
	if self:IsVisible() then return end
	
	self:SetVisible( true )

end

function PANEL:Hide()
	if not self:IsVisible() then return end
	
	self:SetVisible( false )

end

--function PANEL:Paint()
	--draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0, 64) )
--end

--Derma_Hook( PANEL, "Paint", "Paint", "GWLive" )