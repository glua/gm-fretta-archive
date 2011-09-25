
local PANEL = { }

PANEL.WinLine = { }
PANEL.WinLine[ TEAM_BLUE ] = "Blue team wins!"
PANEL.WinLine[ TEAM_YELLOW ] = "Yellow team wins!"

PANEL.DieTime = 0
PANEL.DrawTime = 0
PANEL.ClickTime = 0
PANEL.NumRows = 0

PANEL.EndSound = Sound( "ambient/alarms/klaxon1.wav" )

function PANEL:Init()

	self:SetText( "" )
	self:SetSkin( GAMEMODE.HudSkin )
	self:ParentToHUD()
	
	self.DoClick = function() 
		if self.ClickTime > CurTime() then return end
		LocalPlayer():EmitSound( Sound( "buttons/button9.wav" ), 100, 100 ) 
		self:Remove() 
	end
	
	self.lblEndGame = vgui.Create( "DLabel", self )
		self.lblEndGame:SetText( "Game Over!" )
		self.lblEndGame:SetFont( "SplashHuge" )
		self.lblEndGame:SetColor( Color( 255, 255, 255, 255 ) )
		
	self.lblSub = vgui.Create( "DLabel", self )
		self.lblSub:SetText( "It's a draw!" ) 
		self.lblSub:SetFont( "SplashMed" )
		self.lblSub:SetColor( Color( 255, 255, 255, 255 ) )
		
	self.lblDeliver = vgui.Create( "DLabel", self )
		self.lblDeliver:SetText( "Props Stolen" ) 
		self.lblDeliver:SetFont( "SplashMed" )
		
	self.lblSteals = vgui.Create( "DLabel", self )
		self.lblSteals:SetText( "Props Delivered" ) 
		self.lblSteals:SetFont( "SplashMed" )
		
	self.lblKills = vgui.Create( "DLabel", self )
		self.lblKills:SetText( "Players Killed" ) 
		self.lblKills:SetFont( "SplashMed" )
		
	self.lblSurvive = vgui.Create( "DLabel", self )
		self.lblSurvive:SetText( "Lowest Deaths" ) 
		self.lblSurvive:SetFont( "SplashMed" )
	
	self:Sort()
	self:PerformLayout()
	
	self.ClickTime = CurTime() + 5
	self.DrawTime = CurTime() + 5
	self.DieTime = CurTime() + 30

end

function PANEL:Sort()

	self.Rows = 0
	
	self.TopDeliver = player.GetAll()
	self.TopStolen = player.GetAll()
	self.TopKiller = player.GetAll()
	self.LowDeaths = player.GetAll()
	
	--table.sort( self.Top5Alive, function(a, b) return a:Frags() > b:Frags() end )
	
	table.sort( self.TopDeliver, function(a, b) return a:GetNWInt( "P_Delivery" ) > b:GetNWInt( "P_Delivery" ) end )
	table.sort( self.TopStolen, function(a, b) return a:GetNWInt( "P_Steals" ) > b:GetNWInt( "P_Steals" ) end )
	table.sort( self.TopKiller, function(a, b) return a:Frags() > b:Frags() end )
	table.sort( self.LowDeaths, function(a, b) return a:Deaths() < b:Deaths() end )

end

function PANEL:SetWinner( t )

	self.Team = t
	self.SubTitle = self.WinLine[ t ]
	
	LocalPlayer():EmitSound( self.EndSound )

end

function PANEL:PerformLayout()

	self:SetSize( ScrW(), ScrH() )
	
	local CenterY = ScrH() / 2.0
	
	self.lblEndGame:SizeToContents()
	self.lblEndGame:SetPos( ScrW()/2 - self.lblEndGame:GetWide()/2, CenterY - 200 - self.lblEndGame:GetTall() - self.lblSub:GetTall() )
	
	self.lblSub:SetText( self.SubTitle or "It's a draw!" ) 
	self.lblSub:SizeToContents()
	self.lblSub:SetPos( ScrW()/2 - self.lblSub:GetWide()/2, CenterY - 200 - self.lblSub:GetTall() )
	
	if self.Team then
		self.lblSub:SetColor( team.GetColor( self.Team ) )
	end
	
	self.lblDeliver:SizeToContents()
	self.lblDeliver:SetPos( ScrW()/1.5 - self.lblDeliver:GetWide()/2, ScrH()/2.5 - self.lblDeliver:GetTall())
	self.lblDeliver:SetColor( Color( 255, 255, 255, 255 ) )
	self.lblDeliver:SetVisible( false )
	
	self.lblSteals:SizeToContents()
	self.lblSteals:SetPos( ScrW()/3 - self.lblSteals:GetWide()/2, ScrH()/2.5 - self.lblSteals:GetTall())
	self.lblSteals:SetColor( Color( 255, 255, 255, 255 ) )
	self.lblSteals:SetVisible( false )
	
	self.lblKills:SizeToContents()
	self.lblKills:SetPos( ScrW()/1.5 - self.lblKills:GetWide()/2, ScrH()/1.55 - self.lblKills:GetTall())
	self.lblKills:SetColor( Color( 255, 255, 255, 255 ) )
	self.lblKills:SetVisible( false )
	
	self.lblSurvive:SizeToContents()
	self.lblSurvive:SetPos( ScrW()/3 - self.lblSurvive:GetWide()/2, ScrH()/1.55 - self.lblSurvive:GetTall())
	self.lblSurvive:SetColor( Color( 255, 255, 255, 255 ) )
	self.lblSurvive:SetVisible( false )
	
