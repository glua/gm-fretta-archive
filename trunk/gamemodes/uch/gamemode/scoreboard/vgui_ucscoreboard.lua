
local function PaintFrame(frame)
	
	local x, y = frame:GetPos(); //this doesnt really matter why is this here... it starts at 0, 0
	local w, h = frame:GetSize();
	
	local x1, y1 = 0, (h * .12); //position of the background
	local w1, h1 = w, (h * .88); //size of the background
	
	local r, g, b = 164, 90, 122;
	draw.RoundedBox(12, x1, y1, w1, h1, Color(r, g, b, 255)); //rounded background
	draw.RoundedBox(0, x1, y1, w1, (h1 * .04), Color(r, g, b, 255)); //unround the top
	draw.RoundedBox(0, x1, y1, w1, (h1 * .04), Color((r * .4), (g * .4), (b * .4), 150)); //darken a bar for the server name
	
	local r, g, b = 115, 75, 75;
	draw.RoundedBox(12, 0, 0, w1, (h * .12), Color(r, g, b, 255)); //logo/salsa bar
	draw.RoundedBox(0, 0, (h * .1), w1, (h * .025), Color(r, g, b, 255)); //unround the bottom
	
	local list = frame:GetParent().PlayerList;
	local x, y = list:GetPos();
	local w, h = list:GetSize();
	
	local thick = (ScrH() * .02);
	thick = -thick;
	draw.RoundedBox(8, (x - thick), (y - thick), (w + (thick * 2)), (h + (thick * 2)), Color(50, 20, 20, 255));
	
end




local sw, sh = ScrW(), ScrH();

local PANEL = {};


function PANEL:Init()
	
	timer.Create("UpdateScoreboard", 1, 0, self.UpdateScoreboard, self);
	
	self.Ghosts = vgui.Create("Ghosties", self);
	
	self.Frame = vgui.Create("DPanel", self);
	function self.Frame:Paint()
		//draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 250));
		PaintFrame(self);
	end
	
	self.Logo = vgui.Create("DPanel", self);
	function self.Logo:Paint()
		GAMEMODE:DrawLogo((self:GetWide() * .5), (self:GetTall() * .5), .68);
	end
	
	
	self.ServerName = vgui.Create("Label", self.Frame);
	self.ServerName:SetText(GetHostName());
	self.ServerName:SetFont("Trebuchet22");
	
	self.ScoreTxt = vgui.Create("Label", self.Frame);
	self.ScoreTxt:SetText("Score");
	
	self.DeathTxt = vgui.Create("Label", self.Frame);
	self.DeathTxt:SetText("Deaths");
	
	self.PingTxt = vgui.Create("Label", self.Frame);
	self.PingTxt:SetText("Ping");
	
	self.RankTxt = vgui.Create("Label", self.Frame);
	self.RankTxt:SetText("Rank");
	
	self.RebuildBtn = vgui.Create("DButton", self);
	self.RebuildBtn:SetText("Rebuild Scoreboard");
	function self.RebuildBtn:DoClick()
		LocalPlayer().Scoreboard:Remove();
		LocalPlayer().Scoreboard = nil;
		GAMEMODE:CreateScoreboard();
		timer.Simple(0, LocalPlayer().Scoreboard.UpdateScoreboard, LocalPlayer().Scoreboard);
	end
	
	self.MapName = vgui.Create("UCMapName", self);
	
	self:CreatePlayerList();

end



