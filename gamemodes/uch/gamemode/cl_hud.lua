
include("cl_targetid.lua")

local sw, sh = ScrW(), ScrH();

local xhairtex = surface.GetTextureID("UCH/hud_pig_crosshair");
local glass = surface.GetTextureID("UCH/ghost_glass");

local function TextSize(font, txt)
	surface.SetFont(font);
	local w, h = surface.GetTextSize(txt);
	return {w, h};
end

function GM:DrawNiceText(txt, font, x, y, clr, alignx, aligny, dis, alpha)
	
	local tbl = {};
	tbl.pos = {};
	tbl.pos[1] = x;
	tbl.pos[2] = y;
	tbl.color = clr;
	tbl.text = txt;
	tbl.font = font;
	tbl.xalign = alignx;
	tbl.yalign = aligny;
	
	draw.TextShadow(tbl, dis, alpha);
	
end

local function DrawNiceBox(x, y, w, h, clr, dis)

	local clr2 = Color(clr.r, clr.g, clr.b, (clr.a * .5));
	
	draw.RoundedBox(4, (x - dis), (y - dis), (w + (dis * 2)), (h + (dis * 2)), clr);
	draw.RoundedBox(2, x, y, w, h, clr2);
	
end


local function DrawInfoBox(txt, x, y)
	
	local dis = (y * .05);
	local bob = math.sin((CurTime() * 4));
	
	y = (y + (dis * bob));
	
	local tsize = TextSize("TargetID", txt);
	local tw, th = tsize[1], tsize[2];
	DrawNiceBox((x - (tw * .6)), (y - (th * .6)), (tw * 1.2), (th * 1.2), Color(10, 10, 10, 125), 4);
	
	GAMEMODE:DrawNiceText(txt, "TargetID", x, y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, 200);
	
end


local function DrawCrosshair()
	
	local ply = LocalPlayer();
	local xalpha = 100;
	
	ply.XHairAlpha = (ply.XHairAlpha || xalpha);
	local alpha = ply.XHairAlpha;
	
	if (alpha != xalpha) then
		ply.XHairAlpha = math.Approach(ply.XHairAlpha, xalpha, (FrameTime() * 150));
	end
	
	local r, g, b = ply:GetRankColor();
	
	if (ply:IsSalsa()) then
		r, g, b = 200, 120, 100;
	end
	if (ply:IsGhost()) then
		r, g, b = 250, 250, 250;
	end
	
	local clr = Color(r, g, b, alpha);
	
	surface.SetTexture(xhairtex);
	surface.SetDrawColor(clr);
	surface.DrawTexturedRectRotated((sw * .5), (sh * .5), (sh * .04), (sh * .04), 0);
	
	if (ply:IsGhost() && ply:GetBodygroup(1) == 1) then
		
		surface.SetTexture(glass);
		surface.SetDrawColor(Color(255, 255, 255, 160));
		surface.DrawTexturedRectRotated((sw * .515), (sh * .5), (sh * .028), (sh * .028), -12);
		
	end
	
end


local xx, yy, ww, hh = .28, .2725, .375, .12;

local function CCXX(ply, cmd, args)
	xx = tonumber(args[1]);
end
concommand.Add("xx", CCXX);

local function CCYY(ply, cmd, args)
	yy = tonumber(args[1]);
end
concommand.Add("y", CCYY);

local function CCWW(ply, cmd, args)
	ww = tonumber(args[1]);
end
concommand.Add("ww", CCWW);

local function CCHH(ply, cmd, args)
	hh = tonumber(args[1]);
end
concommand.Add("hh", CCHH);


local pigmat = surface.GetTextureID("UCH/hud/pighud");
local pigCmat = surface.GetTextureID("UCH/hud/pighudc");
local pigEmat = surface.GetTextureID("UCH/hud/pighude");
local ucmat = surface.GetTextureID("UCH/hud/chimerahud");

function GM:DrawHUD()
	
	local ply = LocalPlayer();
	
	local mat = pigmat;
	
	if (ply:IsUC()) then
		
		mat = ucmat;
		
		local h = (sh * .285);
		local w = (h * 2);
		
		local x, y = (sw * -.0385), (sh * .732);
		
		local spx, spy = (x + (w * .285)), (y + (h * .58));
		local spw, sph = (w * .505), (h * .145);
		self:DrawSprintBar(spx, spy, spw, sph);
		
		local rrx, rry = (x + (w * .2825)), (y + (h * .43));
		local rrw, rrh = (w * .3775), (h * .115);
		self:DrawRoarMeter(rrx, rry, rrw, rrh);
		
		local tsx, tsy = (x + (w * .28)), (y + (h * .2725));
		local tsw, tsh = (w * .375), (h * .12);
		self:DrawSwipeMeter(tsx, tsy, tsw, tsh);
		
		surface.SetTexture(ucmat);
		surface.SetDrawColor(Color(255, 255, 255, 255));
		surface.DrawTexturedRect(x, y, w, h);
		
	else
	
		if (ply:IsGhost()) then
			return;
		end
		
		local h = (sh * .14);
		local w = (h * 4);
		
		local x, y = (sw * -.035), (sh * .85);
		
		local spx, spy = (x + (w * .286)), (y + (h * .35));
		local spw, sph = (w * .51), (h * .275);
		self:DrawSprintBar(spx, spy, spw, sph);
		
		local r, g, b = ply:GetRankColorSat();
		
		if (ply:GetRank() == "Colonel") then
			mat = pigCmat;
		end
		if (ply:GetRank() == "Ensign") then
			mat = pigEmat;
		end
		
		surface.SetTexture(mat);
		surface.SetDrawColor(Color(r, g, b, 255));
		surface.DrawTexturedRect(x, y, w, h);
		
	end
	
end


function GM:HUDPaint()
	
	local ply = LocalPlayer();
	
	//Draw HUD here!
	
	local txt = nil;
	
	if (self:GetState() == self.STATE_WAITING) then
		
		txt = "Waiting for players...";
		
	end
	
	if (self:GetState() == self.STATE_COUNTDOWN) then
		
		txt = "Starting...";
		
	end
	
	if (txt != nil) then
		DrawInfoBox(txt, (sw * .5), (sh * .185));
	end
	
	if (((ply:Alive() && ply:Team() == self.TEAM_PIGS) || ply:IsGhost() || ply:IsSalsa()) && !ply:IsTaunting() && !ply:IsScared()) then
		DrawCrosshair();
	end
	
	self:DrawHUD();
	
	/*if (!ply:IsGhost()) then
		self:DrawSprintBar();
	end
	
	if (ply:IsUC() && ply:Alive()) then
		self:DrawRoarMeter();
		self:DrawSwipeMeter();
	end*/
	
	self:DrawKillNotices();
	self:DrawTargetID();
	self:DrawRoundTime();
	
	//self.BaseClass:HUDPaint();
	
end

function GM:HUDShouldDraw(name)

	local hud = {
		"CHudHealth",
		"CHudBattery",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudCrosshair",
		"CHudWeapon"
	};
	
	for _, v in ipairs(hud) do
		if (name == v) then
			return false;
		end
	end
	
	return true;
	
end
