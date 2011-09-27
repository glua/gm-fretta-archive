points = 0
surface.CreateFont( "ChatFont", 40, 400, true, false, "BigChatFont" )
function CurrentBoxes()
	local color = team.GetColor(LocalPlayer():Team())
	local r = color.r
	local g = color.g
	local b = color.b
	if(LocalPlayer():Team() != TEAM_UNASSIGNED) and (LocalPlayer():Team() != TEAM_SPECTATOR)then
		size = 250
	else
		size = 350
	end
	draw.RoundedBoxEx( 6, 0, 10, size, 48, Color(r, g, b, 100), false, true, false, true )
	struc = {}
	struc["pos"] = {4, 14}
	struc["color"] = Color(255, 255, 255, 240)
	if(LocalPlayer():Team() != TEAM_UNASSIGNED) and (LocalPlayer():Team() != TEAM_SPECTATOR)then
		struc["text"] = "Box Points: " .. tostring(points)
	else
		struc["text"] = "Press F1, Pick A Team"
	end
	struc["font"] = "BigChatFont"
	struc["xalign"] = TEXT_ALIGN_LEFT
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.TextShadow( struc, 2, 160 )
end
hook.Add("HUDPaint","CurrentBoxes",CurrentBoxes)

function SetPoints(data)
	points = data:ReadLong()
	if(LocalPlayer():IsValid())then LocalPlayer():SetNetworkedInt( "Points", points ) end
end
usermessage.Hook( "SetPoints", SetPoints );