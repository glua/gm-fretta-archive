include( 'shared.lua' )
include( 'admin.lua' ) 

surface.CreateFont( "Tahoma", 14, 500, true, false, "HudText" )


w = ScrW()
h = ScrH()

function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:DrawDeathNotice( 0.85, 0.04 )
	
	//draw scores
	local redscore, bluescore = team.GetScore(TEAM_RED), team.GetScore(TEAM_BLUE)
	local maxscore = GetConVar("ud_maxscore"):GetInt()
	
	draw.RoundedBox( 6, w*.02, h*.02, w*.14, h*.07, Color(30,30,30,200) ) //dark background
	draw.RoundedBox( 6, w*.03, h*.03, w*.12, h*.02, Color(250,250,250,200) ) //background for red score
	draw.RoundedBox( 6, w*.03, h*.06, w*.12, h*.02, Color(250,250,250,200) ) //background for blue score
	
	local rwidth = math.Clamp(((w*.12)/maxscore)*math.Clamp(redscore,0,maxscore), w*.01, w*.12 )
	local bwidth = math.Clamp(((w*.12)/maxscore)*math.Clamp(bluescore,0,maxscore), w*.01, w*.12 )
	
	//colored bars
	local rcolor = Color(250,80,80,250)
	local bcolor = Color(80,80,250,250)
	if rwidth == w*.12 then
		local fade = TimedSin(0.5,80,255,0)
		rcolor = Color(250,fade,fade,250)
	elseif bwidth == w*.12 then
		local fade = TimedSin(0.5,80,255,0)
		bcolor = Color(fade,fade,250,250)
	end
	draw.RoundedBox( 6, w*.03, h*.03, rwidth, h*.02, rcolor ) 
	draw.RoundedBox( 6, w*.03, h*.06, bwidth, h*.02, bcolor ) 
	
	//draw score text
	draw.DrawText("Red Score: "..redscore, "HudText", w*.092, h*.031, Color(30,30,30,220),TEXT_ALIGN_CENTER)
	draw.DrawText("Blue Score: "..bluescore, "HudText", w*.092, h*.061, Color(30,30,30,220),TEXT_ALIGN_CENTER)
	
end