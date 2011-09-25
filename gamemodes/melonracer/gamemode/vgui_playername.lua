
PANEL.Base = "DPanel"

AccessorFunc( PANEL, "m_pMelon", "Melon" )
AccessorFunc( PANEL, "m_pPlayer", "Player" )

function IsPlayerTooltipVisible( Player, Melon )

	local MelonPos = Melon:GetPos() 

	local trace = {
				start = LocalPlayer():EyePos(),
				endpos = MelonPos
			  }
			  
	local tr = util.TraceLine( trace )

	if ( !tr.Hit || tr.Entity != Melon ) then
		return false
	end
	
	if ( (MelonPos - LocalPlayer():EyePos()):Length() > 512 ) then
		return false
	end
	
	local pos = MelonPos:ToScreen()
	return pos.visible

end

/*---------------------------------------------------------
   Name: gamemode:HUDThink
---------------------------------------------------------*/
function PANEL:Init()

	self:SetSize( 100, 32 )
	
	self.Label 		= vgui.Create( "DLabel", self )
	self.Avatar 	= vgui.Create( "AvatarImage", self )

end

/*---------------------------------------------------------
   Name: gamemode:HUDThink
---------------------------------------------------------*/
function PANEL:Think()

	if (!IsValid(self.m_pMelon)||!IsValid(self.m_pPlayer)) then 
		self:Remove()
		return
	end

	local Up = LocalPlayer():EyeAngles():Up()
	local LabelPos = (self.m_pMelon:GetPos() + Up*12)
		
	if ( !IsPlayerTooltipVisible( self.m_pPlayer, self.m_pMelon ) ) then
		self:Remove()
		return
	end
	
	local pos = LabelPos:ToScreen()	
	pos.x = pos.x - self:GetWide()*0.5
	
	local x, y = self:GetPos()
	
	self:SetPos( Lerp( FrameTime()*20, x, pos.x), Lerp( FrameTime()*20, y, pos.y ) )

end


/*---------------------------------------------------------
   Name: gamemode:HUDThink
---------------------------------------------------------*/
function PANEL:PerformLayout()

	if (!IsValid(self.m_pMelon)||!IsValid(self.m_pPlayer)) then 
		self:Remove()
		return
	end
	
	self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Label:SetText( self.m_pPlayer:Nick() )
	self.Avatar:SetPlayer( self.m_pPlayer )
	
	self.Label:SizeToContents()
	self.Label:SetTall( 16 )
	self.Label:SetPos( 20, 0 )
	
	self.Avatar:SetSize( 16, 16 )
	self.Avatar:SetPos( 0, 0 )
	
	self:SetSize( self.Label:GetWide() + self.Avatar:GetWide() + 8, self.Label:GetTall() )

end

/*---------------------------------------------------------
   Paint
---------------------------------------------------------*/
function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color(20, 20, 20, 150) )

end