/*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
cl_init.lua
	-Gamemode clientside init
*/

include( 'shared.lua' )
include('cl_hud.lua')

local US_Flag = surface.GetTextureID( "MiniTankWars/US_Flag" )
local USSR_Flag = surface.GetTextureID( "MiniTankWars/USSR_Flag" )
local MTW_Logo = surface.GetTextureID( "MiniTankWars/MiniTankWarsLogo" )

local TankClassThumbs = {}
TankClassThumbs[""] = "MiniTankWars/Tanks/HealthThumbs/alpha"
TankClassThumbs["M1A2 Abrams"] = "MiniTankWars/Tanks/ClassThumbs/M1A2_Abrams"
TankClassThumbs["T-90"] = "MiniTankWars/Tanks/ClassThumbs/T-90"
TankClassThumbs["M551 Sheridan"] = "MiniTankWars/Tanks/ClassThumbs/M551_Sheridan"
TankClassThumbs["BMP-3"] = "MiniTankWars/Tanks/ClassThumbs/BMP-3"

local SH = ScrH()
local SHL = SH
local SF, SF2
local function RecalcSFs()
	SF = ScrH()/768  //scalefactor
	SF2 = SF/2
	XMV=(ScrW()/2)-512*SF
	VC = ScrH()/2
	HC = 512*SF
end
RecalcSFs()

function GM:PaintSplashScreen(w, h)
	if SH!=SHL then RecalcSFs() end
	surface.SetDrawColor( 255, 255, 255, 255 ) 
	
	surface.SetTexture( US_Flag )
	surface.DrawTexturedRect( 48*SF+XMV, 48*SF, 512*SF2, 128*SF2 )
	
	surface.SetTexture( USSR_Flag )
	surface.DrawTexturedRect( 720*SF+XMV, 48*SF, 512*SF2, 128*SF2 )
	
	surface.SetDrawColor(Color(150,150,150,200))
	surface.SetTexture( MTW_Logo )
	surface.DrawTexturedRect( 262*SF+XMV, 255*SF, 512*SF, 256*SF )
	SHL=SH
	SH=ScrH()
end

function GM:ShowClassChooser( TEAMID )
	if ( !GAMEMODE.SelectClass ) then return end
	if ( ClassChooser ) then ClassChooser:Remove() end

	ClassChooser = vgui.CreateFromTable( vgui_Splash )
	ClassChooser:SetHeaderText( "Choose Tank" )
	
	local Descrip = vgui.Create("DLabel", ClassChooser)
	Descrip:SetText("Which tank do you want to use?")
	Descrip:SetFont("FRETTA_MEDIUM")
	Descrip:SizeToContents()
	Descrip:SetPos( HC+(24*SF), VC-(208*SF) )

	Classes = team.GetClass( TEAMID )
	for k, v in SortedPairs( Classes ) do
		
		local displayname = v
		local Class = player_class.Get( v )
		if ( Class && Class.DisplayName ) then
			displayname = Class.DisplayName
		end
		
		local ClassDescriptionPanel = vgui.Create("DPanel", ClassChooser)
		ClassDescriptionPanel:SetPos( HC+(64*SF), VC-(136*SF) )
		ClassDescriptionPanel:SetSize(300*SF, 300*SF)
		function ClassDescriptionPanel:Paint()
			//nothing
		end
		local InstructionsText = vgui.Create("DLabel", ClassDescriptionPanel)
		InstructionsText:SetFont( "FRETTA_MEDIUM" )
		InstructionsText:SetText("Click to deploy as:")	
		InstructionsText:SizeToContents()
		local ClassImage = vgui.Create("DImage", ClassDescriptionPanel)
		ClassImage:SetImage(TankClassThumbs[displayname])
		ClassImage:SetSize(256*SF, 256*SF)
		ClassImage:MoveBelow(InstructionsText)
		ClassImage.y = ClassImage.y-(40*SF)
		ClassDescriptionPanel:SetVisible(false)
		
		local func = function() if( cl_classsuicide:GetBool() ) then RunConsoleCommand( "kill" ) end RunConsoleCommand( "changeclass", k ) end
		local btn = ClassChooser:AddSelectButton( displayname, func )
		btn.m_colBackground = team.GetColor( TEAMID )
		btn.OnCursorEntered = function() ClassDescriptionPanel:SetVisible(true) end
		btn.OnCursorExited = function() ClassDescriptionPanel:SetVisible(false) end
		
	end
	
	ClassChooser:MakePopup()
	ClassChooser:NoFadeIn()

end