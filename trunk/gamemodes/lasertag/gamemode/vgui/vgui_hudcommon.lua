local PANEL = {}
AccessorFunc( PANEL, "m_Items", 	"Items" )
AccessorFunc( PANEL, "m_Horizontal", 	"Horizontal" )
AccessorFunc( PANEL, "m_Spacing", 		"Spacing" )

AccessorFunc( PANEL, "m_AlignBottom", 	"AlignBottom" )
AccessorFunc( PANEL, "m_AlignCenter", 	"AlignCenter" )

////////////////////////////////////////////////////////////////////////////////////////////////////
local hud = {}
hud.ShieldIndicator		= surface.GetTextureID("LaserTag/HUD/hud_shieldindicator")
hud.UpgradeIndicator	= surface.GetTextureID("LaserTag/HUD/hud_upindicator")

// Indicator
hud.IndicLeft			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_left")
hud.IndicRight			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_right")
hud.IndicCenter			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_center")
hud.IndicPad			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_pad")

// Team icons
hud.TeamIcon = {
	[TEAM_RED] = surface.GetTextureID("LaserTag/HUD/hud_rapture"),
	[TEAM_BLUE] = surface.GetTextureID("LaserTag/HUD/hud_siren"),
	[TEAM_GREEN] = surface.GetTextureID("LaserTag/HUD/hud_cobra"),
	[TEAM_YELLOW] = surface.GetTextureID("LaserTag/HUD/hud_fury")
}

// Other
hud.PwupBase			= surface.GetTextureID("LaserTag/HUD/powerup_base")
hud.BaseOpacity			= 150
hud.EdgeDistance		= 0.02
////////////////////////////////////////////////////////////////////////////////////////////////////

function PANEL:Init()
	self.m_Items = {}
	self:SetHorizontal( true )
	self:SetAlignCenter( true )
	self:SetSpacing(ScrH()*0.02)
	self:SetSize(ScrW() * 0.6,ScrH() * 0.09)
end

function PANEL:AddItem(item,pos)
	item:SetParent(self)
	table.insert(self.m_Items,pos,item)
	self:InvalidateLayout()
	item:SetPaintBackgroundEnabled( false )
	item.m_bPartOfBar = true
end

function PANEL:PerformLayout()
	/*
	if ( self.m_Horizontal ) then
		local x = self.m_Spacing
		local tallest = 0
		for k, v in pairs( self.m_Items ) do
		
			v:SetPos( x, 0 )
			x = x + v:GetWide() + self.m_Spacing
			tallest = math.max( tallest, v:GetTall() )
			
			if ( self.m_AlignBottom ) then v:AlignBottom() end
			if ( self.m_AlignCenter ) then v:CenterVertical() end
		
		end
		self:SetSize( x, tallest )
	else
		// todo.
	end
	*/
	
	for k,v in pairs(self.m_Items) do
		if k == 1 then
			// Left side.
			v:SetPos(self:GetWide()/5 - v:GetWide()/2,self:GetTall()/2 - v:GetTall()/2)
		elseif k == 2 then
			// Center
			v:SetPos(self:GetWide()/2 - v:GetWide()/2,self:GetTall() - v:GetTall() - self:GetSpacing())
		elseif k == 3 then
			v:SetPos(4*self:GetWide()/5 - v:GetWide()/2,self:GetTall()/2 - v:GetTall()/2)
		end
	end
end

function PANEL:Paint()
	// Vars
	local pteam = LocalPlayer():Team()
	local col 	= team.GetColor(pteam)
	
	// Co-ords
	local w,h = self:GetWide(),self:GetTall() 
	local x,y = 0,0
	local sidew = h
	
	// Setup draw color:
	surface.SetDrawColor(col.r,col.g,col.b,255)
	
	// Left edge
	surface.SetTexture(hud.IndicLeft)
	surface.DrawTexturedRect(0,0,sidew,h)
	
	// Right edge
	surface.SetTexture(hud.IndicRight)
	surface.DrawTexturedRect(w - sidew,0,sidew,h)
	
	// Center
	surface.SetTexture(hud.IndicCenter)
	surface.DrawTexturedRect(w/2 - h*2,0,h*4,h)
	
	// Padding
	surface.SetTexture(hud.IndicPad)
	surface.DrawTexturedRect(sidew,0,w/2 - h*2 - sidew,h) // Left Pad
	surface.DrawTexturedRect(w/2 + h*2,0,w/2 - h*2 - sidew,h) // Right Pad
	
	
	// Team name.
	surface.SetFont("DodgerMed")
	surface.SetTextColor(col.r,col.g,col.b,220)
	
	local tw,th = surface.GetTextSize(team.GetName(pteam))
	surface.SetTextPos(x + w/2 - tw/2,y)
	surface.DrawText(string.upper(team.GetName(pteam)))
end

derma.DefineControl( "DHudBar", "", PANEL, "DPanel" )

local PANEL = {}
AccessorFunc( PANEL, "m_ValueFunction", 	"ValueFunction" )
AccessorFunc( PANEL, "m_ColorFunction", 	"ColorFunction" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
	
end

function PANEL:GetTextValueFromFunction()
	if (!self.m_ValueFunction) then return "-" end
	return tostring( self:m_ValueFunction() )
end

function PANEL:GetColorFromFunction()
	if (!self.m_ColorFunction) then return self:GetDefaultTextColor() end
	return self:m_ColorFunction()
end

function PANEL:Think()
	self:SetTextColor( self:GetColorFromFunction() )
	self:SetText( self:GetTextValueFromFunction() )
end

derma.DefineControl( "DHudUpdater", "A HUD Element", PANEL, "DHudElement" )


local PANEL = {}
AccessorFunc( PANEL, "m_Function", 	"Function" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
	HudBase.Init( self )
end

function PANEL:Think()

	if ( !self.m_ValueFunction ) then return end
	
	self:SetTextColor( self:GetColorFromFunction() )
	
	local EndTime = self:m_ValueFunction()
	if ( EndTime == -1 ) then return end
	
	if ( !EndTime || EndTime < CurTime() ) then 
		self:SetText( "00:00" )
		return
	end
	
	local Time = string.ToMinutesSeconds( EndTime - CurTime() )
	self:SetText( Time )

end

derma.DefineControl( "DHudCountdown", "A HUD Element", PANEL, "DHudUpdater" )