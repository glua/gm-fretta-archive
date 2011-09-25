include("shared.lua")
include("cl_shop.lua")
surface.CreateFont("Impact", 50, 2, true, false, "firstvada")
function DrawBlind()
	if !LocalPlayer():GetNWBool( "Blind" ) then return end
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, ScrW(), ScrH() )
	draw.SimpleText("You are first seeker! Please wait 15 seconds", "firstvada", ScrW() / 2, ScrH() / 2, Color(0,200,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
hook.Add( "HUDPaint", "DrawBlind1", DrawBlind )


function GM:HUDShouldDraw( name )
	if GAMEMODE.ScoreboardVisible then return false end
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end 
  	end 
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
		return false
	end
	return true
end

function DrawInvis()
	//Invis overlay
	if LocalPlayer():GetNWBool("Invis") then
		draw.RoundedBox(2,0,0, ScrW(), ScrH(), Color(0,0,120,120))
	end
	//Class name(why not here? :))
	-- local class = LocalPlayer():GetPlayerClassName()
	-- local color = Color(0,200,0,255)
	-- if class == "invis" then class="Invisible" color = Color(0,200,0,255)
	-- elseif class == "runner" then class="Runner" color = Color(0,200,0,255)
	-- elseif class == "standart" then class="Standart" color = Color(200,0,0,255)
	-- elseif class == "heavy" then class="Heavy" color = Color(200,0,0,255)
	-- elseif class == "stealh_seeker" then class="Stealth" color = Color(200,0,0,255)
	-- elseif class == "jumper_seeker" then class="Jumper" color = Color(200,0,0,255) end
	-- draw.RoundedBox(10,10, ScrH() - 75, 110, 25, Color(0,0,0,150))
	-- draw.SimpleText("Class: "..class, "ScoreboardText", 15, ScrH() - 70, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	//Invis progressbar
	if LocalPlayer():GetNWBool("HasInvis") then
		local InvisTime = LocalPlayer():GetNWInt("InvisTime")
		if InvisTime <= 0 then return end
		draw.RoundedBox(10,10,10, 300, 50, Color(0,0,0,150))
		draw.SimpleText("Invisibility(Secondary Attack)", "ScoreboardText", 15,15, Color(0,200,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.RoundedBox(4,18,35,14*InvisTime,15,Color(0,0,255,255))
	end
end
hook.Add("HUDPaint", "Hns_DrawInvis", DrawInvis)

function BennyHill(um)
	if um:ReadBool() then
		if not MusicIsPlaying then LocalPlayer():EmitSound("music/hns/ololol.mp3", 100, 100) end
		MusicIsPlaying = true
	else
		LocalPlayer():StopSound("music/hns/ololol.mp3")
		MusicIsPlaying = false
	end
end
usermessage.Hook("BennyHill", BennyHill)

function cl_playhev(um)
	local sound = um:ReadString()
	LocalPlayer():EmitSound(sound, 100, 100)
end
usermessage.Hook("cl_playhev", cl_playhev)

function GM:ShowTeam()
	if LocalPlayer():Team() == TEAM_SEEKERS then return end
	if ( !IsValid( TeamPanel ) ) then 
	
		TeamPanel = vgui.CreateFromTable( vgui_Splash )
		TeamPanel:SetHeaderText( "Choose Team" )

		local AllTeams = team.GetAllTeams()
		for ID, TeamInfo in SortedPairs ( AllTeams ) do
		
			if ( ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED && ( ID != TEAM_SPECTATOR || GAMEMODE.AllowSpectating ) && team.Joinable(ID) ) then
			
				if ( ID == TEAM_SPECTATOR ) then
					TeamPanel:AddSpacer( 10 )
				end
			
				local strName = TeamInfo.Name
				local func = function() RunConsoleCommand( "changeteam", ID ) end
			
				local btn = TeamPanel:AddSelectButton( strName, func )
				btn.m_colBackground = TeamInfo.Color
				btn.Think = function( self ) 
								self:SetText( Format( "%s (%i)", strName, team.NumPlayers( ID ) ))
								self:SetDisabled( GAMEMODE:TeamHasEnoughPlayers( ID ) ) 
							end
				
				if (  IsValid( LocalPlayer() ) && LocalPlayer():Team() == ID ) then
					btn:SetDisabled( true )
				end
				
			end
			
		end
		
		TeamPanel:AddCancelButton()
		
	end
	
	TeamPanel:MakePopup()

end
