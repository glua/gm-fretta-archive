
local ghosts = {};

local font = "TargetID";

local ghostmatL = surface.GetTextureID("UCH/scoreboard/ghostL");
local ghostmatR = surface.GetTextureID("UCH/scoreboard/ghostR");

local ghostmatwineL = surface.GetTextureID("UCH/scoreboard/ghost_wineL");
local ghostmatwineR = surface.GetTextureID("UCH/scoreboard/ghost_wineR");

local sw, sh = ScrW(), ScrH();

local PANEL = {};


function PANEL:Init()
	
end


function PANEL:UpdatePlayerData()
	
	local num, num2 = team.NumPlayers(GAMEMODE.TEAM_SPECTATE), team.NumPlayers(TEAM_UNASSIGNED);
	
	if ((num + num2) <= 0) then
		ghosts = {};
	end
	
	for k, v in pairs(team.GetPlayers(GAMEMODE.TEAM_SPECTATE)) do
		if (!table.HasValue(ghosts, v)) then
			table.insert(ghosts, v);
		end
	end
	
	for k, v in pairs(team.GetPlayers(TEAM_UNASSIGNED)) do
		if (!table.HasValue(ghosts, v)) then
			table.insert(ghosts, v);
		end
	end
	
	for k, v in pairs(ghosts) do
		
		if ((!ValidEntity(v) || v:Team() == GAMEMODE.TEAM_PIGS || v:Team() == GAMEMODE.TEAM_UC) && ghosts[k] != nil) then
			ghosts[k] = nil;
			return;
		else
		
			if (ValidEntity(v)) then
				if (!ghosts[k].pos) then
					ghosts[k].pos = math.random(0, sw);
				end
				if (!ghosts[k].dir) then
					ghosts[k].dir = (math.random(1, 2) == 1 && "left" || "right");
				end
				if (!ghosts[k].speed) then
					ghosts[k].speed = math.Rand(1.75, 2.5);
				end
				if (!ghosts[k].bob) then
					ghosts[k].bob = math.Rand(1.5, 3);
				end
			end
			
		end
		
	end
		
end


function PRINTGHOSTS()
	PrintTable(ghosts);
end


function PANEL:DrawGhost(x, y, k)
	
	local ply = ghosts[k];
	
	if (!ValidEntity(ply)) then
		return;
	end
	
	if (!ply.pos) then
		ply.pos = math.random(0, sw);
	end
	if (!ply.dir) then
		ply.dir = (math.random(1, 2) == 1 && "left" || "right");
	end
	if (!ply.speed) then
		ply.speed = math.Rand(1.75, 2.5);
	end
	if (!ply.bob) then
		ply.bob = math.Rand(1.5, 3);
	end
	
	local pos, dir = ply.pos, ply.dir;
	local speed = ((ply.speed * .2) * (sw / 640));
	local bob = ((ply.bob * .62) * (sw / 640));
	
	local max = (sw * .075);
	
	if (dir == "left") then
		
		if (pos < -max) then
			ply.dir = "right";
		else
			ply.pos = (pos - speed);
		end
		
	else
		
		if (pos > (sw + max)) then
			ply.dir = "left";
		else
			ply.pos = (pos + speed);
		end
		
	end
	
	local mat = (ply.dir == "left" && ghostmatwineL) || (ply.dir == "right" && ghostmatwineR);
	local w, h = (sh * .175), (sh * .175);
	
	if (ply:GetBodygroup(1) != 1) then
		mat = (ply.dir == "left" && ghostmatL) || (ply.dir == "right" && ghostmatR);
		w = (w * .5);
	end
	
	bob = math.sin((CurTime() * bob));
	local center = (self:GetTall() * .8);
	
	local x, y = (x + ply.pos), ((y + center) + (10 * bob));
	
	surface.SetTexture(mat);
	surface.SetDrawColor(255, 255, 255, 255);
	surface.DrawTexturedRectRotated(x, y, w, h, Color(255, 255, 255, 255), 0);
	
	if (ply:GetBodygroup(1) == 1) then
		local offset = (ScrH() * .0232);
		x = (x + ((dir == "left" && offset) || -offset));
	end
	
	local name = ply:GetName();
	draw.SimpleText(name, "TargetID", (x + 1), ((y - (h * .475)) + 1), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	draw.SimpleText(name, "TargetID", x, (y - (h * .475)), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	
end


function PANEL:Paint()
	return;
end


function PANEL:PaintStuff(x, y)
	
	if (#ghosts <= 0) then
		return;
	end
	
	for k, v in pairs(ghosts) do
		
		self:DrawGhost(x, y, k);
		
	end
	
end

vgui.Register("Ghosties", PANEL, "Panel");
