include( 'shared.lua' )


function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

w = ScrW()
h = ScrH()


function GM:HUDPaint() 

	self.BaseClass:HUDPaint()
	
	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:DrawDeathNotice( 0.85, 0.04 )
	
	local redscore, bluescore = team.GetScore(TEAM_RED), team.GetScore(TEAM_BLUE)
	local maxscore = 10
	
	draw.RoundedBox( 6, w*.02, h*.02, w*.14, h*.07, Color(30,30,30,200) ) //dark background
	draw.RoundedBox( 6, w*.03, h*.03, w*.12, h*.02, Color(250,250,250,200) ) //background for red score
	draw.RoundedBox( 6, w*.03, h*.06, w*.12, h*.02, Color(250,250,250,200) ) //background for blue score
		
	draw.DrawText("Red Score: "..redscore, "ScoreboardText", w*.092, h*.030, Color(250,80,80,250),TEXT_ALIGN_CENTER)
	draw.DrawText("Blue Score: "..bluescore, "ScoreboardText", w*.092, h*.060, Color(80,80,250,250),TEXT_ALIGN_CENTER)
	
end