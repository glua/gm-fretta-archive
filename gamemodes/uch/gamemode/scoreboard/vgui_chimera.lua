
surface.CreateFont("twoson", ScreenScale(8), 400, true, false, "UCPlayerName");

local ranks = {};

local font = "TargetID";

local sw, sh = ScrW(), ScrH();

local PANEL = {};


function PANEL:Init()

	self.Player = nil;
	
	self.plyAvatar = vgui.Create("AvatarImage", self);
	
	self.plyName = vgui.Create("Label", self);
	self.plyPing = vgui.Create("Label", self);
	
	self.UCText = vgui.Create("Label", self);
	self.UCText:SetFont("UCPlayerName");
	self.UCText:SetText("Ultimate Chimera:");
	
	self.UCImage = vgui.Create("DImage", self);
	self.UCImage:SetImage("UCH/scoreboard/ultimate_chimera");
	
	self.VoteBtn = vgui.Create("DButton", self);
	self.VoteBtn:SetText("Vote New UC");
	
	function self.VoteBtn:DoClick()
		RunConsoleCommand("uch_vote");
	end
	function self.VoteBtn:Paint()
		
		local alpha = 80;
		if (!LocalPlayer():GetNWBool("UC_Voted", false) && !LocalPlayer():IsUC() && GAMEMODE:IsPlaying() && LocalPlayer():Team() == GAMEMODE.TEAM_PIGS) then
			alpha = 255;
		end
		
		local w, h = self:GetSize();
		
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, alpha));
		
		return;
		
	end
	
	self.plyName:SetFont(font);
	self.plyPing:SetFont("ScoreboardText");
	
end


function PANEL:SetPlayer(ply)

	self.Player = ply;
	self.plyAvatar:SetPlayer(ply);
	self:UpdatePlayerData();
	
end


function PANEL:UpdatePlayerData()
	
	if (self.Player == nil || !ValidEntity(self.Player)) then
		self:Remove();
		return;
	end
	
	local ply = self.Player;
	local name = tostring(ply:Name());
	local ping = tostring(ply:Ping());
	
	self.plyName:SetText(name);
	self.plyPing:SetText("Ping: " .. ping);
	
	self.VoteBtn:SetCursor(((LocalPlayer():GetNWBool("UC_Voted", false) || !GAMEMODE:IsPlaying()) && "arrow") || "hand");
	
	self:InvalidateLayout();
		
end


function PANEL:PerformLayout()

	local av, name, ping, uc, uctxt = self.plyAvatar, self.plyName, self.plyPing, self.UCImage, self.UCText;
	
	av:SizeToContents();
	name:SizeToContents();
	ping:SizeToContents();
	uctxt:SizeToContents();
	
	local ucsize = (self:GetTall() * 1.4);
	uc:SetSize(ucsize, ucsize);
	
	SetCenteredPosition(uc, (self:GetWide() * .25), (self:GetTall() * .5));
	
	local w, h = self:GetSize();
	
	SetCenteredPosition(name, (w * .75), (h * .5));
	
	
	local size = 32;
	size = (size / ScrH());
	
	av:SetWide((ScrH() * size));
	av:SetTall(av:GetWide());
	SetCenteredPosition(av, (name:GetPos() - (av:GetSize() * .6)), (h * .5));
	
	local x, _ = ((av:GetSize() * 1.4) + name:GetSize());
	local _, ny = name:GetPos();
	
	SetCenteredPosition(ping, (av:GetPos() + (x * .5)), (h * .675));
	
	SetCenteredPosition(uctxt, (av:GetPos() + (x * .5)), (ny - (uctxt:GetTall() * 1.1)));
	
	//self.VoteBtn:SetSize((w * .3), (h * .175));
	self.VoteBtn:SizeToContents();
	local vw, vh = self.VoteBtn:GetSize();
	self.VoteBtn:SetSize((vw * 1.25), (vh * 1.1));
	SetCenteredPosition(self.VoteBtn, (av:GetPos() + (x * .5)), (h * .85));

end


function PANEL:Paint()
	return;
end

vgui.Register("UCStatus", PANEL, "Panel");
