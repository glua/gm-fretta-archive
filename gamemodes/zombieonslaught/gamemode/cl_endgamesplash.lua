
local PANEL = {}

PANEL.SubTitles = {}
PANEL.WinVoice = {}

PANEL.SubTitles[ TEAM_ALIVE ] = {"Eat lead, brainmunchers",
"The humans have survived the onslaught... For now...",
"Looks like having a brain paid off for once",
"YOU ARE HUGE!!! THAT MEANS YOU HAVE HUGE GUTS!!!",
"That was easier than target practice",
"Survival of the fittest",
"If it bleeds, we can kill it",
"You call that a zombie apocalypse?",
"Zombies are nothing but dead weight"}

PANEL.SubTitles[ TEAM_DEAD ] = {"Eat shit, brainhavers",
"Humanity is no more...",
"The survivors have failed",
"Does this look infected to you?",
"Your bullets don't seem to be working very well",
"Does it hurt when I do this?",
"I told you that your guns were too small...",
"Thank you for donating your vital organs to our cause",
"U DEAD? THOUGHT SO..."}

PANEL.WinVoice[ TEAM_ALIVE ] = Sound("vo/coast/odessa/male01/nlo_cheer02.wav")
PANEL.WinVoice[ TEAM_DEAD ] = Sound("vo/npc/male01/no01.wav")

/*---------------------------------------------------------
   Init
---------------------------------------------------------*/
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
		self.lblReport:SetText( "* CARNAGE REPORT *" )
		self.lblReport:SetFont( "SplashHuge" )
		self.lblReport:SetColor( Color( 255, 50, 50, 255 ) )
		
	self.lblSub = vgui.Create( "DLabel", self )
		self.lblSub:SetText( "Game over" ) 
		self.lblSub:SetFont( "SplashMed" )
		self.lblSub:SetColor( color_white )
		
	self.lblHuman = vgui.Create( "DLabel", self )
		self.lblHuman:SetText( "ZOMBIES SLAIN" ) 
		self.lblHuman:SetFont( "SplashMed" )
		
	self.lblDead = vgui.Create( "DLabel", self )
		self.lblDead:SetText( "PAIN INFLICTED" ) 
		self.lblDead:SetFont( "SplashMed" )
	
	self:SortPlayers()
	self:PerformLayout()
	
	self.ClickTime = CurTime() + 5
	self.DrawTime = CurTime() + 5
	self.DieTime = CurTime() + 30
	
end

function PANEL:SortPlayers()

	self.NumRows = 0

	self.Top5Alive = player.GetAll()
	self.Top5Dead = player.GetAll()
	self.HeadshotKing = player.GetAll()
	self.SupportKing = player.GetAll()
	self.PainKing = player.GetAll()
	
	table.sort( self.Top5Alive, function(a, b) return a:Frags() > b:Frags() end )
	table.sort( self.Top5Dead, function(a, b) return a:GetNWInt( "Brains", 0 ) > b:GetNWInt( "Brains", 0 ) end )	
	table.sort( self.HeadshotKing, function(a, b) return a:GetNWInt( "Headshots", 0 ) > b:GetNWInt( "Headshots", 0 ) end )
	table.sort( self.SupportKing, function(a, b) return a:GetNWInt( "Support", 0 ) > b:GetNWInt( "Support", 0 ) end )
	table.sort( self.PainKing, function(a, b) return a:GetNWInt( "DamageTaken", 0 ) > b:GetNWInt( "DamageTaken", 0 ) end )
	
	for k,v in pairs( player.GetAll() ) do
		if v:GetNWBool( "FirstZombie", false ) then
			self.ZombieKing = v
		end
	end

end

function PANEL:SetTeam( t )

	self.Team = t
	self.SubTitle = table.Random( self.SubTitles[ t ] )
	
	LocalPlayer():EmitSound( self.WinVoice[ t ] )

end

