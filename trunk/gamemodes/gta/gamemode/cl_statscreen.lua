
surface.CreateFont( "28 Days Later", 50, 500, true, false, "SplashHuge" )
surface.CreateFont( "Tahoma", 36, 500, true, false, "DescText" )

local PANEL = {}

function PANEL:Init()

	self:SetText( "" )
	self:SetSkin( GAMEMODE.HudSkin )
	self:ParentToHUD()
	
	self.DoClick = function() 
		if self.ClickTime > CurTime() then return end
		LocalPlayer():EmitSound( Sound( "doors/metal_stop1.wav" ), 100, 60 ) 
		self:Remove() 
	end
	
	self.lblReport = vgui.Create( "DLabel", self )
		self.lblReport:SetText( "* DAMAGE REPORT *" )
		self.lblReport:SetFont( "SplashHuge" )
		self.lblReport:SetColor( Color( 255, 255, 255, 255 ) )
		
	self.lblTeam = vgui.Create( "DLabel", self )
		self.lblTeam:SetText( "It was a tie!" ) 
		self.lblTeam:SetFont( "DescText" )
		
	self.lblBusts = vgui.Create( "DLabel", self )
		self.lblBusts:SetText( "No gang members were arrested." ) 
		self.lblBusts:SetFont( "DescText" )
		
	self.lblKills = vgui.Create( "DLabel", self )
		self.lblKills:SetText( "No gang members were killed." ) 
		self.lblKills:SetFont( "DescText" )
		
	self.lblCash = vgui.Create( "DLabel", self )
		self.lblCash:SetText( "No cash was stolen at all." ) 
		self.lblCash:SetFont( "DescText" )
		
	self.lblKills2 = vgui.Create( "DLabel", self )
		self.lblKills2:SetText( "No civilians were harmed." ) 
		self.lblKills2:SetFont( "DescText" )
	
	self:CalculateScores()
	self:PerformLayout()
	
	self.ClickTime = CurTime() + 3
	self.DieTime = CurTime() + 19
	
end

function PANEL:SetTeam( t )

	if t == TEAM_GANG then
		self.lblTeam:SetText( "The Gangsters dominated the streets." )
	elseif t == TEAM_POLICE then
		self.lblTeam:SetText( "The Police busted all of the gangs." )
	end

end

function PANEL:CalculateScores()

	self.TotalBusts = 0
	self.TotalKills = team.TotalFrags( TEAM_POLICE )
	self.TotalCash = 0
	self.TotalCasualties = team.TotalFrags( TEAM_GANG )

	for k,v in pairs( player.GetAll() ) do
		if v:Team() == TEAM_POLICE then
			self.TotalBusts = self.TotalBusts + v:GetNWInt( "Busts", 0 )
		elseif v:Team() == TEAM_GANG then
			self.TotalCash = self.TotalCash + v:GetNWInt( "Cash", 0 )
		end
	end
	
	if self.TotalBusts > 0 then
		self.lblBusts:SetText( self.TotalBusts.." gang members were arrested." ) 
	end
	
	if self.TotalKills > 0 then
		self.lblKills:SetText( self.TotalKills.." gang members were killed." ) 
	end
	
	if self.TotalCash > 0 then
		self.lblCash:SetText( "$"..self.TotalCash.." was stolen from civilians." ) 
	end
	
	if self.TotalCasualties > 0 then
		self.lblKills2:SetText( self.TotalCasualties.." people were killed by gang members." ) 
	end

end

function PANEL:PerformLayout()

	self:SetSize( ScrW(), ScrH() )
	
	local ypos = ScrW() * 0.25
	
	self.lblReport:SizeToContents()
	self.lblReport:SetPos( ScrW() / 2 - self.lblReport:GetWide() / 2, ypos )
	
	self.TopY = ypos - 10
	self.LeftX = ScrW() / 2 - self.lblReport:GetWide() / 2 - 10
	self.Width = self.lblReport:GetWide() + 20
	self.Height = self.lblReport:GetTall() * 1.5 + 20
	
	ypos = ypos + self.lblReport:GetTall() * 1.5

	for k,v in pairs{ self.lblTeam, self.lblBusts, self.lblKills, self.lblCash, self.lblKills2 } do
	
		v:SizeToContents()
		v:SetPos( ScrW() / 2 - v:GetWide() / 2, ypos )
		v:SetColor( Color( 255, 255, 255, 255 ) )
		
		ypos = ypos + v:GetTall() + 5
		self.Height = self.Height + v:GetTall() + 5
	
	end
	
end

function PANEL:Think()

	if ( self.DieTime < CurTime() ) then
		
		LocalPlayer():EmitSound( Sound( "doors/metal_stop1.wav" ), 100, 60 )
		self:Remove()
		
	end
	
	local col = 155 + math.sin( RealTime() * 5 ) * 100
	
	self.lblTeam:SetColor( Color( col, 255, col ) )

end

function PANEL:Paint()

	// Derma_DrawBackgroundBlur( self )
	
	if ( !self.m_bPartOfBar ) then
		draw.RoundedBox( 4, self.LeftX, self.TopY, self.Width, self.Height, Color( 0, 0, 0, 100 ) )
	end

end

local vgui_EndGameSplash = vgui.RegisterTable( PANEL, "DButton" )

function GM:ShowEndGameStats( t )

	local pnl = vgui.CreateFromTable( vgui_EndGameSplash )
	pnl:SetTeam( t )
	pnl:MakePopup()

end

