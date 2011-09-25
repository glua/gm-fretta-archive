local gtvcol = Color(53,157,211,255)
local gtvcol2 = Color(204,235,255,255)
local x_anchor_score = 0
local x_anchor_deaths = 0
local x_anchor_ping = 0

function SplitString(str,pos)
	return string.Left(str,pos),string.Right(str,string.len(str)-pos)
end

function NumberToStringWithSeparators(num)
	local decimalpos = string.find(num,"%.") --if it finds a decimal part then remove that and reappend it when we're done
	local appendback
	local appendfront
	if decimalpos then
		num,appendback = SplitString(num,decimalpos)
	end
	if string.find(num,"-") then
		appendfront,num = SplitString(num,string.find(num,"-"))
	end
	local length = string.len(num)
	local numcommas = math.floor(length/3)
	for i=1,length-1 do
		if i%3 == 0 then
			local l,r = SplitString(num,length-i)
			num = l..","..r
		end
	end
	if appendback then
		num = num..appendback
	end
	if appendfront then
		num = appendfront..num
	end
	return num
end

local PANEL = {}

function PANEL:Init()
	self.rank = 1
	self.LastUpdate = CurTime()
	self.ColorRect = vgui.Create("PlayerColorRect",self)
	self.ColorRect:SetSize(36,32)
	self.Icon = vgui.Create("AvatarImage",self.ColorRect)
	self.Name = vgui.Create("DLabel",self)
		self.Name:SetFont("CV24")
		self.Name:SetTextColor(color_white)
		self.Name:SetPos(38,4)
	self.Score = vgui.Create("DLabel",self)
		self.Score:SetFont("CV24")
		self.Score:SetTextColor(color_white)
		self.Score:SetPos(38,4)
	self.Deaths = vgui.Create("DLabel",self)
		self.Deaths:SetFont("CV24")
		self.Deaths:SetTextColor(color_white)
		self.Deaths:SetPos(38,4)
	self.Ping = vgui.Create("DLabel",self)
		self.Ping:SetFont("CV24")
		self.Ping:SetTextColor(color_white)
		self.Ping:SetPos(38,4)
	self.Player = NULL
	self:SetTall(32)
end

function PANEL:SetPlayer(pl)
	self.ColorRect:SetPlayer(pl)
	self.Icon:SetPlayer(pl)
	self.Player = pl
	self.Name:SetText(pl:Nick())
	self.Name:SizeToContents()
	pl.ScoreboardPanel = self
end

function PANEL:GetPlayer()
	return self.Player
end

function PANEL:Think()
	if self.LastUpdate+0.5 < CurTime() then
		self:UpdatePlayerInfo()
		self.LastUpdate = CurTime()
	end
end

function PANEL:UpdatePlayerInfo()
	if self.Player:IsValid() then
		self.Name:SetText(self.Player:Nick())
		self.Score:SetText(NumberToStringWithSeparators(self.Player:Frags()))
		self.Deaths:SetText(self.Player:Deaths())
		self.Ping:SetText(self.Player:Ping())
		
		self.Score:SizeToContents()
		self.Deaths:SizeToContents()
		self.Ping:SizeToContents()
		
		self.Score.x = x_anchor_score-self.Score:GetWide()
		self.Deaths.x = x_anchor_deaths-self.Deaths:GetWide()
		self.Ping.x = x_anchor_ping-self.Ping:GetWide()
		self.Name:SetWide(self.Score.x-32-32)
	end
end	

/*
function PANEL:Paint()
	if self.Player:IsValid() then
		//local col = list.GetForEdit("PlayerColours")[self.Player:GetNWString("pl_color")]	
		surface.SetDrawColor(gtvcol2.r,gtvcol2.g,gtvcol2.b,255)
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end
end
*/

function PANEL:PerformLayout()
	self:SetWide(self:GetParent():GetWide())
	self:UpdatePlayerInfo()
end

vgui.Register("gtv_scoreboard_playerpanel",PANEL)








