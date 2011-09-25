
local hints = {} --Table containing all hints
local hints_c = 0
local hints_i = 1


//We use the cactus icon pos/size to base our hint position off of
iconPos = {}
iconSize = {}

//orange is Color( 255, 200, 50 )
local hintGradient = {
	--c1 = {r=0, g=0, b=0},	--black
	c1 = {r=255, g=200, b=50}, 	--orange
	c2 = {r=255, g=230, b=100},	--light yellow orange
	c3 = {r=255, g=240, b=175}, --yellow 
	c4 = {r=255, g=250, b=220}	--light yellow
}

surface.CreateFont ("coolvetica", ScreenScale(10), 400, true, false, "HintText") --scaled

function GM:AddCactusNotify(str, typ, length)

	local icon = LocalPlayer().Icon
	if !icon then return end
	
	local msg = {} --make it a table
	msg[1] = str --put str in it
	
	local longestline = "" --empty string
	local strw, strh = surface.GetTextSize(msg[1]) --make original text size
	
	local padding = strh --set our padding before strh is changed to hieght of all lines
	
	if string.Explode("\n", str)[1] then --see if we have line breaks
		msg = string.Explode("\n", str) --make our table again
	end
	
	for i=1,#msg do --for all of the lines
		if string.len(msg[i]) > string.len(longestline) then --see if its longer
			longestline = msg[i] --set our longest line
		end
	end
	
	strw, strh = surface.GetTextSize(longestline) --reset these values
	
	if #msg > 1 then --if we have more than 1 line
		strh = strh*#msg --reset hieght
	end
	
	local x,y,w,h --set up pos/size values
	
	iconPos.x, iconPos.y = icon:GetPos()
	iconSize.w, iconSize.h = icon:GetSize()
	
	//This is setting up pos/size of the hint bubble - the size is based on how much text we have, and the pos is based on the size
	
	//Set width and hieght - we use padding x2 so when we center it, it will have room on either side - hieght has a little extra added on so lines are not so tightly spaced
	w = strw+(padding*2)
	h = strh+(padding*2)+(#msg*3)
	
	//This is the size of the stub that leads to our cactus icon
	local stubsize = {
		w = (50),
		h = (80)
	}
	
	//We are using the upper right corner of the icon as a reference point
	x = iconPos.x + iconSize.w/4 --We are not using the upper-right corner because we want room for the hint bubble
	y = iconPos.y - h - (padding) --We add up the icon pos with our bubble's hieght and the stub hieght
	
	local tab = {}
	tab.Lines = #msg --number of lines
	tab.Text = msg --text table
	tab.Pos = {x=x,y=y} --our pos
	tab.Size = {w=w,h=h} --our size
	tab.StubSize = {w=stubsize.w,h=stubsize.h} --our stub size
	tab.Alpha = 255
	tab.recv 	= SysTime()
	tab.len 	= length
	tab.type	= typ
	
	table.insert(hints, tab)
	hints_c = hints_c+1

end

//Hint is added
//Make the whole hintbubble size increase and decrease (inflate/retract)
//If another hint is added, slide the previous one up above it to make room and so on
//Then give them the cartoonish leave thing off to the left whenever each of their go time is

local function DrawHints( v )
	
	local val = -255*FrameTime()
	
	local x,w,h = v.Pos.x, v.Size.w, v.Size.h
	local timeleft = v.len - (SysTime() - v.recv)
	local msg = v.Text
	
	if timeleft < 0.8 then
		v.Pos.y = v.Pos.y + val
	end
	if timeleft < 0.5 then
		v.Pos.y = v.Pos.y + val
		v.Alpha = v.Alpha + val
	end
	
	local y = y or v.Pos.y
	local alpha = alpha or v.Alpha
	
	//Draw hint box based on text size
	draw.RoundedBox( 8, x, y, w, h, Color(0, 0, 0, alpha) )
	
	//Positions used by poly
	local x2,y2 = (iconPos.x+iconSize.w), y+h
	
	//Set up the little triangle at the bottom of the hint box
	local verts = {}
	verts[1] = { x=x2, y=y2 } --upper left
	verts[2] = { x=x2+50, y=y2 } --upper right
	verts[3] = { x=x2, y=y2+50 } --bottom
	//(x2, y2+50) is the pos that needs to be next to cactus
	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, alpha ) --set the additive color
	surface.DrawPoly( verts ) --draw the triangle with our triangle table
	
	for i=1,table.Count(hintGradient) do
		
		local add = i*4
		local add2 = i*2
		local t_col = hintGradient["c"..i]
		draw.RoundedBox( 6, x+add/2, y+add/2, w-add, h-add, Color(t_col.r, t_col.b, t_col.g, alpha) )
		
		surface.SetDrawColor( t_col.r, t_col.b, t_col.g, alpha ) --set the additive color
		verts[1] = { x = x2+add2, y = y2-add/2 } --upper left
		verts[2] = { x = x2+50-add2, y = y2-add/2 } --upper right
		verts[3] = { x = x2+add2, y = y2+50-add/2-add2 } --bottom
		draw.NoTexture()
		surface.DrawPoly( verts ) --draw the triangle with our triangle table
		
		if i == table.Count(hintGradient) then
			//Draw message
			if msg[2] != nil then
				local lines = table.Count(msg)
				for n=1,lines do --for each line break
					local str_w, str_h = surface.GetTextSize(msg[n])
					
					local lineY = (str_h+5) --line difference
					local lineSY = lineY*lines --total size of lines
					
					local startY = y+(h/2)-(lineSY)
					
					local posY = startY+lineY*n
					
					--Draw outlined text
					draw.SimpleTextOutlined( msg[n], "HintText",  x+w/2, posY, Color(0,0,0,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(255,255,255,alpha) )
				end
			else
				draw.SimpleTextOutlined( msg[1], "HintText",  x+w/2, y+h/2, Color(0,0,0,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(255,255,255,alpha) )
			end
		end
		
	end
	
end

//Basically ripped from cl_notice - but with a few modifications
function GM:PaintHints()
	
	if !hints then return end
	
	for k, v in pairs( hints ) do
	
		if ( v != 0 ) then
		
			DrawHints(v)		
		
		end
		
	end
	
	for k, v in pairs( hints ) do
	
		if ( v != 0 && v.recv + v.len < SysTime() ) then
		
			hints[ k ] = 0
			hints_c = hints_c - 1
			
			if (hints_c == 0) then hints = {} end
		
		end

	end

end