/*---------------------------------------------------------
   PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( ScrW(), ScrH() )
	
	local CenterY = ScrH() / 2.0
	
	self.lblReport:SizeToContents()
	self.lblReport:SetPos( ScrW()/2 - self.lblReport:GetWide()/2, CenterY - 200 - self.lblReport:GetTall() - self.lblSub:GetTall() )
	
	self.lblSub:SetText( self.SubTitle or "Game over" ) 
	self.lblSub:SizeToContents()
	self.lblSub:SetPos( ScrW()/2 - self.lblSub:GetWide()/2, CenterY - 200 - self.lblSub:GetTall() )
	
	self.lblHuman:SizeToContents()
	self.lblHuman:SetPos( ScrW()/1.5 - self.lblHuman:GetWide()/2, ScrH()/2.5 - self.lblHuman:GetTall())
	self.lblHuman:SetColor( color_white )
	self.lblHuman:SetVisible( false )
	
	self.lblDead:SizeToContents()
	self.lblDead:SetPos( ScrW()/3 - self.lblDead:GetWide()/2, ScrH()/2.5 - self.lblDead:GetTall())
	self.lblDead:SetColor( color_white )
	self.lblDead:SetVisible( false )
	
end

/*---------------------------------------------------------
   Think 
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.DieTime < CurTime() ) then
		
		LocalPlayer():EmitSound( Sound( "doors/metal_stop1.wav" ), 100, 60 )
		self:Remove()
		
	end

	if ( self.DrawTime < CurTime() and self.NumRows < 5 ) then
	
		self.lblDead:SetVisible( true )
		self.lblHuman:SetVisible( true )
	
		self.NumRows = self.NumRows + 1
		if self.NumRows < 5 then
			self.DrawTime = CurTime() + 0.5
		else
			self.DrawTime = CurTime() + 1.0
		end
		
		local deadply = self.Top5Dead[ self.NumRows ]
		local aliveply = self.Top5Alive[ self.NumRows ]
		
		if deadply and ValidEntity( deadply ) then
		
			local lbl = vgui.Create( "DLabel", self )
			lbl:SetText( deadply:GetNWInt( "Brains", 0 ).." - "..deadply:Nick() ) 
			lbl:SetFont( "SplashMed" )
			lbl:SetColor( Color( 250, 50 * self.NumRows, 50 * self.NumRows, 255 ) )
			lbl:SizeToContents()
			lbl:SetPos( ScrW()/3 - lbl:GetWide()/2, ScrH()/2.5 - 20 + self.NumRows * lbl:GetTall() * 1.2 )
			
			LocalPlayer():EmitSound( Sound( "doors/metal_stop1.wav" ), 100, 60 )
		
		end
		
		if aliveply and ValidEntity( aliveply ) then
		
			local lbl = vgui.Create( "DLabel", self )
			lbl:SetText( aliveply:Frags().." - "..aliveply:Nick() ) 
			lbl:SetFont( "SplashMed" )
			lbl:SetColor( Color( 50 * self.NumRows, 250, 50 * self.NumRows, 255 ) )
			lbl:SizeToContents()
			lbl:SetPos( ScrW()/1.5 - lbl:GetWide()/2, ScrH()/2.5 - 20 + self.NumRows * lbl:GetTall() * 1.2 )
			
			LocalPlayer():EmitSound( Sound( "doors/metal_stop1.wav" ), 100, 60 )
		
		end
		
	elseif ( self.DrawTime < CurTime() ) then
	
		self.DrawTime = CurTime() + 1.0
	
		if not self.lblLeader then
			
			LocalPlayer():EmitSound( Sound( "player/headshot1.wav" ), 100, 80 )
			
			self.lblLeader = vgui.Create( "DLabel", self )
			self.lblLeader:SetText( self.HeadshotKing[1]:Nick().." aims for the head" ) 
			self.lblLeader:SetFont( "SplashMed" )
			self.lblLeader:SetColor( color_white )
			self.lblLeader:SizeToContents()
			self.lblLeader:SetPos( ScrW()/2 - self.lblLeader:GetWide()/2, ScrH()/1.5 + self.lblLeader:GetTall() )
			
			return
		
		elseif not self.lblSupport then
			
			LocalPlayer():EmitSound( Sound("items/medshot4.wav") )
			
			self.lblSupport = vgui.Create( "DLabel", self )
			self.lblSupport:SetText( self.SupportKing[1]:Nick().." is a team player" ) 
			self.lblSupport:SetFont( "SplashMed" )
			self.lblSupport:SetColor( color_white )
			self.lblSupport:SizeToContents()
			self.lblSupport:SetPos( ScrW()/2 - self.lblSupport:GetWide()/2, ScrH()/1.5 + 2.5 * self.lblSupport:GetTall() )
			
			return
		
		elseif not self.lblPain then
			
			LocalPlayer():EmitSound( Sound("npc/zombie/claw_strike1.wav") )
			
			self.lblPain = vgui.Create( "DLabel", self )
			self.lblPain:SetText( self.PainKing[1]:Nick().." isn't afraid of death" ) 
			self.lblPain:SetFont( "SplashMed" )
			self.lblPain:SetColor( color_white )
			self.lblPain:SizeToContents()
			self.lblPain:SetPos( ScrW()/2 - self.lblPain:GetWide()/2, ScrH()/1.5 + 4 * self.lblPain:GetTall() )
			
			return
			
		elseif not self.lblLord and ValidEntity( self.ZombieKing ) then
			
			LocalPlayer():EmitSound( Sound("npc/zombie/zombie_voice_idle1.wav") )
			
			self.lblLord = vgui.Create( "DLabel", self )
			
			if self.Team == TEAM_DEAD then
				self.lblLord:SetText( self.ZombieKing:Nick().." succeeded as the zombie overlord" ) 
			else
				self.lblLord:SetText( self.ZombieKing:Nick().." failed as the zombie overlord" ) 
			end
			
			self.lblLord:SetFont( "SplashMed" )
			self.lblLord:SetColor( color_white )
			self.lblLord:SizeToContents()
			self.lblLord:SetPos( ScrW()/2 - self.lblLord:GetWide()/2, ScrH()/1.5 + 5.5 * self.lblLord:GetTall() )
			
			return
			
		end
	end
end

/*---------------------------------------------------------
   Paint
---------------------------------------------------------*/
function PANEL:Paint()

	Derma_DrawBackgroundBlur( self )

end

local vgui_EndGameSplash = vgui.RegisterTable( PANEL, "DButton" )

function GM:ShowEndGameSplash( t )

	if GAMEMODE.SplashShown then return end
	
	GAMEMODE.SplashShown = true

	local pnl = vgui.CreateFromTable( vgui_EndGameSplash )
	pnl:SetTeam( t )
	pnl:MakePopup()

end