local PANEL = {} --PlayerColorRect, draws a colored rect based on the player it is assigned
	function PANEL:Init()
		self.player = NULL
	end
	
	function PANEL:SetPlayer(pl)
		self.player = pl
	end
	
	function PANEL:GetPlayer()
		return self.player
	end
	
	function PANEL:Paint()
		local col
		if self.player:IsValid() then
			col = list.GetForEdit("PlayerColours")[self.player:GetNWString("pl_color")]||color_black
		else
			col = color_white
		end
		local add = math.abs(math.cos(CurTime()))*50
		surface.SetDrawColor(col.r+add,col.g+add,col.b+add,255)
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end
	
	vgui.Register("PlayerColorRect",PANEL)
	
local PANEL = {}
	function PANEL:Init()
		self.LastUpdate = CurTime()
		self.panels = {}
	end
	
	function PANEL:Think()
		if self.LastUpdate+0.5 < CurTime() then
			self:SortPlayers()
			self.LastUpdate = CurTime()
		end
	end
	
	function PANEL:Paint()
		surface.SetDrawColor(gtvcol.r,gtvcol.g,gtvcol.b,255)
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	function PANEL:SetupPlayers()
		local players = team.GetPlayers(TEAM_UNASSIGNED)
		for k,v in ipairs(players) do
			self:AddPlayer(v,true)
		end
		self:SortPlayers()
	end
	
	function PANEL:AddPlayer(pl,shouldnotsort)
		for k,v in ipairs(self.panels) do --don't add the player if they're already in the list
			if v:GetPlayer() == pl then
				return
			end
		end
		local p = vgui.Create("gtv_scoreboard_playerpanel",self)
		p:SetWide(self:GetWide())
		p:SetPlayer(pl)
		table.insert(self.panels,p)
		if !shouldnotsort then
			self:SortPlayers()
		end
		self:UpdateHeight()
	end
	
	function PANEL:RemovePlayer(pl,shouldnotsort)
		local panels = self.panels
		for k,v in ipairs(panels) do
			if v:GetPlayer() == pl then
				v:Remove()
				table.remove(panels,k)
				break
			end
		end
		if !shouldnotsort then
			self:SortPlayers()
		end
		self:UpdateHeight()
	end
	
	function PANEL:CleanUpPlayers()
		local numslots = #self.panels
		for i=0,numslots do
			local p = self.panels[numslots-i]
			if p &&
			(((p:GetPlayer() == NULL) || !p:GetPlayer():IsValid())
			|| (p:IsValid() && p:GetPlayer():Team() == TEAM_SPECTATOR)) then		
				table.remove(self.panels,numslots-i)
				p:Remove()
			end
		end
		self:SortPlayers()
		self:UpdateHeight()
	end
	
	function PANEL:SortPlayers()
		local didswap = true
		while (didswap) do
			didswap = false
			for k,v in ipairs(self.panels) do --fastest way I could think of doing it, iterate through the table and if the score below the current panel is higher then swap the panels, continue until a loop without swaps. If nothing's changed, it will only do one iteration.
				if self.panels[k+1] && (v:GetPlayer():Frags() < self.panels[k+1]:GetPlayer():Frags()) then
					self.panels[k],self.panels[k+1] = self.panels[k+1],self.panels[k]
					self.panels[k].rank = k
					self.panels[k+1].rank = k+1
					didswap = true
					break
				end
			end
		end
		for i=1,#self.panels do
			self.panels[i].y = (i-1)*32
		end
	end
	
	function PANEL:PerformLayout()
		for k,v in ipairs(self.panels) do
			v:PerformLayout()
		end
		self:UpdateHeight()
	end
	
	function PANEL:UpdateHeight()
		self:SetTall(math.max(self:GetParent():GetTall(),table.getn(self.panels)*32))
		self.ScrollBar:SetUp(self:GetParent():GetTall(),self:GetTall())
	end
	
	local function ScrollBarManage(self)
		self:GetParent().MainScorePanel.y = self:GetOffset()
	end
	
	vgui.Register("gtv_scoreboard_scorespanel",PANEL)
	
