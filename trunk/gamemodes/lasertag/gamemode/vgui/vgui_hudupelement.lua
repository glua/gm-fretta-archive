local PANEL = {}

AccessorFunc( PANEL, "Highlight", "Highlight", FORCE_BOOL)
AccessorFunc( PANEL, "HighlightTime", "HighlightTime")

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
	self:SetPaintBackground(false)
	
	self.LabelTitle = vgui.Create("DLabel", self)
	self.LabelTitle:SetText("-")
	self.LabelTitle:SetTextColor(Color(255,255,255,255))
	self.LabelTitle:SetFont("ConsoleText")
	
	self.LabelContent = vgui.Create("DLabel", self)
	self.LabelContent:SetText("-")
	self.LabelContent:SetTextColor(Color(255,255,255,255))
	self.LabelContent:SetFont("ConsoleText")
	
	self.HLFinish = 0
	self.Orig = Color(255,255,255,255)
	self.HLCol = Color(255,255,255,255)
	self:SetHighlight(false)
	self:SetHighlightTime(2)
end

function PANEL:SetText(title,content)
	if title then self.LabelTitle:SetText(title) end
	if content then self.LabelContent:SetText(content) end
end

function PANEL:SetTextColor(title,content)
	if title then self.LabelTitle:SetTextColor(title) end
	if content then self.LabelContent:SetTextColor(content) self.Orig = content end
end

function PANEL:SetFont(title,content)
	if title then self.LabelTitle:SetFont(title) end
	if content then self.LabelContent:SetFont(content) end
end

PANEL.GetContentTextFromFunction = false

function PANEL:Think()
	if self.GetContentTextFromFunction then
		self.LabelContent:SetText(self:GetContentTextFromFunction())
		
		if self:GetHighlight() then
			self.Orig = self.LabelContent:GetTextColor()
			self.HLCol = LerpColor(0.3,self.Orig,team.GetColor(LocalPlayer():Team()))
			self.HLFinish = CurTime() + self:GetHighlightTime()
		end
	end
	
	if self:GetHighlight() and CurTime() < self.HLFinish then
		self.HLCol = LerpColor(self.HLFinish - CurTime()/self.HLFinish,self.HLCol,self.Orig)
		self.HLFinish = CurTime() + self:GetHighlightTime()
	end
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	self.LabelTitle:SizeToContents()
	self.LabelContent:SizeToContents()
	
	local wide1,wide2,wide = self.LabelTitle:GetWide(),self.LabelContent:GetWide(),nil
	if wide1 > wide2 then wide = wide1 else wide = wide2 end
	
	self:SetWide(wide)
	self:SetTall(self.LabelContent:GetTall() + self.LabelContent:GetTall())
	
	self.LabelTitle:SetPos(self:GetWide()/2 - wide1/2,0)
	self.LabelContent:SetPos(self:GetWide()/2 - wide2/2,self.LabelTitle:GetTall())
end



derma.DefineControl( "DHudUpElement", "A HUD Element", PANEL, "DPanel" )
