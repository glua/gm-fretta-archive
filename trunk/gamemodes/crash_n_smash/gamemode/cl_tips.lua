
// Based on the cl_notice.lua from the sandbox gamemode

local NoticeMaterial = {}
NoticeMaterial[ NOTIFY_GENERIC ] 	= surface.GetTextureID( "vgui/notices/generic" )
NoticeMaterial[ NOTIFY_ERROR ] 		= surface.GetTextureID( "vgui/notices/error" )
NoticeMaterial[ NOTIFY_UNDO ] 		= surface.GetTextureID( "vgui/notices/undo" )
NoticeMaterial[ NOTIFY_HINT ] 		= surface.GetTextureID( "vgui/notices/hint" )
NoticeMaterial[ NOTIFY_CLEANUP ] 	= surface.GetTextureID( "vgui/notices/cleanup" )

local HUDNote_c = 0
local HUDNote_i = 1
local HUDNotes = {}

function GM:AddNotify( str, type, length )

	local tab = {}
	tab.text 	= str
	tab.recv 	= SysTime()
	tab.len 	= length
	tab.velx	= -5
	tab.vely	= 0
	tab.x		= ScrW() + 200
	tab.y		= ScrH()
	tab.a		= 255
	tab.type	= type
	
	table.insert( HUDNotes, tab )
	
	HUDNote_c = HUDNote_c + 1
	HUDNote_i = HUDNote_i + 1
	
end


local function DrawNotice( self, k, v, i )

	local H = ScrH() / 1024
	local x = v.x - 75 * H
	local y = v.y - 300 * H
	
	if ( !v.w ) then
		surface.SetFont( "Tips" )
		v.w, v.h = surface.GetTextSize( v.text )
	end
	
	local w = v.w
	local h = v.h
	
	w = w + 16
	h = h + 16

	draw.RoundedBox( 4, x - w - h + 8, y - 8, w + h, h, Color( 30, 30, 30, v.a * 0.4 ) )
	
	// Draw Icon
	surface.SetDrawColor( 255, 255, 255, v.a )
	surface.SetTexture( NoticeMaterial[ v.type ] )
	surface.DrawTexturedRect( x - w - h + 16, y - 4, h - 8, h - 8 ) 

	draw.SimpleText( v.text, "Tips", x+1, y+1, Color(0,0,0,v.a*0.8), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Tips", x-1, y-1, Color(0,0,0,v.a*0.5), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Tips", x+1, y-1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Tips", x-1, y+1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Tips", x, y, Color(255,255,255,v.a), TEXT_ALIGN_RIGHT )
	
	local ideal_y = ScrH() - (HUDNote_c - i) * (h + 4)
	local ideal_x = ScrW()
	
	local timeleft = v.len - (SysTime() - v.recv)
	
	// Cartoon style about to go thing
	if ( timeleft < 0.8  ) then
		ideal_x = ScrW() - 50
	end
	 
	// Gone!
	if ( timeleft < 0.5  ) then
		ideal_x = ScrW() + w * 2
	end
	
	local spd = RealFrameTime() * 15
	
	v.y = v.y + v.vely * spd
	v.x = v.x + v.velx * spd
	
	local dist = ideal_y - v.y
	v.vely = v.vely + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
	local dist = ideal_x - v.x
	v.velx = v.velx + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
	
	// Friction.. kind of FPS independant.
	v.velx = v.velx * (0.95 - RealFrameTime() * 8 )
	v.vely = v.vely * (0.95 - RealFrameTime() * 8 )

end


function GM:PaintTips()

	if ( !HUDNotes ) then return end
		
	local i = 0
	for k, v in pairs( HUDNotes ) do
		if ( v != 0 ) then
			i = i + 1
			DrawNotice( self, k, v, i)		
		end
	end
	
	for k, v in pairs( HUDNotes ) do
		if ( v != 0 && v.recv + v.len < SysTime() ) then
			HUDNotes[ k ] = 0
			HUDNote_c = HUDNote_c - 1
			if (HUDNote_c == 0) then HUDNotes = {} end
		end
	end

end

