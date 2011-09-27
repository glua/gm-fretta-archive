
local W, H = ScrW(), ScrH()
local Scale = ScrH()/480

surface.CreateFont("Coolvetica", 14*Scale, 500, true, false, "BMHudFontSmallBold")
surface.CreateFont("Coolvetica", 24*Scale, 500, true, false, "BMHudFontMediumBold")
surface.CreateFont("Coolvetica", 36*Scale, 500, true, false, "BMHudFontLargeBold")
surface.CreateFont("Coolvetica", 44*Scale, 500, true, false, "BMHudFontGiantBold")
surface.CreateFont("Coolvetica", 100*Scale, 500, true, false, "BMHudFontFuckingHugeBold")

local ItemCircle = surface.GetTextureID("gui/faceposer_indicator")

local matOutlineWhite 	= Material("white_outline")
local matOutlineBlack 	= Material("black_outline")

TEST = ClientsideModel("models/props_junk/watermelon01.mdl")
TEST:SetNoDraw(true)

POS=Vector(0,0,0)
ANG=Angle(-45,0,0)
CAMPOS=Vector(-80,0,0)
MODEL="bomb_plasma"
function GM:HUDPaint()
	--	ROUND NUMBER	-------------------------------------------------------------------------
	draw.SimpleTextOutlined("round", "BMHudFontSmallBold", W-60*Scale, H-18*Scale, Color(220,220,255,255),
		TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0,0,0,255))
	draw.SimpleTextOutlined(GetGlobalInt("RoundNumber", 0), "BMHudFontMediumBold", W-25*Scale, H-25*Scale, Color(220,220,255,255),
		TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0,0,0,255))
	
	--	ROUND TIME	-------------------------------------------------------------------------
	local m, s
	if GetGlobalFloat("RoundStartTime", 0) > CurTime() then
		s = GetGlobalFloat("RoundStartTime", 0)
	else
		s = GetGlobalFloat("RoundEndTime", 0)
	end
	s = math.floor(s - CurTime())
	if s<0 then s = 0 end
	
	m = math.floor(s/60)
	s = s%60
	
	if m<10 then m = "0"..m end
	if s<10 then s = "0"..s end
	
	local ypos
	if not LocalPlayer():Alive() or LocalPlayer():IsObserver() then
		ypos = H+5*Scale
	else
		ypos = H-25*Scale
	end
	
	draw.SimpleTextOutlined(":", "BMHudFontMediumBold", W/2, ypos, Color(220,220,255,255),
		TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0,0,0,255))
	draw.SimpleTextOutlined(m, "BMHudFontMediumBold", W/2-5*Scale, ypos, Color(220,220,255,255),
		TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 3, Color(0,0,0,255))
	draw.SimpleTextOutlined(s, "BMHudFontMediumBold", W/2+5*Scale, ypos, Color(220,220,255,255),
		TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0,0,0,255))
	
	--	ROUND RESULT	-------------------------------------------------------------------------
	local result = GetGlobalInt("RoundResult", 0)
	local winner = GetGlobalEntity("RoundWinner", nil)
	
	if result~=0 or ValidEntity(winner) then
		if result==-2 then
			draw.SimpleTextOutlined("o noes tiem is up!", "BMHudFontGiantBold", W/2, H/2, Color(255,255,255,255),
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
		elseif result==-1 or not ValidEntity(winner) then
			if math.sin(10*CurTime())>0 then
				draw.SimpleTextOutlined("EPIC FAIL", "BMHudFontFuckingHugeBold", W/2, H/2, Color(230,0,0,255),
					TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 6, Color(0,0,0,255))
			end
			draw.SimpleTextOutlined("omfg its a draw, u r all ghey!!!", "BMHudFontGiantBold", W/2, H/2, Color(255,255,255,255),
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
		else
			local str = winner:Name()
			local msg = " is teh winnar yay!!!!"
			if #str+#msg<=32 then
				surface.SetFont("BMHudFontGiantBold")
				local strwidth = surface.GetTextSize(str)
				local msgwidth = surface.GetTextSize(msg)
				local strx = (W-strwidth-msgwidth)/2
				local msgx = strx + strwidth
				draw.SimpleTextOutlined(str, "BMHudFontGiantBold", strx, H/2, self:GetTeamColor(winner),
						TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
				draw.SimpleTextOutlined(msg, "BMHudFontGiantBold", msgx, H/2, Color(255,255,255,255),
						TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
			else
				surface.SetFont("BMHudFontMediumBold")
				local strwidth = surface.GetTextSize(str)
				local msgwidth = surface.GetTextSize(msg)
				local strx = (W-strwidth-msgwidth)/2
				local msgx = strx + strwidth
				draw.SimpleTextOutlined(str, "BMHudFontMediumBold", strx, H/2, self:GetTeamColor(winner),
						TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
				draw.SimpleTextOutlined(msg, "BMHudFontMediumBold", msgx, H/2, Color(255,255,255,255),
						TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
				draw.SimpleTextOutlined("omg wtf wat a long naem lol", "BMHudFontSmallBold", W/2, H/2+16*Scale, Color(255,255,255,255),
					TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0,0,0,255))
			end
		end
	end
	
	--	SPECTATOR MODE	-------------------------------------------------------------------------
	if LocalPlayer():IsObserver() then
		local mode, target = LocalPlayer():GetObserverMode(), LocalPlayer():GetObserverTarget()
		if ValidEntity(target) and target:IsPlayer() and target~=LocalPlayer() and mode~=OBS_MODE_ROAMING then
			draw.SimpleTextOutlined("u r currnetly spectatin", "BMHudFontMediumBold", W/2, H-48*Scale, Color(255,255,255,255),
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
			draw.SimpleTextOutlined(target:Name(), "BMHudFontGiantBold", W/2, H-18*Scale, self:GetTeamColor(target),
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0,0,0,255))
		end
	end
	
	
	if not LocalPlayer():Alive() or LocalPlayer():IsObserver() then return end
	
	--	POWERUPS		-------------------------------------------------------------------------
	
	--[[
	TEST:SetPos(POS)
	TEST:SetAngles(ANG)
	
	surface.SetDrawColor(20, 50, 255, 255)
	surface.SetTexture(ItemCircle)
	surface.DrawTexturedRect((20-60)*Scale, H-(20+60)*Scale, 120*Scale, 120*Scale)
	
	cam.Start3D(CAMPOS, Angle(0,0,0), 65, (80-60)*Scale, H-(80+60)*Scale, 120*Scale, 120*Scale)
	cam.IgnoreZ(true)
	
	render.SuppressEngineLighting(true)
	render.SetLightingOrigin(Vector(0,0,50))
	render.ResetModelLighting(1,1,1)
	SetMaterialOverride(matOutlineWhite)
	
	multimodel.Draw(multimodel.GetMultiModel(MODEL), TEST, {modelonly=true, norenderoverride=true})
	
	SetMaterialOverride(0)
	render.SuppressEngineLighting(false)
	cam.IgnoreZ(false)
	cam.End3D()
	
	cam.Start3D(CAMPOS, Angle(0,0,0), 70, (80-60)*Scale, H-(80+60)*Scale, 120*Scale, 120*Scale)
	cam.IgnoreZ(true)
	
	render.SuppressEngineLighting(true)
	render.SetLightingOrigin(Vector(0,0,50))
	render.ResetModelLighting(1,1,1)
	
	multimodel.Draw(multimodel.GetMultiModel(MODEL), TEST, {modelonly=true})
	
	render.SuppressEngineLighting(false)
	cam.IgnoreZ(false)
	cam.End3D()]]
	
	
	--[[
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
]]
end