end

function PANEL:Think()

	if ( self.DieTime < CurTime() ) then
		
		LocalPlayer():EmitSound( Sound( "buttons/button9.wav" ), 100, 100 )
		self:Remove()
		
	end

	if ( self.DrawTime < CurTime() and self.NumRows < 5 ) then
	
		self.lblDeliver:SetVisible( true )
		self.lblSteals:SetVisible( true )
		self.lblKills:SetVisible( true )
		--self.lblSurvive:SetVisible( true )
	
		self.NumRows = self.NumRows + 1
		if self.NumRows < 5 then
			self.DrawTime = CurTime() + 0.5
		else
			self.DrawTime = CurTime() + 1.0
		end
		
		local delivery = self.TopDeliver[ self.NumRows ]
		local theft = self.TopStolen[ self.NumRows ]
		local kills = self.TopKiller[ self.NumRows ]
		local deaths = self.LowDeaths[ self.NumRows ]
		
		if delivery and ValidEntity( delivery ) then
		
			local lbl = vgui.Create( "DLabel", self )
			lbl:SetText( delivery:GetNWInt( "P_Delivery", 0 ).." - "..delivery:Nick() ) 
			lbl:SetFont( "SplashMed" )
			lbl:SetColor( Color( 75 * self.NumRows, 250, 75 * self.NumRows, 255 ) )
			lbl:SizeToContents()
			lbl:SetPos( ScrW()/3 - lbl:GetWide()/2, ScrH()/2.5 - 20 + self.NumRows * lbl:GetTall() * 1.2 )
			
			LocalPlayer():EmitSound( Sound( "buttons/blip1.wav" ), 100, 100 )
		
		end
		
		if theft and ValidEntity( theft ) then
		
			local lbl = vgui.Create( "DLabel", self )
			lbl:SetText( theft:GetNWInt( "P_Steals", 0 ).." - "..theft:Nick() ) 
			lbl:SetFont( "SplashMed" )
			lbl:SetColor( Color( 75 * self.NumRows, 250, 75 * self.NumRows, 255 ) )
			lbl:SizeToContents()
			lbl:SetPos( ScrW()/1.5 - lbl:GetWide()/2, ScrH()/2.5 - 20 + self.NumRows * lbl:GetTall() * 1.2 )
			
			LocalPlayer():EmitSound( Sound( "buttons/blip1.wav" ), 100, 100 )
		
		end
		
		if kills and ValidEntity( kills ) then
		
			local lbl = vgui.Create( "DLabel", self )
			lbl:SetText( kills:Frags().." - "..kills:Nick() ) 
			lbl:SetFont( "SplashMed" )
			lbl:SetColor( Color( 75 * self.NumRows, 250, 75 * self.NumRows, 255 ) )
			lbl:SizeToContents()
			lbl:SetPos( ScrW()/1.5 - lbl:GetWide()/2, ScrH()/1.55 - 20 + self.NumRows * lbl:GetTall() * 1.2 )
			
			LocalPlayer():EmitSound( Sound( "buttons/blip1.wav" ), 100, 100 )
		
		end
		
		if deaths and ValidEntity( deaths ) then
		
			local lbl = vgui.Create( "DLabel", self )
			lbl:SetText( deaths:Deaths().." - "..deaths:Nick() ) 
			lbl:SetFont( "SplashMed" )
			lbl:SetColor( Color( 75 * self.NumRows, 250, 75 * self.NumRows, 255 ) )
			lbl:SizeToContents()
			lbl:SetPos( ScrW()/1.5 - lbl:GetWide()/2, ScrH()/1.55 - 20 + self.NumRows * lbl:GetTall() * 1.2 )
			
			LocalPlayer():EmitSound( Sound( "buttons/blip1.wav" ), 100, 100 )
		
		end
		
	end
end

function PANEL:Paint()

	Derma_DrawBackgroundBlur( self )

end

local vgui_EndGameSplash = vgui.RegisterTable( PANEL, "DButton" )

function GM:ShowEndGameSplash( t )

	local pnl = vgui.CreateFromTable( vgui_EndGameSplash )
	pnl:SetWinner( t )
	pnl:MakePopup()

end


