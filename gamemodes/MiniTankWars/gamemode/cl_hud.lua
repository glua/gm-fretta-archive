  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
cl_hud.lua
	-Clientside(duh) HUD setup
*/
local SH = ScrH()
local SHL = SH
//textures
local US_Flag = surface.GetTextureID( "MiniTankWars/US_Flag" )
local USSR_Flag = surface.GetTextureID( "MiniTankWars/USSR_Flag" )
local US_Flag_NoText = surface.GetTextureID( "MiniTankWars/US_Flag_NoText" )
local USSR_Flag_NoText = surface.GetTextureID( "MiniTankWars/USSR_Flag_NoText" )
local ReticleTex = surface.GetTextureID( "MiniTankWars/Reticle" )
local NoReticleTex = surface.GetTextureID( "MiniTankWars/NoReticle" )
local TankHealthThumbs = {}
TankHealthThumbs[""] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/alpha" )
TankHealthThumbs["M1A2_Abrams"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/M1A2_AbramsThumb" )
TankHealthThumbs["T-90"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/T-90Thumb" )
TankHealthThumbs["M551_Sheridan"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/M551_SheridanThumb" )
TankHealthThumbs["BMP-3"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/BMP-3Thumb" )
local TankHealthThumbsBlur = {}
TankHealthThumbsBlur[""] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/alpha" )
TankHealthThumbsBlur["M1A2_Abrams"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/M1A2_AbramsThumb_Blur" )
TankHealthThumbsBlur["T-90"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/T-90Thumb_Blur" )
TankHealthThumbsBlur["M551_Sheridan"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/M551_SheridanThumb_Blur" )
TankHealthThumbsBlur["BMP-3"] = surface.GetTextureID( "MiniTankWars/Tanks/HealthThumbs/BMP-3Thumb_Blur" )
//colors
local Color_USABlue = Color(41,41,222)
local Color_USSRRed = Color(189,0,0)
local Color_White = Color(255,255,255)
local Color_Black = Color(0,0,0)
local Color_Gray = Color(60,60,60)
local Color_Gray_75A = Color(60,60,60,191)
local Color_Gray2 = Color(80,80,80)
local Color_HUDYellow = Color(228,185,9)
//fonts
surface.CreateFont( "Trebuchet MS", 24*(ScrH()/768), 400, true, false, "TB22")
surface.CreateFont( "Coolvetica", 22*(ScrH()/768), 300, true, false, "CV22" )
surface.CreateFont( "Coolvetica", 34*(ScrH()/768), 250, true, false, "CV27" )
surface.CreateFont( "Coolvetica", 18*(ScrH()/768), 300, true, false, "CV18" )
//scalefactors
local SF, SF2, SF3, SF4, VC, HC
local function ScaleFactors() 
	SF = ScrH()/768  //scalefactor
	SF2 = SF/2
	SF3 = SF/3
	SF4 = SF/4
	VC = ScrH()/2
	HC = 512*SF
	XMV=(ScrW()/2)-HC
end
ScaleFactors()
//misc
local fadenum=0
local slowfadenum=0
local fadenumchange=10
local slowfadenumchange=2
local PlayerTank=LocalPlayer():GetNWString("TankName", "")
local TankHealthThumb = TankHealthThumbs[PlayerTank]
local TankHealthThumbBlur = TankHealthThumbsBlur[PlayerTank]
local StartHealth = 100
local SteamAvatars = {}

function CheckTankChange()
	if LocalPlayer():GetNWString("TankName") !=PlayerTank then
		TankHealthThumb = TankHealthThumbs[LocalPlayer():GetNWString("TankName")]
		TankHealthThumbBlur = TankHealthThumbsBlur[LocalPlayer():GetNWString("TankName")]
		StartHealth = LocalPlayer():GetPlayerClass().StartHealth
	end
end
timer.Create("TankChangeHUDTimer", 1, 0, CheckTankChange)


function GM:OnHUDPaint()
	if SH!=SHL then
		ScaleFactors()
	end

	fadenum=fadenum+fadenumchange
	if (fadenum >=255 or fadenum <=0) then
		fadenum = math.Clamp(fadenum, 0, 255)
		fadenumchange = fadenumchange*-1
	end
	slowfadenum=slowfadenum+slowfadenumchange
	if (slowfadenum >=255 or slowfadenum <=0) then
		slowfadenum = math.Clamp(slowfadenum, 0, 255)
		slowfadenumchange = slowfadenumchange*-1
	end
	
	surface.SetDrawColor( Color_White ) 
	//------------Team Tags----------------
	for k, pl in pairs(team.GetPlayers(LocalPlayer():Team())) do
		local UID = pl:UniqueID()
		if pl:Alive() then
			//get loc, are they even onscreen?
			local TagPos = (pl:GetPos()+Vector(0,0,125)):ToScreen()
			if TagPos.visible==true and pl!=LocalPlayer() then
				//steam avatar, does it exist?
				if not SteamAvatars[UID] then
					SteamAvatars[UID] = vgui.Create("AvatarImage")
					SteamAvatars[UID]:SetPlayer(pl)
					SteamAvatars[UID]:SetSize(32*SF, 32*SF)
				end
				local SteamAvatar = SteamAvatars[UID] 		
				local PosX=math.Round((TagPos.x-(82*SF))/SF)*SF //center it up
				local PosY=math.Round(TagPos.y/SF)*SF
				//draw image
				draw.RoundedBox(6, PosX-(3*SF), PosY-(3*SF), 172*SF, 38*SF, Color_Gray)
				SteamAvatar:SetVisible(true)
				SteamAvatar:SetPos(PosX, PosY)
				surface.SetDrawColor(Color_White)
				if pl:Team() == 1 then
					surface.SetTexture( US_Flag_NoText )
				else 
					surface.SetTexture( USSR_Flag_NoText )
				end
				surface.DrawTexturedRect( PosX+(36*SF), PosY, 512*SF4, 128*SF4 )
				//draw name
				draw.DrawText(pl:Nick(), "CV18", PosX+(SF*104), PosY+(8*SF), Color_Black, 1)  //shadow
				draw.DrawText(pl:Nick(), "CV18", PosX+(SF*103), PosY+(7*SF), Color_White, 1)
			else
				//hide ava
				if SteamAvatars[UID] then
					SteamAvatars[UID]:SetVisible(false)
				end
			end
		else
			if SteamAvatars[UID] then
				SteamAvatars[UID]:SetVisible(false)
			end
		end
	end
	
	//-----------------Score Indicator-----------------------------------
	draw.RoundedBox(6, 229*SF+XMV, 27*SF, 572*SF, 26*SF, Color_Black)
	draw.RoundedBox(6, 231*SF+XMV, 29*SF, 568*SF, 22*SF, Color_Gray)
	
	//USA
	draw.RoundedBox(6, 12*SF+XMV, 12*SF, 536*SF3, 152*SF3, Color_Gray)
	surface.SetDrawColor(Color_White)
	surface.SetTexture( US_Flag )
	surface.DrawTexturedRect( 16*SF+XMV, 16*SF, 512*SF3, 128*SF3 )
	
	draw.RoundedBox(6, 231*SF+XMV, 29*SF, ((math.Clamp(team.GetScore(TEAM_USA), 3, 40)/40)*280)*SF, 22*SF, Color_USABlue)
	draw.DrawText(team.GetScore(TEAM_USA), "TB22", (((math.Clamp(team.GetScore(TEAM_USA), 3, 40)*.01)*280)+231)*SF+XMV, 29*SF, Color_White, 1)
	
	//USSR
	draw.RoundedBox(4, 834*SF+XMV, 12*SF, 536*SF3, 152*SF3, Color_Gray)
	surface.SetDrawColor(Color_White)
	surface.SetTexture( USSR_Flag)
	surface.DrawTexturedRect( 838*SF+XMV, 16*SF, 512*SF3, 128*SF3 )
	
	draw.RoundedBox(6, (799-((math.Clamp(team.GetScore(TEAM_USSR), 3, 40)/40)*280))*SF+XMV, 29*SF, ((math.Clamp(team.GetScore(TEAM_USSR), 3, 40)/40)*280)*SF, 22*SF, Color_USSRRed)
	draw.DrawText(team.GetScore(TEAM_USSR), "TB22", (798-((math.Clamp(team.GetScore(TEAM_USSR), 3, 40)*.01)*280))*SF+XMV, 29*SF, Color_White, 1)
	
	//---
	surface.SetDrawColor(Color_Gray2)
	surface.DrawRect(HC-(2*SF)+XMV, 29*SF, 4*SF, 22*SF)
	draw.DrawText("-40-", "TB22", HC+XMV, 29*SF, Color_White, 1)
	//---------------End Score Indicator---------------------------------

	if LocalPlayer():Alive() then
		//----------------Armor Display--------------------------------------
		draw.RoundedBox(8, 11*SF+XMV, 665*SF, 174*SF, 84*SF, Color_Gray)
		draw.RoundedBox(8, 163*SF+XMV, 707*SF, 55*SF, 49*SF, Color_Gray)
		local HealthColor = HSVToColor(   math.Clamp((((LocalPlayer():Health()*1.1)-10)/StartHealth)*130, 0,120), 1, 1)
		
		surface.SetDrawColor(HealthColor)
		surface.SetTexture( TankHealthThumbBlur )
		surface.DrawTexturedRect( 20*SF+XMV, 672*SF, 148*SF, 69*SF )
		surface.SetDrawColor(Color_White)
		surface.SetTexture( TankHealthThumb )
		surface.DrawTexturedRect( 20*SF+XMV, 672*SF, 148*SF, 69*SF )

		draw.DrawText(LocalPlayer():Health(), "CV27", 191*SF+XMV, 712*SF, HealthColor, 1)
		draw.DrawText("Armor", "CV18", 192*SF+XMV, 738*SF, Color_HUDYellow, 1)
		//--------------End Armor Display------------------------------------
		
		//---------------Ammo Display----------------------------------------
		draw.RoundedBox(8, 823*SF+XMV, 700*SF, 180*SF, 54*SF, Color_Gray_75A)
		if (LocalPlayer():GetActiveWeapon():IsWeapon()) then
			draw.DrawText(LocalPlayer():GetActiveWeapon():GetPrintName(), "CV27", 832*SF+XMV, 700*SF, Color_HUDYellow, 0)
			draw.DrawText(LocalPlayer():GetActiveWeapon():Clip1(), "CV27", 969*SF+XMV, 715*SF, Color_HUDYellow, 1)
		end
		local fadecolor = Color(228,185,9, fadenum)
		if LocalPlayer():GetNWBool("Reloading", false)==true then
			draw.DrawText("reloading...", "CV18", 897*SF+XMV, 735*SF, fadecolor, 1)
		end
		//---------------End Ammo Display------------------------------------
		
		//---------------Powerup Bar----------------------------------------
		if LocalPlayer():GetNWBool("PowerupActive", true)==true then
			//container
			draw.RoundedBox(6, HC-(101*SF)+XMV, 54*SF, 200*SF, 24*SF, Color_Black)
			draw.RoundedBox(6, HC-(100*SF)+XMV, 55*SF, 198*SF, 22*SF, Color_Gray)
			//bar
			local Percentage=LocalPlayer():GetNWFloat("PowerupTime")/LocalPlayer():GetNWFloat("PowerupTotTime")
			draw.RoundedBox(6, HC-(((Percentage*94)+6)*SF)+XMV, 55*SF, ((Percentage*182)+18)*SF, 22*SF, Color_HUDYellow)
			//name
			draw.DrawText(LocalPlayer():GetNWString("PowerupName"), "CV22", HC+(0.5*SF)+XMV, 53.5*SF, Color_Black, 1)
			draw.DrawText(LocalPlayer():GetNWString("PowerupName"), "CV22", HC+XMV, 53*SF, Color_White, 1)
		end
		//-------------End Powerup Bar----------------------------------------
		
		//Crosshair
		surface.SetDrawColor(Color_White)
		if LocalPlayer():GetNWBool("Reloading", false)==true then
			surface.SetTexture( NoReticleTex )
		else
			surface.SetTexture( ReticleTex )
		end
		local TurretEnt = LocalPlayer():GetNWEntity("TurretEnt")
		if TurretEnt:IsValid() then			
			local BarPos = TurretEnt:GetBonePosition(TurretEnt:LookupBone("Barrel"))
			local BarAng = TurretEnt:GetAngles()
			BarAng:RotateAroundAxis(TurretEnt:GetRight(), TurretEnt:GetNWFloat("Turret_Elevate", 0) )
			local CPos=util.QuickTrace(BarPos+BarAng:Forward()*TurretEnt.BarrelLength,BarAng:Forward()*10000, TurretEnt).HitPos:ToScreen()//util.QuickTrace(AttachmentData.Pos,AttachmentData.Ang:Forward()*10000, TurretEnt).HitPos:ToScreen()
			surface.DrawTexturedRect( CPos.x-(32*SF), CPos.y-(32*SF), 64*SF, 64*SF )
		end
		
		//Flip Prompt
		if (LocalPlayer():GetNWBool("FlipPrompt", false)==true) then
			draw.RoundedBox(8, HC-(125*SF)+XMV, VC-(5*SF), 250*SF, 40*SF, Color_Gray_75A)
			draw.DrawText("Press USE to Flip.", "CV27", HC+XMV, VC, Color(255,255,255,255-slowfadenum), 1 )
		end
		
	end
	
	
	SHL=SH
	SH=ScrH()
end

function GM:HUDShouldDraw( name )
	if (name == "CHudHealth" or name == "CHudBattery" or name == "CHudWeaponSelection" or name=="CHudWeapon" or name=="CHudAmmo" or name=="CHudSecondaryAmmo" or name=="CHudCrosshair") then
		return false
	end
	return true
end


/*
******************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************
*/



local hudScreen = nil
local Alive = false
local Class = nil
local Team = 0
local WaitingToRespawn = false
local InRound = false
local RoundResult = 0
local RoundWinner = nil
local IsObserver = false
local ObserveMode = 0
local ObserveTarget = NULL
local InVote = false

local BottomOfTheScreen=vgui.Create("DPanel")
BottomOfTheScreen:SetSize(24*SF,24*SF)
BottomOfTheScreen:SetPos(HC,ScrH()-(100*SF))
function BottomOfTheScreen:Paint()
end

function GM:AddHUDItem( item, pos, parent )
	hudScreen:AddItem( item, parent, pos )
end

function GM:HUDNeedsUpdate()

	if ( !IsValid( LocalPlayer() ) ) then return false end

	if ( Class != LocalPlayer():GetNWString( "Class", "Default" ) ) then return true end
	if ( Alive != LocalPlayer():Alive() ) then return true end
	if ( Team != LocalPlayer():Team() ) then return true end
	if ( WaitingToRespawn != ( (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !LocalPlayer():Alive()) ) then return true end
	if ( InRound != GetGlobalBool( "InRound", false ) ) then return true end
	if ( RoundResult != GetGlobalInt( "RoundResult", 0 ) ) then return true end
	if ( RoundWinner != GetGlobalEntity( "RoundWinner", nil ) ) then return true end
	if ( IsObserver != LocalPlayer():IsObserver() ) then return true end
	if ( ObserveMode != LocalPlayer():GetObserverMode() ) then return true end
	if ( ObserveTarget != LocalPlayer():GetObserverTarget() ) then return true end
	if ( InVote != GAMEMODE:InGamemodeVote() ) then return true end
	
	return false
end

function GM:OnHUDUpdated()
	Class = LocalPlayer():GetNWString( "Class", "Default" )
	Alive = LocalPlayer():Alive()
	Team = LocalPlayer():Team()
	WaitingToRespawn = (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !Alive
	InRound = GetGlobalBool( "InRound", false )
	RoundResult = GetGlobalInt( "RoundResult", 0 )
	RoundWinner = GetGlobalEntity( "RoundWinner", nil )
	IsObserver = LocalPlayer():IsObserver()
	ObserveMode = LocalPlayer():GetObserverMode()
	ObserveTarget = LocalPlayer():GetObserverTarget()
	InVote = GAMEMODE:InGamemodeVote()
end

function GM:RefreshHUD()

	if ( !GAMEMODE:HUDNeedsUpdate() ) then return end
	GAMEMODE:OnHUDUpdated()
	
	if ( IsValid( hudScreen ) ) then hudScreen:Remove() end
	hudScreen = vgui.Create( "DHudLayout" )
	
	if ( InVote ) then return end
	
	if ( RoundWinner and RoundWinner != NULL ) then
		GAMEMODE:UpdateHUD_RoundResult( RoundWinner, Alive )
	elseif ( RoundResult != 0 ) then
		GAMEMODE:UpdateHUD_RoundResult( RoundResult, Alive )
	elseif ( IsObserver ) then
		GAMEMODE:UpdateHUD_Observer( WaitingToRespawn, InRound, ObserveMode, ObserveTarget )
	elseif ( !Alive ) then
		GAMEMODE:UpdateHUD_Dead( WaitingToRespawn, InRound )
	else
		GAMEMODE:UpdateHUD_Alive( InRound )
	end
	
end

function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	GAMEMODE:OnHUDPaint()
	GAMEMODE:RefreshHUD()
	
end

function GM:UpdateHUD_RoundResult( RoundResult, Alive )

	local txt = GetGlobalString( "RRText" )
	
	if ( type( RoundResult ) == "number" ) && ( team.GetAllTeams()[ RoundResult ] && txt == "" ) then
		local TeamName = team.GetName( RoundResult )
		if ( TeamName ) then txt = TeamName .. " Wins!" end
	elseif ( type( RoundResult ) == "Player" && ValidEntity( RoundResult ) && txt == "" ) then
		txt = RoundResult:Name() .. " Wins!"
	end

	local RespawnText = vgui.Create( "DHudElement" );
		RespawnText:SizeToContents()
		RespawnText:SetText( txt )
	GAMEMODE:AddHUDItem( RespawnText, 8, BottomOfTheScreen)

end

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
		txtLabel:SetText( txt )
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
		GAMEMODE:AddHUDItem( RespawnText, 8, BottomOfTheScreen)
		return
		
	end

	if ( bWaitingToSpawn ) then

		local RespawnTimer = vgui.Create( "DHudCountdown" );
			RespawnTimer:SizeToContents()
			RespawnTimer:SetValueFunction( function() return LocalPlayer():GetNWFloat( "RespawnTime", 0 ) end )
			RespawnTimer:SetLabel( "SPAWN IN" )
		GAMEMODE:AddHUDItem( RespawnTimer, 8, BottomOfTheScreen)
		return

	end
	
	if ( InRound ) then
	
		local RoundTimer = vgui.Create( "DHudCountdown" );
			RoundTimer:SizeToContents()
			RoundTimer:SetValueFunction( function() 
											if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
											return GetGlobalFloat( "RoundEndTime" ) end )
			RoundTimer:SetLabel( "TIME" )
		GAMEMODE:AddHUDItem( RoundTimer, 8, BottomOfTheScreen)
		return
	
	end
	
	if ( Team != TEAM_SPECTATOR && !Alive ) then
	
		local RespawnText = vgui.Create( "DHudElement" );
			RespawnText:SizeToContents()
			RespawnText:SetText( "Press Fire to Spawn" )
		GAMEMODE:AddHUDItem( RespawnText, 8, BottomOfTheScreen)
	end

end

function GM:UpdateHUD_Alive( InRound )

	if ( GAMEMODE.RoundBased || GAMEMODE.TeamBased ) then
	
		local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 2 )

		/*if ( GAMEMODE.TeamBased ) then
		
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
			
		end*/
		
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

function GM:UpdateHUD_AddedTime( iTimeAdded )
	// to do or to override, your choice
end
usermessage.Hook( "RoundAddedTime", function( um ) if( GAMEMODE && um ) then GAMEMODE:UpdateHUD_AddedTime( um:ReadFloat() ) end end )






