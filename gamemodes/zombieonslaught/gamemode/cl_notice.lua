
local HUDNote_c = 0
local HUDNote_i = 1
local HUDNotes = {}

local function AddNotify( msg )

	local text = msg:ReadString()
	local len = msg:ReadShort()
	local r = msg:ReadShort()
	local g = msg:ReadShort()
	local b = msg:ReadShort()

	MsgN( text or "Notice" )

	local tab = {}
	tab.text 	= text or "Notice"
	tab.recv 	= SysTime()
	tab.len 	= len 
	tab.velx	= -5
	tab.vely	= 0
	tab.x		= ScrW() + 200
	tab.y		= ScrH()
	tab.a		= 255
	tab.col	    = Color( r, g, b, 255 )
	
	table.insert( HUDNotes, tab )
	
	HUDNote_c = HUDNote_c + 1
	HUDNote_i = HUDNote_i + 1
	
end
usermessage.Hook( "Notice", AddNotify ) 

local function DrawNotice( self, k, v, i )

	local H = ScrH() / 1024
	local x = v.x - 20 * H 
	local y = v.y - 580 * H
	
	if ( !v.w ) then
		surface.SetFont( "ZONoticeText" )
		v.w, v.h = surface.GetTextSize( v.text )
	end
	
	local w = v.w
	local h = v.h
	w = w - 16
	h = h + 16
	
	draw.RoundedBox( 4, x - w - h + 8, y - 8, w + h, h, Color( 30, 30, 30, v.a * 0.75 ) )
	
	draw.SimpleTextOutlined( v.text, "ZONoticeText", x, y, v.col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 2, Color( 10, 10, 10, 255 ) )
	
	local ideal_y = ScrH() - ( HUDNote_c - i ) * ( h + 4 )
	local ideal_x = ScrW()
	
	local timeleft = v.len - ( SysTime() - v.recv )
	 
	//gone from screen
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
	
	//friction that is FPS independant
	v.velx = v.velx * (0.95 - RealFrameTime() * 8 )
	v.vely = v.vely * (0.95 - RealFrameTime() * 8 )

end

function PaintNotes()

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

hook.Add( "HUDPaint", "PaintNotes", PaintNotes )

