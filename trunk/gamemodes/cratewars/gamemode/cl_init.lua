include( 'shared.lua' )
include( "cl_points.lua" )
include( "cl_flag.lua" )
include('resources.lua')
include('cl_deathnotice.lua')

local nextplay = 0
function countdownSounds()
	if(GetGlobalFloat( "RoundStartTime" ) < CurTime())then
		time = math.Round(GetGlobalFloat( "RoundEndTime" )-CurTime())
	else
		time = math.Round(GetGlobalFloat( "RoundStartTime" )-CurTime())
	end
	if(CurTime() >= nextplay) and (GetGlobalBool( "InRound", false ))then
		if(!GetGlobalBool( "InRealRound"))then
			if(time == 1)then
				PlaySound(SOUND_BEGIN_1)
			elseif(time == 2)then
				PlaySound(SOUND_BEGIN_2)
			elseif(time == 3)then
				PlaySound(SOUND_BEGIN_3)
			elseif(time == 4)then
				PlaySound(SOUND_BEGIN_4)
			elseif(time == 5)then
				PlaySound(SOUND_BEGIN_5)
			elseif(time == 10)then
				PlaySound(SOUND_BEGIN_10)
			elseif(time == 20)then
				PlaySound(SOUND_BEGIN_20)
			elseif(time == 30)then
				PlaySound(SOUND_BEGIN_30)
			elseif(time == 60)then
				PlaySound(SOUND_BEGIN_60)
			end
		else
			if(time == 1)then
				PlaySound(SOUND_END_1)
			elseif(time == 2)then
				PlaySound(SOUND_END_2)
			elseif(time == 3)then
				PlaySound(SOUND_END_3)
			elseif(time == 4)then
				PlaySound(SOUND_END_4)
			elseif(time == 5)then
				PlaySound(SOUND_END_5)
			elseif(time == 6)then
				PlaySound(SOUND_END_6)
			elseif(time == 7)then
				PlaySound(SOUND_END_7)
			elseif(time == 8)then
				PlaySound(SOUND_END_8)
			elseif(time == 9)then
				PlaySound(SOUND_END_9)
			elseif(time == 10)then
				PlaySound(SOUND_END_10)
			elseif(time == 20)then
				PlaySound(SOUND_END_20)
			elseif(time == 30)then
				PlaySound(SOUND_END_30)
			elseif(time == 60)then
				PlaySound(SOUND_END_60)
			elseif(time == 120)then
				PlaySound(SOUND_END_120)
			elseif(time == 300)then
				PlaySound(SOUND_END_300)
			end
		end
	end
end
hook.Add("Think", "countdownSounds", countdownSounds)

function PlaySound(id)
	LocalPlayer():EmitSound( id, 100, 100 )
	nextplay = CurTime()+1
end

function GM:HUDShouldDraw( name )
    local oldhudshit = {
        "CHudHealth",
        "CHudBattery",
        "CHudAmmo",
        "CHudSecondaryAmmo" }
     
    for k,v in pairs( oldhudshit ) do
        if name == v then
            return false
        end
    end
     
    return true
end

surface.CreateFont( "ChatFont", 40, 400, true, false, "BigChatFont" )
function Healthbar()
	if(LocalPlayer():Team() != TEAM_UNASSIGNED) and (LocalPlayer():Team() != TEAM_SPECTATOR) and (LocalPlayer():Alive())then
		local color = team.GetColor(LocalPlayer():Team())
		local r = color.r
		local g = color.g
		local b = color.b
		size = 220
		draw.RoundedBoxEx( 6, 0, ScrH()-10-48, size, 48, Color(r, g, b, 100), false, true, false, true )
		struc = {}
		struc["pos"] = {4, ScrH()-56}
		struc["color"] = Color(255, 255, 255, 240)
		struc["text"] = "Health: " .. tostring(LocalPlayer():Health()) .."%"
		struc["font"] = "BigChatFont"
		struc["xalign"] = TEXT_ALIGN_LEFT
		struc["yalign"] = TEXT_ALIGN_TOP
		draw.TextShadow( struc, 2, 160 )
	end
end
hook.Add("HUDPaint","Healthbar",Healthbar)

