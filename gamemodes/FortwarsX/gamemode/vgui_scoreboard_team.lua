local PANEL = {}

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"TeamScoreboardHeader" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"TeamScoreboardHeader" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"TeamScoreboardHeader" )
	
function PANEL:Init()

	self.Columns = {}
	self.iTeamID = 0
	self.PlayerCount = 0
	
	self.TeamName = vgui.Create( "DLabel", self )
	self.TeamScore = vgui.Create( "DLabel", self )

end

function PANEL:Setup( iTeam, pMainScoreboard )

	self.TeamName:SetText( team.GetName( iTeam ) )
	self.iTeamID = iTeam

end

function PANEL:Think()

	local Count = #team.GetPlayers( self.iTeamID )
	if ( self.PlayerCount != Count ) then
		self.PlayerCount = Count
		self.TeamName:SetText( team.GetName( self.iTeamID ) .. " (" .. self.PlayerCount .. " Players)" )
	end
	
	self.TeamScore:SetText( string.ToMinutesSeconds( team.GetScore( self.iTeamID ) ) )
	// ^ changes seconds to a format like 10:05
	
end

derma.DefineControl( "TeamScoreboardHeader", "", PANEL, "Panel" )