CreateClientConVar("cl_gtv_radaropacity",100,true,false)

local tex = surface.GetTextureID("gtv/radararrow")

local hw = ScrW()/2 --half width
local hh = ScrH()/2 --half height

local EDGE_RIGHT = 0
local EDGE_TOP = 1
local EDGE_LEFT = 2
local EDGE_BOTTOM = 3

local CORNER_UR = math.Rad2Deg(math.atan2(hh,hw))%360
local CORNER_UL = math.Rad2Deg(math.atan2(hh,-hw))%360
local CORNER_LL = math.Rad2Deg(math.atan2(-hh,-hw))%360
local CORNER_LR = math.Rad2Deg(math.atan2(-hh,hw))%360

local function GetDirection(x,y)
	return (-1*math.Rad2Deg(math.atan2(y-hh,x-hw)))%360
end

local function GetEdge(dir,x,y)
	dir = dir%360
	if (dir <= CORNER_UR) || (dir >= CORNER_LR) then
		return EDGE_RIGHT
	elseif (dir >= CORNER_UR) && (dir <= CORNER_UL) then
		return EDGE_TOP
	elseif (dir >= CORNER_UL) && (dir <= CORNER_LL) then
		return EDGE_LEFT
	else
		return EDGE_BOTTOM
	end
end

local function GetScaleFactor(edge,x,y)
	if edge == EDGE_RIGHT then
		return hw/(x-hw)
	elseif edge == EDGE_TOP then
		return hh/(hh-y)
	elseif edge == EDGE_LEFT then
		return hw/(hw-x)
	else
		return hh/(y-hh)
	end
end

local function GetScreenPos(scalefactor,x,y)
	x = x-hw
	y = y-hh
	return x*scalefactor+hw,y*scalefactor+hh
end

--mockup hook
--[[
	local pos = v:GetPos():ToScreen()
	local dir = GetDirection(pos.x,pos.y)
	local edge = GetEdge(dir,pos.x,pos.y)
	local scalefactor = GetScaleFactor(edge,pos.x,pos.y)
	pos.x,pos.y = GetScreenPos(scalefactor,pos.x,pos.y)
]]--

local ARROW_WIDTH = 64
local ARROW_HEIGHT  = 20

function GM:DrawPlayerOnRadar(pl)
	local pos = pl:GetPos():ToScreen()
	if (pos.x > 0) && (pos.x < ScrW()) && (pos.y > 0) && (pos.y < ScrH()) && pl:Alive() && !pl:IsObserver() then
		return
	end
	local col = list.GetForEdit("PlayerColours")[pl:GetNWString("pl_color")]||color_white
	local dir = GetDirection(pos.x,pos.y)
	local edge = GetEdge(dir,pos.x,pos.y)
	local scalefactor = GetScaleFactor(edge,pos.x,pos.y)
	pos.x,pos.y = GetScreenPos(scalefactor,pos.x,pos.y)
	surface.SetTexture(tex)
	surface.SetDrawColor(col.r,col.g,col.b,GetConVarNumber("cl_gtv_radaropacity"))
	surface.DrawTexturedRectRotated(pos.x-math.cos(math.Deg2Rad(dir))*ARROW_WIDTH/2,pos.y+math.sin(math.Deg2Rad(dir))*ARROW_WIDTH/2,ARROW_WIDTH,ARROW_HEIGHT,dir)
end