function IncomingStats( handler, id, encoded, decoded )
	PrintTable( decoded )
	local StatsFrame = vgui.Create( "DFrame" )
	 StatsFrame:SetTitle( "Statistics" )
	 StatsFrame:SetSize(800, 600)
	 StatsFrame:Center()
	 StatsFrame:SetBackgroundBlur( true )
	 StatsFrame:MakePopup()
	 
	 local StatsHTMLFrame = vgui.Create( "HTML", StatsFrame )
	 StatsHTMLFrame:SetPos( 25, 50 )
	 StatsHTMLFrame:SetSize(750, 525 )
	 print(GetGlobalEntity( "RoundWinner", nil ))
	if(decoded["team"] == TEAM_RED)then
		teamwinner = "Red"
	elseif(decoded["team"] == TEAM_BLUE)then
		teamwinner = "Blue"
	else
		teamwinner = "Nobody"
	end
	 StatsHTMLFrame:SetHTML('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><style type="text/css">body{background-color:#444;font-family:"verdana";width:700px;height:475px;}h1{text-shadow: 2px 2px 2px #000;text-align:center;}h2{}hr{width:80%;border:0;height:1px;background:#000;}p{font-size:14px;text-shadow: 1px 1px 0px #000;}div{margin:10px 25px 25px 25px;background-color:#888;width:650px;height:450px;text-align:center;box-shadow: 3px 3px 1px #222;}.award{color:#FF9500;font-size:18px;font-weight:bold;}.t1{color:#FF0000;font-size:18px;font-weight:bold;}.t2{color:#0000FF;font-size:18px;font-weight:bold;}.ht1{color:#FF0000;}.ht2{color:#0000FF;}</style></head><body><h1><span class="ht'..decoded["team"]..'">'..teamwinner..' Wins</span></h1><div><h2>Awards</h2><hr/><p><span class="award">MVP</span> award for most points goes to: <span class="t'..decoded["highplayers"]["mvp"]:Team()..'">'..decoded["highplayers"]["mvp"]:Nick()..'</span><br/><span class="award">Architect</span> award for most boxes placed goes to: <span class="t'..decoded["highplayers"]["placed"]:Team()..'">'..decoded["highplayers"]["placed"]:Nick()..'</span><br/><span class="award">Demolisher</span> award for most boxes destroyed goes to: <span class="t'..decoded["highplayers"]["broken"]:Team()..'">'..decoded["highplayers"]["broken"]:Nick()..'</span><br/><span class="award">Executioner</span> award for most kills goes to: <span class="t'..decoded["highplayers"]["kills"]:Team()..'">'..decoded["highplayers"]["kills"]:Nick()..'</span><br/><span class="award">Doing It Wrong</span> award for most deaths goes to: <span class="t'..decoded["highplayers"]["wrong"]:Team()..'">'..decoded["highplayers"]["wrong"]:Nick()..'</span><br/><span class="award">Scout</span> award for most flags captured goes to: <span class="t'..decoded["highplayers"]["caps"]:Team()..'">'..decoded["highplayers"]["caps"]:Nick()..'</span><br/><span class="award">Pyrotechnician</span> award for most grenades fired goes to: <span class="t'..decoded["highplayers"]["nades"]:Team()..'">'..decoded["highplayers"]["nades"]:Nick()..'</span><br/></p><h2>Your Stats</h2><hr/><p><span style="font-size:18px;font-weight:bold">Boxes placed: </span><span class="award">'..decoded["stats"]["placed"]..'</span><br/><span style="font-size:18px;font-weight:bold">Boxes destroyed: </span><span class="award">'..decoded["stats"]["broken"]..'</span><br/><span style="font-size:18px;font-weight:bold">Players killed: </span><span class="award">'..decoded["stats"]["kills"]..'</span><br/><span style="font-size:18px;font-weight:bold">Flags captured: </span><span class="award">'..decoded["stats"]["caps"]..'</span><br/><span style="font-size:18px;font-weight:bold">Grenades fired: </span><span class="award">'..decoded["stats"]["nades"]..'</span><br/></p></div></body></html>')
end
datastream.Hook( "Stats", IncomingStats );

function sayString(msg)
	RunConsoleCommand("say", msg)
end