local PANEL = {}
PANEL.ScrollSpeed = 42
//PANEL.x = 0
//PANEL.LastThink = 0

function PANEL:Init()
	self.Label = vgui.Create("DLabel",self)
	self.lx = 0
	self.LastThink = 0
end

function PANEL:SetScrollSpeed(speed)
	self.ScrollSpeed = speed
end

function PANEL:GetScrollSpeed()
	return self.ScrollSpeed
end

function PANEL:SetText(text)
	self.Label:SetText(text)
	self.Label:SizeToContents()
end

function PANEL:SetTextColor(col)
	self.Label:SetTextColor(col)
end

function PANEL:SetFont(font)
	self.Label:SetFont(font)
	self.Label:SizeToContents()
end

function PANEL:Think()
	self.lx = self.lx-(CurTime()-self.LastThink)*self.ScrollSpeed
	
	while (self.lx+self.Label:GetWide() < 0) do
		self.lx = self.lx+self:GetWide()+self.Label:GetWide()
	end
	while (self.lx > self:GetWide()) do
		self.lx = self.lx-self:GetWide()-self.Lavel:GetWide()
	end
	self.Label:SetPos(self.lx,0)
	self.LastThink = CurTime()
end

vgui.Register("XScrollingLabel",PANEL)
	

local PANEL = {} --yes hank, I pretty much realized how to use this vgui shit like a week before the deadline

