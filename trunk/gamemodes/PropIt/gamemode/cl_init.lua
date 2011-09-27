include( 'shared.lua' )
include("lists/props.lua")

local Spawnmenu = nil
local PropList = {}
local AllowSpawnMenu = false
local chosenNoun = ""
local RoundMode  = 0
surface.CreateFont( "HUDNumber", 48, 500, true, true, "PropItFont" )

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function addProp( model )
	table.insert( PropList, model )
end

function PropIt_Init()
	addProps()
	Spawnmenu = vgui.Create( "DFrame" ) //Create the spawnmenu
	local IconList  = vgui.Create( "DPanelList", Spawnmenu )
	
	Spawnmenu:Center()
	Spawnmenu:SetSize(500,500)
	Spawnmenu:SetTitle("Spawn menu")
	Spawnmenu:ShowCloseButton(false)
	Spawnmenu:SetVisible(false)
	
	IconList:EnableVerticalScrollbar( true ) 
 	IconList:EnableHorizontal( true ) 
 	IconList:SetPadding( 4 ) 
	IconList:SetPos(10,30)
	IconList:SetSize(480, 460)
 
	for k,v in pairs(PropList) do
		local icon = vgui.Create( "SpawnIcon", IconList ) 
		icon:SetModel( v )
		IconList:AddItem( icon )
		icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("PropIt_SpawnProp", v) end 
	end
	
	Spawnmenu:Center()
end
hook.Add( "Initialize", "PropIt_init", PropIt_Init )

function GM:InitPostEntity()
	return false
end

function GM:ShowTeam( )
	return false
end

function PropIt_HUDpaint()
	if(RoundMode == 1) then
		if(LocalPlayer():Team() == TEAM_PROPPER) then
			str = "You are the Prop Maker.\n\n Your word is: "..chosenNoun.."\n\nPress Q to access spawnmenu.\nNow PropIt!"
		else
			str = "You are a guesser.\nYou must guess what the Prop Maker is building by typing the word into chat."
		end
		surface.SetFont("FHUDElement")
		local w,h = surface.GetTextSize(str)
		draw.RoundedBox( 6, (ScrW()/2)-(w/2)-8,  (ScrH()/2)-(h/2)-8, w+8, h+8, Color( 20, 20, 20, 130 ) )
		draw.DrawText(str, "FHUDElement", (ScrW()/2)-(w/2),  (ScrH()/2)-(h/2), Color(255,255,255,255), ALIGN_CENTER)
		
	elseif(RoundMode == 2) then
		if(LocalPlayer():Team() == TEAM_PROPPER) then
			str = chosenNoun
		else
			str = "Guess"
		end
		surface.SetFont("FHUDElement")
		local w,h = surface.GetTextSize(str)
		draw.WordBox( 8, (ScrW() / 2)-(w/1.9), ScrH()/1.2, str, "FHUDElement", Color(20,20,20,120), Color(255,255,255,255) )
	elseif(RoundMode == 3) then
	end
	
	
end
hook.Add( "HUDPaint", "PropIt_HUDPaint", PropIt_HUDpaint )

function GM:OnSpawnMenuOpen()
	if ( LocalPlayer():Team() == TEAM_GUESSERS or !AllowSpawnMenu ) then 
		return 
	end
	Spawnmenu:SetVisible(true) 
	Spawnmenu:MakePopup()
	Spawnmenu:SetKeyBoardInputEnabled(false)
	RestoreCursorPosition()
end

function GM:OnSpawnMenuClose()
	RememberCursorPosition()
	Spawnmenu:SetVisible(false)
end

function PropIt_OnPreRound( um )
	chosenNoun = um:ReadString()
	RoundMode  = 1
end
usermessage.Hook("PropIt_PreRound", PropIt_OnPreRound)

function PropIt_OnRoundStart( um )
    AllowSpawnMenu = true
	RoundMode = 2
end
usermessage.Hook("PropIt_OnRoundStart", PropIt_OnRoundStart)

function PropIt_OnRoundEnd( um )
    AllowSpawnMenu = false
	RoundMode = 3
end
usermessage.Hook("PropIt_OnRoundEnd", PropIt_OnRoundEnd)