function PANEL:PerformLayout()

	self:SetPos(0, 0);
	self:SetSize(sw, sh);
	
	local x, y = self:GetPos();
	local w, h = self:GetSize();
	
	self.Frame:SetSize((h * .6), (h * .75));
	SetCenteredPosition(self.Frame, (w * .5), (h * .5));
	
	local x, y = self.Frame:GetPos();
	local w, h = self.Frame:GetSize();
	
	if (self.UCStatus != nil) then
		self.UCStatus:SetPos(0, (h * .8));
		self.UCStatus:SetSize(w, (h * .2));
	end
		
	self.RebuildBtn:SizeToContents();
	self.RebuildBtn:SetSize((self.RebuildBtn:GetWide() * 1.32), (self.RebuildBtn:GetTall() * 1.5));
	self.RebuildBtn:SetPos(x, ((y + h) + (self.RebuildBtn:GetTall() * .5)));
	
	self.MapName:SetPos(((x + w) - self.MapName:GetWide()), (y + (h * 1.01)));

	
	local gy = (y + (h * .95));
	self.Ghosts:SetPos(0, gy);
	self.Ghosts:SetSize(sw, (sh - gy));
	
	
	local plisth = (self.UCStatus != nil && .645) || .645;
	
	self.PlayerList:SetSize((w * .9), (h * plisth));
	self.PlayerList:SetPos(((w * .5) - (self.PlayerList:GetWide() * .5)), (h * .16));
	
	self.PlayerList:InvalidateLayout();
	
	self.ServerName:SizeToContents();
	SetCenteredPosition(self.ServerName, (w * .5), (h * .14));
	
	local logox = (x + (w * .5));
	
	if (self.SalsaStatus) then  //salsa
		self.SalsaStatus:SetPos((w * .5), 0);
		self.SalsaStatus:SetSize((w * .5), (h * .16));
		logox = (x + (w * .2));
	end
	
	self.Logo:SetSize((sw * .42), (sh * .42));
	SetCenteredPosition(self.Logo, logox, (y + (h * .028)));
	
	local x, y = self.PlayerList:GetPos();
	local w, h = self.PlayerList:GetSize();
	
	local num = .42;
	
	SetCenteredPosition(self.ScoreTxt, (x + (w * .632)), (y + (self.ScoreTxt:GetTall() * num)));
	SetCenteredPosition(self.DeathTxt, (x + (w * .732)), (y + (self.DeathTxt:GetTall() * num)));
	SetCenteredPosition(self.PingTxt, (x + (w * .832)), (y + (self.PingTxt:GetTall() * num)));
	SetCenteredPosition(self.RankTxt, (x + (w * .932)), (y + (self.RankTxt:GetTall() * num)));
	
	/*if (!self.UCStatus) then
		self.Frame:SetSize(w, (h - (h * .1)));
	end*/
	
end


function PANEL:CreatePlayerList()
	
	if (self.PlayerList) then
		self.PlayerList:RemovePlayers();
		self.PlayerList:Remove();
	end
	
	self.PlayerList = vgui.Create("UCPlayerList", self.Frame);
	self.PlayerList:RequestFocus();
	
end


function PANEL:UpdateScoreboard()
	
	if (!self:IsVisible()) then
		return;
	end
	
	local plys = self.PlayerList;
	if (plys) then
		plys:UpdatePlayerData();
	end
	
	local ghosts = self.Ghosts;
	if (ghosts) then
		ghosts:UpdatePlayerData();
	end
	
	local uc = self.UCStatus;
	if (uc) then
		if (!ValidEntity(GAMEMODE:GetUC())) then
			uc:Remove();
			self.UCStatus = nil;
		else
			uc:SetPlayer(GAMEMODE:GetUC());
			uc:UpdatePlayerData();
		end
	else
		if (ValidEntity(GAMEMODE:GetUC())) then
			
			self.UCStatus = vgui.Create("UCStatus", self.Frame);
			self.UCStatus:SetPlayer(GAMEMODE:GetUC());
			
		end
	end
	
	local salsa = self.SalsaStatus;
	if (salsa) then
		if (!ValidEntity(GAMEMODE:GetSalsa())) then
			salsa:Remove();
			self.SalsaStatus = nil;
		else
			salsa:SetPlayer(GAMEMODE:GetSalsa());
			salsa:UpdatePlayerData();
		end
	else
		if (ValidEntity(GAMEMODE:GetSalsa())) then
			
			self.SalsaStatus = vgui.Create("SalsaStatus", self.Frame);
			self.SalsaStatus:SetPlayer(GAMEMODE:GetSalsa());
			
		end
	end
	
	self:InvalidateLayout();
	
end


function PANEL:Paint()
	
	//local w, h = self:GetSize();
	//draw.RoundedBox(4, 0, 0, w, h, Color(200, 200, 200, 100));
	
	local x, y = self.Ghosts:GetPos();
	self.Ghosts:PaintStuff(x, y);
	
	local frame = self.Frame;
	
	local x, y = frame:GetPos(); //this doesnt really matter why is this here... it starts at 0, 0
	local w, h = frame:GetSize();
	
	local size = 2;
	draw.RoundedBox(12, (x - size), (y - size), (w + (size * 2)), (h + (size * 2)), Color(80, 40, 40, 250));
	
end

vgui.Register("UCScoreboard", PANEL, "Panel");

