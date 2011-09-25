
//Set up icon values
local cactusIconFile = "gui/cactus"
local cactusIconID   = surface.GetTextureID( cactusIconFile )

local cwide,ctall = surface.GetTextureSize(cactusIconID)
cwide,ctall = cwide/3,ctall/3
local cactusStartPos = {
	x = ScrW()-cwide-10,
	y = ScrH()-ctall-10
}
local cactusStartSize = {
	w = cwide,
	h = ctall
}

local cactusWiggle, cactusCaught, cactusAmplitude, cactusCType
	
	usermessage.Hook("cactusIcon_WIGGLE",
		function(um)
			cactusWiggle = um:ReadBool()
			if !cactusWiggle then return end
			cactusAmplitude = um:ReadFloat()
			if LocalPlayer().Icon then
				
				LocalPlayer().Icon:SetVisible(true)
				LocalPlayer().Icon:SetAmplitude(cactusAmplitude)
				LocalPlayer().Icon:SetWiggle(cactusWiggle)
				
			end
		end
	)
	usermessage.Hook("cactusIcon_CAUGHT",
		function(um)
			cactusCaught = um:ReadBool()
			cactusWiggle = cactusCaught
			
			if LocalPlayer().Icon then
				LocalPlayer().Icon:SetWiggle(cactusWiggle)
			end
			if !cactusCaught then return end
			
			cactusAmplitude = um:ReadFloat()
			cactusCType = string.lower(um:ReadString())
			if LocalPlayer().Icon then
				
				LocalPlayer().Icon:SetAmplitude(cactusAmplitude)
				LocalPlayer().Icon:SetWiggle(cactusWiggle)
				LocalPlayer().Icon:SetCaught(cactusCaught,cactusCType)
				
			end
		end
	)
	
usermessage.Hook("cactusHint",
	function(um)
		
		hintActive = um:ReadBool()
		
		if !LocalPlayer():Alive() then return end
		
		local lines = um:ReadFloat()
		local str = um:ReadString()
		local typ = um:ReadString()
		
		GAMEMODE:AddCactusNotify(str,typ,lines*3)
		
	end
)

local cactusWiggle = false
local cactusAmplitude = nil
local cactusOffset = 0
local cactusFrequency = 5
local cactusAng = 5

local cactusCaught = false
local cactusType = nil
local cactusCColor = {}
local cactusColor = color_white
local r,g,b,a = color_white
local newcolor = {}

--Hint box start pos and size
local hwide_b, htall_b = 20, 20 --surface.GetTextureSize(hintBackgroundID)
local hintStartPos = {
	x = cactusStartPos.x+20,
	y = cactusStartPos.y-20
}
local hintStartSize = {
	w = hwide_b,
	h = htall_b
}

--Hint stub start pos and size
local hintSStartPos = {
	x = hintStartPos.x+(hwide_b/5),
	y = hintStartPos.y+htall_b
}
//orange is Color( 255, 200, 50 )
local hintGradient = {
	c1 = {r=255, g=200, b=0}, 	--orange
	c2 = {r=255, g=230, b=100},	--light yellow orange
	c3 = {r=255, g=240, b=175}, --yellow 
	c4 = {r=255, g=250, b=220}	--light yellow
}

local hintActive = false
local hintMessage = ""
local msg = ""
local maxlength = 65

surface.CreateFont ("coolvetica", ScreenScale(13), 400, true, false, "HintText") --scaled
surface.CreateFont ("coolvetica", ScreenScale(15), 400, true, false, "ScreenText") --scaled

local x,y,w,h
local alpha = 255

