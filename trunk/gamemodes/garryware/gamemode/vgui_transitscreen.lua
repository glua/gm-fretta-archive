////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Transition VGUI                            //
////////////////////////////////////////////////

PANEL.Base = "DPanel"

/*---------------------------------------------------------
   Name: gamemode:Init
---------------------------------------------------------*/
function PANEL:Init()
	self.colors = {}
	self.colors.Win   = Color(   0, 164, 237 )
	self.colors.Fail  = Color( 255,  87,  87 )
	self.colors.Black = Color(   0,   0,   0,  87 )
	
	self.DYN_color = Color( 0, 0, 0 )
	
	self:SetSize( ScrW(), 28 )
	self:SetPaintBackground( false )
	
	self.SubtitleObj = vgui.Create( "DLabel", self )
	self.SubtitleObj:SetFont( "garryware_mediumtext" )
	self.SubtitleObj:SetColor( color_white )
	self.SubtitleObj:SetText("")
	
	self:SetVisible( false )
end


function PANEL:PerformLayout()
	self.SubtitleObj:SizeToContents()
	self.SubtitleObj:Center()
	self.SubtitleObj:AlignBottom( 1 )
	
end


function PANEL:SetSubtitle( sText )
	self.SubtitleObj:SetText( sText )
	self:InvalidateLayout()
	
end

function PANEL:SetBlend( fBlend )
	GC_ColorBlend( self.DYN_color, self.colors.Fail, self.colors.Win, fBlend )
	
end


function PANEL:Show()
	self:SetPos( 0, ScrH() )
	self:MoveTo( 0, ScrH() - self:GetTall(), 0.3, 0, 2)
	
	self:InvalidateLayout()
	self:SetVisible( true )

end

function PANEL:Hide()
	self:MoveTo( 0, ScrH(), 0.3, 0, 2)
	
	timer.Simple( 1, function() self:SetVisible( false ) end )
end

function PANEL:Paint()
	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall()    , self.colors.Black )
	draw.RoundedBox( 0, 0, 4, self:GetWide(), self:GetTall() - 4, self.DYN_color )
end
