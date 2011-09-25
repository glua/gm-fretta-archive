// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: The interface that shows up when a round is finished, that displays data about how you did and how everyone else did.

local PANEL = {}

AccessorFunc(PANEL, "m_iSpacing", "Spacing", FORCE_NUMBER)


function PANEL:Init()
	self:SetPaintBackground(false)
	self:SetSpacing(4)
	
	self.RoundNotice = vgui.Create("DLabel",self)
	self.RoundNotice:SetText("-")
	self.RoundNotice:SetFont("DodgerMed")
	self.RoundNotice:SetTextColor(Color(255,255,255,255))
	self.RoundNotice:SetContentAlignment(5)
	
	self.WonStats = {}
	self.HasWonStats = false
	self.ResultsLabel = vgui.Create("DLabel",self)
	self.ResultsLabel:SetText("You did not win any stats.")
	self.ResultsLabel:SetFont("LaserTagMed")
	self.ResultsLabel:SetTextColor(Color(255,255,255,255))
	self.ResultsLabel:SetContentAlignment(5)
end

function PANEL:SetText(txt) 		self.RoundNotice:SetText(txt) 		end

function PANEL:WinStat(name,img)
	if not self.HasWonStats then 
		self.ResultsLabel:SetText("You attained:")
		self.HasWonStats = true
	end
	
	local stat = vgui.Create("DImage",self)
	stat:SetImage(img)
	
	table.insert(self.WonStats,stat)
end

function PANEL:PerformLayout()
	self.RoundNotice:SizeToContents()
	self.RoundNotice:SetPos(0,self:GetSpacing())
	self.RoundNotice:CenterHorizontal()
	
	self.ResultsLabel:SizeToContents()
	
	for _,stat in ipairs(self.WonStats) do
		local size = self:GetTall()*0.75
		stat:SetSize(size,size)
	end
	
	if self.HasWonStats then
		local reqwidth = #self.WonStats * (self.WonStats[1]:GetTall() + self:GetSpacing()) + self.ResultsLabel:GetWide()
		local difference = self:GetWide() - reqwidth
		
		self.ResultsLabel:MoveBelow(self.RoundNotice,self:GetSpacing())
		local x,y = self.ResultsLabel:GetPos()
		
		// What we're doing here is getting the width of the collection of objects that say "yew won deese: shit1, shit2, boobs" and subtracting it from the width of the panel.
		// This allows us to position the collection of elements centered in the panel in a reasonably simple way.
		self.ResultsLabel:SetPos(difference/2,y + 64 - self.ResultsLabel:GetTall()/2)
		local last = self.ResultsLabel
		
		for k,v in ipairs(self.WonStats) do
			v:SetPos(0,y)
			v:MoveRightOf(last,self:GetSpacing())
			
			last = v
		end
	else // But if we don't have a collection of objects, we just center the label beneath RoundNotice.
		self.ResultsLabel:MoveBelow(self.RoundNotice,self:GetSpacing() + 64 - self.ResultsLabel:GetTall()/2)
		self.ResultsLabel:CenterHorizontal()
	end
	
end

function PANEL:Paint()
	local w,h = self:GetSize()
	
	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(0,0,w,h)
end

derma.DefineControl("DRoundFinishHeader", "LaserTag round finish header.", PANEL, "DPanel")
