
surface.CreateFont("AlphaFridgeMagnets ", ScreenScale(18), 500, true, false, "UCH_KillFont3");


local mats = {};

mats["suicide"] = surface.GetTextureID("UCH/killicons/pigsuicide");
mats["bite"] = surface.GetTextureID("UCH/killicons/chimera");
mats["press"] = surface.GetTextureID("UCH/killicons/pig");
mats["pop"] = surface.GetTextureID("UCH/killicons/pop");
mats["skull"] = surface.GetTextureID("UCH/killicons/skull");


local function ReceiveKillNotice(um)
	
	local tbl = {};
	
	local icon = um:ReadString();
	tbl.mat = mats[icon];
	
	local ent1 = um:ReadEntity();
	local ent2 = um:ReadEntity();
	
	tbl.time = CurTime();
	tbl.fadetime = (CurTime() + 6);
	tbl.ply1 = ent1:GetName();
	local r, g, b = ent1:GetRankColor();
	tbl.clr1 = Color(r, g, b, 255);
	
	if (ValidEntity(ent2)) then
		tbl.ply2 = ent2:GetName();
		local r, g, b = ent2:GetRankColor();
		tbl.clr2 = Color(r, g, b, 255);
	end
	
	table.insert(GAMEMODE.KillNotices, tbl);
	
end
usermessage.Hook("KillNotice", ReceiveKillNotice);


function GM:DrawKillNotice(k, v)
	
	local time = v.time;
	local fadetime = v.fadetime;
	local ply = v.ply1;
	local team1 = v.team1;
	local ply2 = "";
	local clr = v.clr1;
	if (v.ply2) then
		ply2 = v.ply2;
	end
	
	local alpha = 255;
	
	local t = (fadetime - 1);
	if (CurTime() >= t) then
		local calc = (CurTime() - t);
		alpha = (alpha * (1 - (calc / (fadetime - t))));
	end
	
	alpha = math.Clamp(alpha, 0, 255);
	
	local salpha = math.Clamp((alpha - 5), 0, 250);
	salpha = (alpha > 150 && salpha);
	
	local font = "UCH_KillFont3";
	
	surface.SetFont(font);
	local txtw, txth = surface.GetTextSize(ply);
	
	local x = (ScrW() * .98);
	local y = ((ScrH() * .02) - (txth * 1.1));
	
	y = (y + ((txth * 1.1) * k));
	
	v.y = (v.y || y);
	
	if (v.y != y) then
		
		local dis = math.abs((v.y - y));
		v.y = math.Approach(v.y, y, (FrameTime() * (dis * 5)));
		
	end
	
	clr.a = alpha;
	self:DrawNiceText(ply, font, x, v.y, clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, alpha);
	
	local h = ScreenScale(16);
	local w = h;
	
	local mat = v.mat;
	if (mat == mats["press"]) then
		w = (w * 2);
	end
	
	local subw = (w * .6);
	
	if (mat == mats["bite"]) then
		subw = (subw * 1.25);
	end
	
	x = ((x - txtw) - subw);
	surface.SetTexture(mat);
	surface.SetDrawColor(Color(255, 255, 255, alpha));
	surface.DrawTexturedRect((x - (w * .5)), v.y, w, h);
	
	if (ply2 != "") then
		x = (x - subw);
		local clr = v.clr2;
		clr.a = alpha;
		self:DrawNiceText(ply2, font, x, v.y, clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, alpha);
	end
	
	
end


function GM:DrawKillNotices()
	
	self.KillNotices = (self.KillNotices || {});
	
	for k, v in pairs(self.KillNotices) do
		
		if (CurTime() > v.fadetime) then
			table.remove(self.KillNotices, k);
		end
		
		self:DrawKillNotice(k, v);
		
	end
	
end
