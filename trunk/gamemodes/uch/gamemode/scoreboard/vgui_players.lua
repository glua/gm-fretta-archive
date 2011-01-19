local sw, sh = ScrW(), ScrH();

local arrow = surface.GetTextureID("UCH/scoreboard/arrow");

local slidebdrclr = Color(50, 20, 20, 255);
local slideclr = Color(247, 217, 219, 255);

local PANEL = {};


function PANEL:Init()

	self.Players = {};
	
	self.List = vgui.Create("DPanelList", self);
	self.List:SetSpacing(2);
	self.List:EnableVerticalScrollbar(true);
	self.List:EnableHorizontal(false);
	
	function self.List:Paint()
		local w = self:GetWide();
		if (self.VBar && self.VBar:IsVisible()) then
			w = (w - self.VBar:GetWide());
		end
		draw.RoundedBox(10, 0, 0, w, self:GetTall(), Color(225, 175, 175, 255));
		return true;
	end
	
	local btnUp, btnDown = self.List.VBar.btnUp, self.List.VBar.btnDown;
	
	function self.List.VBar:Paint()
		return true;
	end
	
	
	local function paintBtn(btn, t)

		surface.SetDrawColor(255, 255, 255, 255);
		
		local num = 0;
		
		if (btn.Pressed) then
			num = .5;
			surface.SetDrawColor(200, 200, 200, 255);
		end
		
		local w, h = btn:GetSize();
		
		draw.RoundedBox(4, num, num, w, h, slidebdrclr);
		draw.RoundedBox(4, (2 + num), (2 + num), (w - (4 + num)), (h - (4 + num)), slideclr);
		
		surface.SetTexture(arrow);
		
		
		local rot = 0;
		if (t == "down") then
			rot = 180;
		end
		
		surface.DrawTexturedRectRotated((w * .5), (h * .5), ((w * .75) - (num * 2)), ((h * .75) - (num * 2)), rot);
		
	end
	
	function btnUp:Paint()
		paintBtn(self, "up");
		return true;
	end
	function btnUp:OnMousePressed(mc)
		if (mc == MOUSE_LEFT) then
			self.Pressed = true;
		end
	end
	function btnUp:OnMouseReleased(mc)
		if (mc == MOUSE_LEFT && self.Pressed) then
			self.Pressed = false;
			self:GetParent():AddScroll(-1);
		end
	end
	function btnUp:OnCursorExited()
		self.Pressed = false;
	end
	
	function btnDown:Paint()
		paintBtn(self, "down");
		return true;
	end
	function btnDown:OnMousePressed(mc)
		if (mc == MOUSE_LEFT) then
			self.Pressed = true;
		end
	end
	function btnDown:OnMouseReleased(mc)
		if (mc == MOUSE_LEFT && self.Pressed) then
			self.Pressed = false;
			self:GetParent():AddScroll(1);
		end
	end
	function btnDown:OnCursorExited()
		self.Pressed = false;
	end
	
	function self.List.VBar.btnGrip:Paint()
		
		local w, h = self:GetWide(), self:GetTall();
		
		draw.RoundedBox(4, 0, 0, w, h, slidebdrclr);
		draw.RoundedBox(4, 2, 2, (w - 4), (h - 4), slideclr);
		
		return true;
	end
	
end


function PANEL:RemovePlayers()
	self.List:Clear();
	self.Players = {};
end


function PANEL:UpdatePlayerData()
	
	if (!self:IsVisible() || !self.List:IsVisible()) then
		return;
	end
	
	self:RemovePlayers();
	
	local plys = self.Players;
	
	for k, v in pairs(player.GetAll()) do
		if (v:Team() == GAMEMODE.TEAM_PIGS && !v:IsSalsa()) then
		
			local bar = vgui.Create("UCPlayerBar", self.List);
			bar:SetPlayer(v);
			plys[v] = bar;
		
		end
	end
	
	self:InvalidateLayout();
	
end


function PANEL:PerformLayout()
	
	local w, h = self:GetSize();
	
	self.List:SetSize((w * .9), (h * .9));
	SetCenteredPosition(self.List, (w * .5), (h * .5));
	
	local list = self.Players;
	
	local sorted = {};
	for k, v in pairs(list) do
		table.insert(sorted, k);
	end
	
	table.sort(sorted, function(a, b)
		return (a:Frags() > b:Frags());
	end);
	
	for k, v in pairs(sorted) do

		self.List:AddItem(list[v]);
		
	end	
	
end


function PANEL:Paint()
	
	//draw pretty background for where players go
	
	
end


vgui.Register("UCPlayerList", PANEL, "Panel");