function GM:HUDShouldDraw(name)
	for k, v in pairs{"CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
	return true
end


local function DrawCactusScreen()

	local client = LocalPlayer()
	if !client:Alive() then return end
	
end
local function DrawHumanHealth()

	local client = LocalPlayer()
	if !client:Alive() or client:Team() == TEAM_SPECTATOR then return end
	
	local HealthTable = {}
	HealthTable["full"] = 100
	HealthTable["half"] = 50
	HealthTable["low"] = 1
	local tex = surface.GetTextureID( "gui/gradient" )
	
	local QuadTable = {}
	
 	QuadTable.texture 	= tex
 	QuadTable.color		= Color( math.Clamp(client:Health(),10,255), math.Clamp(client:Health(),10,255), 10, 200 ) --set color depending on health. as damage gets higher, make it more red, make it less green, and maybe change alpha?

	
	local texSizeW, texSizeH = surface.GetTextureSize(tex)
	local newW, newH = client:Health()*6, (client:Health()/1.01) 
	local posX, posY = ScrW()/2-(texSizeW/2), ScrH()-(texSizeH)
	
 	QuadTable.x = posX
 	QuadTable.y = posY
 	QuadTable.w = newW
 	QuadTable.h = newH
 	draw.TexturedQuad( QuadTable )
	
end

function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	local client = LocalPlayer()
	
	GAMEMODE:PaintHints()
	
	if !client.Icon then
		client.Icon = vgui.Create( "DHudCactusIcon" )
		print("Creating cactus icon for client "..tostring(client))
	end
	
	if !client:Alive() then return end
	local posX, posY = 20, 20
	if client:IsCactus() then
		DrawCactusScreen() --unused...
		draw.SimpleTextOutlined( "Press Primary Fire to attack.", "ScreenText", posX, posY, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(255,255,255,255) )
		draw.SimpleTextOutlined( "Press Ctrl to change views.", "ScreenText", posX, posY+25, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(255,255,255,255) )
		draw.SimpleTextOutlined( "Kill the humans and don't get caught!", "ScreenText", posX, posY+50, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(255,255,255,255) )
	elseif client:IsHuman() then
		draw.SimpleTextOutlined( "Press Primary Fire to push yourself backwards.", "ScreenText",  posX, posY, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(255,255,255,255) )
		draw.SimpleTextOutlined( "Press Secondary Fire to suck in cacti.", "ScreenText",  posX, posY+25, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(255,255,255,255) )
		draw.SimpleTextOutlined( "Catch as many cacti as you can and don't get killed!", "ScreenText",  posX, posY+50, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(255,255,255,255) )
		DrawHumanHealth()
	end
	
end


//Here's our shitz

function GM:UpdateHUD_Observer( bWaitingToSpawn, InRound, ObserveMode, ObserveTarget )

	local lbl = nil
	local txt = nil
	local col = Color( 255, 255, 255 );

	if ( IsValid( ObserveTarget ) && ObserveTarget:IsPlayer() && ObserveTarget != LocalPlayer() && ObserveMode != OBS_MODE_ROAMING ) then
		lbl = "SPECTATING"
		txt = ObserveTarget:Nick()
		col = team.GetColor( ObserveTarget:Team() );
	end
	
	if ( ObserveMode == OBS_MODE_DEATHCAM || ObserveMode == OBS_MODE_FREEZECAM ) then
		txt = "You Died!" // were killed by?
	end
	
	if ( txt ) then
		local txtLabel = vgui.Create( "DHudElement" );
		if LocalPlayer():IsCactus() then
			txtLabel:SetText( "Press your fire keys to choose a new cactus!\nPress Jump to Spawn" )
		else
			txtLabel:SetText( txt )
		end
		if ( lbl ) then txtLabel:SetLabel( lbl ) end
		txtLabel:SetTextColor( col )
		
		GAMEMODE:AddHUDItem( txtLabel, 2 )		
	end

	
	GAMEMODE:UpdateHUD_Dead( bWaitingToSpawn, InRound )

end

function GM:UpdateHUD_Dead( bWaitingToSpawn, InRound )

	if ( !InRound && GAMEMODE.RoundBased ) then
	
		local RespawnText = vgui.Create( "DHudElement" );
			RespawnText:SizeToContents()
			RespawnText:SetText( "Waiting for round start" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		return
		
	end

	if ( bWaitingToSpawn ) then

		local RespawnTimer = vgui.Create( "DHudCountdown" );
			RespawnTimer:SizeToContents()
			RespawnTimer:SetValueFunction( function() return LocalPlayer():GetNWFloat( "RespawnTime", 0 ) end )
			if LocalPlayer():IsCactus() then
				RespawnTimer:SetLabel( "Press your fire keys to choose a new cactus!\nPress Jump to Spawn" )
			else
				RespawnTimer:SetLabel( "SPAWN IN" )
			end
		GAMEMODE:AddHUDItem( RespawnTimer, 8 )
		return

	end
	
	if ( InRound ) then
	
		local RoundTimer = vgui.Create( "DHudCountdown" );
			RoundTimer:SizeToContents()
			RoundTimer:SetValueFunction( function() 
											if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
											return GetGlobalFloat( "RoundEndTime" ) end )
			RoundTimer:SetLabel( "TIME" )
		GAMEMODE:AddHUDItem( RoundTimer, 8 )
		return
	
	end
	
	if ( Team != TEAM_SPECTATOR && !Alive ) then
	
		local RespawnText = vgui.Create( "DHudElement" );
			RespawnText:SizeToContents()
			if LocalPlayer():IsCactus() then
				RespawnText:SetText( "Press your fire keys to choose a new cactus!\nPress Jump to Spawn" )
			else
				RespawnText:SetText( "Press Fire to Spawn" )
			end
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		
	end

end

function GM:UpdateHUD_Alive( InRound )
	
	GAMEMODE:PaintHints()
	
	if ( GAMEMODE.RoundBased || GAMEMODE.TeamBased ) then
	
		
		local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 2 )

		if ( GAMEMODE.TeamBased ) then
		
			local TeamIndicator = vgui.Create( "DHudUpdater" );
				TeamIndicator:SizeToContents()
				TeamIndicator:SetValueFunction( function() 
													return team.GetName( LocalPlayer():Team() )
												end )
				TeamIndicator:SetColorFunction( function() 
													return team.GetColor( LocalPlayer():Team() )
												end )
				TeamIndicator:SetFont( "HudSelectionText" )
			Bar:AddItem( TeamIndicator )
			
		end
		
		if ( GAMEMODE.RoundBased ) then 
		
			local RoundNumber = vgui.Create( "DHudUpdater" );
				RoundNumber:SizeToContents()
				RoundNumber:SetValueFunction( function() return GetGlobalInt( "RoundNumber", 0 ) end )
				RoundNumber:SetLabel( "ROUND" )
			Bar:AddItem( RoundNumber )
			
			local RoundTimer = vgui.Create( "DHudCountdown" );
				RoundTimer:SizeToContents()
				RoundTimer:SetValueFunction( function() 
												if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
												return GetGlobalFloat( "RoundEndTime" ) end )
				RoundTimer:SetLabel( "TIME" )
			Bar:AddItem( RoundTimer )

		end
		
	end

end