function PANEL:Init()
	self.HighScore = 0
	self.LastUpdate = CurTime()
	self.Icon = vgui.Create("DImage",self) -- top left gtv icon
		self.Icon:SetImage("vgui/gtv")
		self.Icon:SetSize(32,32)
		self.Icon:SetPos(12,12)
	self.ServerNameBG = vgui.Create("DImage",self) -- blue background for the server name
		self.ServerNameBG:SetPos(50,22)
		self.ServerNameBG:SetImage("vgui/white")
		self.ServerNameBG:SetImageColor(gtvcol)
		self.ServerNameBG:SetText(GetHostName())
	self.ServerName = vgui.Create("XScrollingLabel",self.ServerNameBG) --the server name
		self.ServerName:SetPos(0,0)
		self.ServerName:SetFont("CV24")
		self.ServerName:SetTextColor(color_white)
	self.ServerPlayersBG = vgui.Create("DImage",self) -- blue background for the player count
		self.ServerPlayersBG:SetImage("vgui/white")
		self.ServerPlayersBG:SetImageColor(gtvcol)
		self.ServerPlayersBG:SetSize(42,22)
	self.ServerPlayers = vgui.Create("DLabel",self.ServerPlayersBG) --the player count in the upper right
		self.ServerPlayers:SetSize(42,22)
		self.ServerPlayers:SetFont("CV24")
		self.ServerPlayers:SetTextColor(color_white)
		
	--HIGH SCORE	
	self.HighScoreLabel = vgui.Create("DLabel",self) --high score label
		self.HighScoreLabel:SetText("High Score:")
		self.HighScoreLabel:SetFont("CV16")
		self.HighScoreLabel:SetTextColor(gtvcol)
		self.HighScoreLabel:SetPos(32,48)
		self.HighScoreLabel:SizeToContents()
	self.HighScoreAvatarColor = vgui.Create("PlayerColorRect",self) --the color of the highest scoring player
		self.HighScoreAvatarColor:SetPos(36,62)
		self.HighScoreAvatarColor:SetSize(32,36)
	self.HighScoreAvatar = vgui.Create("AvatarImage",self.HighScoreAvatarColor) --the highest scoring player's avatar
		//self.HighScoreAvatar:SetPos(36,62)
	self.HighScoreNumber = vgui.Create("DLabel",self) --the highest score
		self.HighScoreNumber:SetSize(256,18)
		self.HighScoreNumber:SetPos(self.HighScoreAvatarColor.x+32,84)
		self.HighScoreNumber:SetTextColor(gtvcol)
		self.HighScoreNumber:SetFont("CV24")
		self.HighScoreNumber:SetText("0")
	self.HighScoreName = vgui.Create("DLabel",self) --the name of the highest scoring player
		self.HighScoreName:SetSize(256,18)
		self.HighScoreName:SetTextColor(gtvcol)
		self.HighScoreName:SetPos(self.HighScoreAvatarColor.x+32,64)
		self.HighScoreName:SetFont("CV24")
		self.HighScoreName:SetText("???")
		
	--MAIN SCORES
	self.NameLabel = vgui.Create("DLabel",self)
		self.NameLabel:SetPos(18,self.HighScoreAvatarColor.y+48)
		self.NameLabel:SetFont("CV20")
		self.NameLabel:SetText("Name")
		self.NameLabel:SetTextColor(gtvcol)
		self.NameLabel:SizeToContents()
	self.PingLabel = vgui.Create("DLabel",self)
		self.PingLabel:SetFont("CV20")
		self.PingLabel:SetText("Ping")
		self.PingLabel:SetTextColor(gtvcol)
		self.PingLabel:SizeToContents()
	self.DeathsLabel = vgui.Create("DLabel",self)
		self.DeathsLabel:SetFont("CV20")
		self.DeathsLabel:SetText("Deaths")
		self.DeathsLabel:SetTextColor(gtvcol)
		self.DeathsLabel:SizeToContents()
	self.ScoreLabel = vgui.Create("DLabel",self)
		self.ScoreLabel:SetFont("CV20")
		self.ScoreLabel:SetText("Score")
		self.ScoreLabel:SetTextColor(gtvcol)
		self.ScoreLabel:SizeToContents()
	self.MainScorePanelClip = vgui.Create("Panel",self) --main scores panel, holds all player scores
		self.MainScorePanelClip:SetPos(16,self.HighScoreAvatarColor.y+64)
	self.MainScorePanel = vgui.Create("gtv_scoreboard_scorespanel",self.MainScorePanelClip) --main scores panel, holds all player scores
	self.MainScorePanelScrollBar = vgui.Create("DVScrollBar",self)
		self.MainScorePanelScrollBar.Think = ScrollBarManage
		self.MainScorePanel.ScrollBar = self.MainScorePanelScrollBar
		self.MainScorePanel:SetupPlayers()
	self.SpectatorsLabel = vgui.Create("DLabel",self)
		self.SpectatorsLabel:SetPos(32,0)
		self.SpectatorsLabel:SetText("Spectators: ")
		self.SpectatorsLabel:SetTextColor(gtvcol)
		self.SpectatorsLabel:SetWrap(true)
	--Fretta menu button
	
end

function PANEL:PerformLayout()
	local x,y = self.ServerNameBG:GetPos()
	self.ServerNameBG:SetSize(self:GetWide()-x-12-48,22)
	self.ServerName:SetSize(self:GetWide()-x-12-48,22)
	self.ServerPlayersBG:SetPos(x+self.ServerNameBG:GetWide()+6,22)
	self.MainScorePanelClip:SetSize(self:GetWide()-48,self:GetTall()-self.MainScorePanelClip.y-64)
	self.MainScorePanel:SetSize(self:GetWide()-48,self.MainScorePanel:GetTall())
	self.MainScorePanelScrollBar:SetPos(self.MainScorePanelClip.x+self.MainScorePanelClip:GetWide()+4,self.MainScorePanelClip.y)
	self.MainScorePanelScrollBar:SetSize(16,self.MainScorePanelClip:GetTall())
	self.SpectatorsLabel.y = self.MainScorePanelClip.y+self.MainScorePanelClip:GetTall()+4
	self.SpectatorsLabel:SetSize(self.MainScorePanelClip.x+self.MainScorePanelClip:GetWide()-self.SpectatorsLabel.x,self:GetTall()-self.SpectatorsLabel.y-8)
	self.PingLabel:SetPos(self.MainScorePanelClip.x+self.MainScorePanelClip:GetWide()-self.PingLabel:GetWide()-6,self.HighScoreAvatarColor.y+48)
	self.DeathsLabel:SetPos(self.PingLabel.x-self.DeathsLabel:GetWide()-16,self.HighScoreAvatarColor.y+48)
	self.ScoreLabel:SetPos(self.DeathsLabel.x-self.ScoreLabel:GetWide()-32,self.HighScoreAvatarColor.y+48)
	x_anchor_score = self.ScoreLabel.x+self.ScoreLabel:GetWide()-self.MainScorePanelClip.x
	x_anchor_deaths = self.DeathsLabel.x+self.DeathsLabel:GetWide()-self.MainScorePanelClip.x
	x_anchor_ping = self.PingLabel.x+self.PingLabel:GetWide()-self.MainScorePanelClip.x
