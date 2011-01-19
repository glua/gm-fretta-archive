////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Wait Screen                                //
////////////////////////////////////////////////

PANEL.Base = "DPanel"
/*
PANEL.HTMLCONTENTS = ""

local HTMLPANEL = nil

local function GetUpdateInfo( contents , size )
	if HTMLPANEL then HTMLPANEL:SetHTML( contents ) end
end
*/
/*---------------------------------------------------------
   Name: gamemode:Init
---------------------------------------------------------*/
function PANEL:Init()

	local h = ScrH() * 0.3
	--It was 0.2 before
	
	self:SetPaintBackground( false )

	--self.Info = vgui.Create( "HTML" , DPanel)
	--self.Info:OpenURL("http://www.assembla.com/spaces/garryware/documents/cIq5KWlY0r3OXWeJe5afGb/download/garryware.html")
	--HTMLPANEL = self.Info
	
	--self.Info:SetSize( 400, 250 )
	--self.Info:SetPos(ScrW() - 420 , 92)
	
	self.BottomPanel = VGUIRect( 0, ScrH(), ScrW(), h )
	self.BottomPanel:SetColor( color_black )
	self.BottomPanel:SetParent( self )
	
	self.SubtitleObj = vgui.Create( "DLabel", self.BottomPanel )
	self.SubtitleObj:SetFont( "WAREIns" )
	self.SubtitleObj:SetColor( color_white )
	
	self:SetVisible( false )

	--http.Get( "http://www.assembla.com/spaces/garryware/documents/cIq5KWlY0r3OXWeJe5afGb/download/garryware.html", "", GetUpdateInfo )
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( ScrW(), ScrH() )
	self:SetPos( 0, 0 )
	
	self.SubtitleObj:SizeToContents()
	self.SubtitleObj:Center()
	self.SubtitleObj:AlignTop( 6 )
	
end

function PANEL:Show()	
	self.BottomPanel:SetPos( 0, ScrH() )
	self.BottomPanel:MoveTo( 0, ScrH() - 52, 0.3, 0, 2)
	
	self:InvalidateLayout()
	self:SetVisible( true )
	
end

function PANEL:SetSubtitle( sText )
	self.SubtitleObj:SetText( sText )
	self:InvalidateLayout()
	
end

function PANEL:Think()
	if (self:IsVisible() == false) then return end

	local timeleft = math.floor((gws_NextgameStart or 0) - CurTime())
	if (timeleft > 0) then 
		local text = ""
		if (timeleft > 1) then text = "s" end
		self.SubtitleObj:SetText( "Game begins in "..timeleft.." second"..text.."!")
	else
		self.SubtitleObj:SetText( "Game begins!")
	end
	
	self:InvalidateLayout()
end

function PANEL:Hide()
	local h = ScrH() * 0.07

	self.BottomPanel:MoveTo( 0, ScrH(), 0.3, 0, 2)
	
	timer.Simple( 1, function() self:SetVisible( false ) end )
end

