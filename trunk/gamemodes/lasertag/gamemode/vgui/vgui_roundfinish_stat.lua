// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Shows a comparison of your score versus the top 3 scores for a particular stat plus what your score was last round.

local PANEL = {}

AccessorFunc(PANEL, "m_iPadding", "Padding", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iSpacing", "Spacing", FORCE_NUMBER)

function PANEL:Init()
	self:SetPaintBackground(false)
	self:SetPadding(4)
	self:SetSpacing(4)
	self.Rows = {}
	
	self:SetTall(128 + self:GetPadding()*2)
	
	self.Image = vgui.Create("DImage",self)
	self.Image:SetSize(128,128)
	
	self.Desc = vgui.Create("DLabel",self)
	self.Desc:SetText("-")
	self.Desc:SetFont("LaserTagMed")
	self.Desc:SetTextColor(Color(255,255,255,255))
	
	/* TODO
	self.Col_Rank = vgui.Create("DLabel",self)
	self.Col_Name = vgui.Create("DLabel",self)
	self.Col_Score = vgui.Create("DLabel",self)
	*/
	
	self.LastRound = false
end

function PANEL:SetImage(mat)
	self.Image:SetImage(mat)
end

function PANEL:SetDesc(str)
	self.Desc:SetText(str)
	self.Desc:SizeToContents()
end

function PANEL:AddRow(rank,ply,score)
	local row = vgui.Create("DRoundFinishRow",self)
	local pad = self:GetPadding()
	local spacing = self:GetSpacing()
	
	row:SetWide(self:GetWide() - self.Image:GetWide() - pad*2 - spacing)
	row:SetRank(rank)
	row:SetPly(ply)
	row:SetScore(score)
	row:InvalidateLayout()
	
	if ply == LocalPlayer() then row:SetGlow(true) end
	table.insert(self.Rows,row)
end

function PANEL:AddCompare(rank,ply,score)
	local pad = self:GetPadding()
	local spacing = self:GetSpacing()
	
	self.LRLabel = vgui.Create("DLabel",self)
	self.LRLabel:SetText("Against your score last round:")
	self.LRLabel:SetFont("CenterPrintText")
	self.LRLabel:SetTextColor(Color(255,255,255,255))
	self.LRLabel:SizeToContents()
	
	self.LastRound = vgui.Create("DRoundFinishRow",self)
	self.LastRound:SetWide(self:GetWide() - self.Image:GetWide() - pad*2 - spacing)
	self.LastRound:SetRank(rank)
	self.LastRound:SetPly(ply)
	self.LastRound:SetScore(score)
	self.LastRound:InvalidateLayout()
end


function PANEL:PerformLayout()
	local w,h = self:GetSize()
	local pad = self:GetPadding()
	local spacing = self:GetSpacing()
	
	self.Image:SetPos(pad,pad)
	local reqheight = self.Image:GetTall() + 2*pad
	local altheight = 2*pad + self.Desc:GetTall() + #self.Rows * (self.Rows[1]:GetTall()) + (self.LastRound and self.LRLabel:GetTall() + self.LastRound:GetTall() or 0)
	if reqheight > altheight then self:SetTall(reqheight) else self:SetTall(altheight) end
	
	self.Image:CenterVertical()
	
	local remwidth = w - self.Image:GetWide() - pad*2 - spacing
	local x = self.Image:GetWide() + pad + spacing
	
	self.Desc:MoveRightOf(self.Image,spacing)
	local last = self.Desc
	
	for _,row in ipairs(self.Rows) do
		row:SetPos(x,0)
		row:MoveBelow(last,0)
		last = row
	end
	
	if self.LastRound then
		self.LRLabel:MoveRightOf(self.Image,spacing)
		self.LRLabel:MoveBelow(last,0)
		
		self.LastRound:SetPos(x,0)
		self.LastRound:MoveBelow(self.LRLabel,0)
	end
end

function PANEL:Paint()
	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(0,0,self:GetWide(),self:GetTall())
end

derma.DefineControl("DRoundFinishStat", "LaserTag round finish stat box.", PANEL, "DPanel")


//////////////////////////////////////////
////Stat Row//////////////////////////////
local PANEL = {}

AccessorFunc(PANEL, "m_iPadding", "Padding", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iGlow", "Glow", FORCE_BOOL)

function PANEL:Init()
	self:SetPaintBackground(false)
	self:SetPadding(4)
	self:SetGlow(false)
	
	self:SetTall(32)
	
	self.Rank = vgui.Create("DLabel",self)
	self.Rank:SetText("0/0")
	self.Rank:SetFont("CenterPrintText")
	self.Rank:SetContentAlignment(5)
	self.Rank:SizeToContents()
	
	self.PlyName = vgui.Create("DLabel",self)
	self.PlyName:SetText("#UNKNOWN#")
	self.PlyName:SetFont("CenterPrintText")
	self.PlyName:SetTextColor(Color(255,255,255,255))
	self.PlyName:SetContentAlignment(5)
	self.PlyName:SizeToContents()
	
	self.Score = vgui.Create("DLabel",self)
	self.Score:SetText("0")
	self.Score:SetFont("CenterPrintText")
	self.Score:SetContentAlignment(5)
	self.Score:SizeToContents()
end

function PANEL:SetRank(str)
	self.Rank:SetText(str)
	self.Rank:SizeToContents()
end

function PANEL:SetPly(ply)
	local name = "Disconnected Player"
	if ply and ply:IsValid() and ply.Name then name = string.gsub(ply:Name(),"[\t\n]","") end // Don't want these fucking shit up.
	
	self.PlyName:SetText(name) 
	self.PlyName:SizeToContents()
end

function PANEL:SetScore(str)
	self.Score:SetText(str)
	self.Score:SizeToContents()
end

function PANEL:PerformLayout()
	self:SetTall(self.Score:GetTall() + self:GetPadding()*2)
	local w,h = self:GetSize()
	
	self.Rank:CenterVertical()
	self.PlyName:CenterVertical()
	self.Score:CenterVertical()
	
	self.Rank:AlignLeft(self:GetPadding())
	self.PlyName:MoveRightOf(self.Rank,self:GetPadding())
	self.PlyName:SetSize(self:GetWide() - self.Rank:GetWide() - self.Score:GetWide() - self:GetPadding()*4,self.PlyName:GetTall())
	self.Score:AlignRight(self:GetPadding())
end

function PANEL:Paint()
	if self:GetGlow() then
		local std = color_black
		local glow = team.GetColor(LocalPlayer():Team())
		local col = LerpColor(0.5*math.sin(CurTime()) + 0.5,std,glow)
		
		surface.SetDrawColor(col.r,col.g,col.b,255)
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		
		surface.SetDrawColor(0,0,0,150)
		surface.DrawRect(2,2,self:GetWide()-4,self:GetTall()-4)
	else
		surface.SetDrawColor(0,0,0,150)
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end
end

derma.DefineControl("DRoundFinishRow", "LaserTag round finish comparison row.", PANEL, "DPanel")