end

function PANEL:SetHighScorer(pl) --supply the highest scoring player and the highest score and the scoreboard will update to reflect it
	local score = pl:HighScore()
	self.HighScoreAvatarColor:SetPlayer(pl)
	self.HighScoreAvatar:SetPlayer(pl)
	self.HighScoreName:SetText(pl:Nick()) --is this really worth updating every think?
	self.HighScoreNumber:SetText(NumberToStringWithSeparators(score))
	self.HighScore = score
end
	

function PANEL:Think()
	self.ServerName:SetText(GetHostName())
	self.ServerPlayers:SetText(#player.GetAll().."/"..MaxPlayers())
	if self.LastUpdate+0.5 < CurTime() then
		if !self.HighScoreAvatarColor:GetPlayer():IsValid() then
			self.HighScore = 0
		end
		for k,v in ipairs(team.GetPlayers(TEAM_UNASSIGNED)) do
			if (v:HighScore() > self.HighScore) then
				self:SetHighScorer(v)
			end
		end
		local specstring = "Spectators: "
		for k,v in ipairs(team.GetPlayers(TEAM_SPECTATOR)) do
			if k != 1 then
				specstring = specstring..", "
			end
			specstring = specstring..v:Nick()
		end
		self.SpectatorsLabel:SetText(specstring)
		self.MainScorePanel:CleanUpPlayers()
		self.LastUpdate = CurTime()
	end
end

function PANEL:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),gtvcol)
	draw.RoundedBox(8,4,4,self:GetWide()-8,self:GetTall()-8,color_white)
end

vgui.Register("gtv_scoreboard",PANEL)

function GM:CreateScoreBoard()
	GAMEMODE.ScoreBoard = vgui.Create("gtv_scoreboard")
	local ScoreBoard = GAMEMODE.ScoreBoard
	ScoreBoard:SetSize(540,ScrH()-120)
	ScoreBoard:SetPos((ScrW()-ScoreBoard:GetWide())/2,(ScrH()-ScoreBoard:GetTall())/2)
	ScoreBoard:SetVisible(false)
end

function GM:ScoreboardShow()
	if !self.ScoreBoard then
		gamemode.Call("CreateScoreBoard")
	end
	GAMEMODE.ScoreBoard:SetVisible(true)
end

function GM:ScoreboardHide()
	GAMEMODE.ScoreBoard:SetVisible(false)
end

usermessage.Hook("gtv_sb_udpl",function(um)
	local pl = um:ReadEntity()
	if GAMEMODE.ScoreBoard then
		if !pl || !pl:IsValid() then
			GAMEMODE.ScoreBoard.MainScorePanel:CleanUpPlayers()
		elseif pl:Team() != TEAM_SPECTATOR then
			GAMEMODE.ScoreBoard.MainScorePanel:AddPlayer(pl)
		else
			GAMEMODE.ScoreBoard.MainScorePanel:RemovePlayer(pl)
		end
	end
end)




function GM:ShowGamemodeChooser()
	self.BaseClass.ShowGamemodeChooser()
	gamemode.Call("ScoreboardHide")
end