local PANEL = {}

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"ScoreHeader" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"ScoreHeader" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"ScoreHeader" )


function PANEL:Init()

	self.Columns = {}
	self.iTeamID = 0
	
	self.GamemodeName = vgui.Create( "DImage", self )  
	self.GamemodeName:SetImage( "gtv/gtvsplash" )
	self.GamemodeName:SetSize( 128, 128 )  
	self.GamemodeName:SetPos(150, 150)
	self:SetHeight(76)

end

derma.DefineControl( "ScoreboardHeader", "", PANEL, "Panel" )
