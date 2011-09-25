// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Derma defines for shield and powerup indicators.

local hud = {}
hud.BaseAlpha			= 200 // Alpha of the text.
hud.NumNotify			= 4 // Number of concurrent tag messages to have on screen at once.
hud.StayTime			= 5 // Number of seconds to keep notification on before fading.
hud.FadeTime			= 2 // Number of seconds to fade for.

local PANEL = {}

/*---------------------------------------------------------
  Init
---------------------------------------------------------*/
function PANEL:Init()
	self:SetPaintBackground(false)
	self.Items = {}
end

function PANEL:AddItem(panel)
	if #self.Items >= hud.NumNotify then self:RemoveItem(1) end
	table.insert(self.Items,{Panel = panel,Time = CurTime()})
	
	// Adjust panel.
	panel:SetAlpha(hud.BaseAlpha)
	panel:SetParent(self)
	panel:SetWide(self:GetWide())
	panel:PerformLayout()
	
	self:InvalidateLayout()
end

function PANEL:RemoveItem(id)
	self.Items[id].Panel:Remove()
	table.remove(self.Items,id)
	self:InvalidateLayout()
end

function PANEL:Think()
	for i,item in ipairs(self.Items) do
		if CurTime() > item.Time + hud.StayTime + hud.FadeTime then
			self:RemoveItem(i)
			break
		end
		
		local sec = CurTime() - item.Time
		if sec > hud.StayTime and sec < hud.StayTime + hud.FadeTime then 
			local per =  (sec - hud.StayTime) / hud.FadeTime
			item.Panel:SetAlpha(Lerp(per,hud.BaseAlpha,0))
		end
	end
end

/*---------------------------------------------------------
   PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	local theight = 0
	
	for i,item in ipairs(self.Items) do
		local panel = item.Panel
		if i == 1 then panel:SetPos(0,0) else panel:MoveBelow(self.Items[i-1].Panel) end
		theight = theight + panel:GetTall()
	end
	
	self:SetTall(theight)
end
derma.DefineControl("DTagNotify", "LaserTag notify indicator.", PANEL, "DPanel")



///////////////////////////////////////////////////////////
////Tag Notify Row/////////////////////////////////////////
local PANEL = {}

AccessorFunc(PANEL,"m_iAlpha","Alpha")
AccessorFunc(PANEL,"m_iSpacing","Spacing")

/*---------------------------------------------------------
  Init
---------------------------------------------------------*/
function PANEL:Init()
	self:SetPaintBackground(false)
	self:SetSpacing(2)
	
	self.Attacker = vgui.Create("DLabel",self)
	self.Attacker:SetText("-")
	self.Attacker:SetFont("LaserTagMed")
	self.Attacker:SizeToContents()
	
	self.Comment = vgui.Create("DLabel",self)
	self.Comment:SetText("tagged")
	self.Comment:SetTextColor(Color(255,255,255,255))
	self.Comment:SetFont("LaserTagMed")
	self.Comment:SizeToContents()
	
	self.Victim = vgui.Create("DLabel",self)
	self.Victim:SetText("-")
	self.Victim:SetFont("LaserTagMed")
	self.Victim:SizeToContents()
end


function PANEL:SetAttacker(txt,tm)
	tm.a = self:GetAlpha()
	
	self.Attacker:SetText(txt)
	self.Attacker:SetTextColor(tm)
	self.Attacker:SizeToContents()
end

function PANEL:SetVictim(txt,tm)
	tm.a = self:GetAlpha()
	
	self.Victim:SetText(txt)
	self.Victim:SetTextColor(tm)
	self.Victim:SizeToContents()
end

function PANEL:SetText(txt)
	self.Comment:SetText(txt)
	self.Comment:SizeToContents()
end

function PANEL:SetAlpha(alpha)
	self.m_iAlpha = alpha
	local cola,colb = self.Attacker:GetTextColor(),self.Victim:GetTextColor()
	cola.a = alpha
	colb.a = alpha
	
	self.Attacker:SetTextColor(cola)
	self.Comment:SetTextColor(Color(255,255,255,alpha))
	self.Victim:SetTextColor(colb)
end


/*---------------------------------------------------------
   PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	self:SetTall(self.Comment:GetTall())
	local w,h = self:GetSize()
	
	local maxwide = (w - self.Comment:GetWide())/2 - self:GetSpacing()
	if self.Attacker:GetWide() > maxwide then self.Attacker:SetWide(maxwide) end
	if self.Victim:GetWide() > maxwide then self.Victim:SetWide(maxwide) end
	
	self.Victim:AlignRight(0)
	self.Comment:MoveLeftOf(self.Victim,self:GetSpacing())
	self.Attacker:MoveLeftOf(self.Comment,self:GetSpacing())
end
derma.DefineControl("DTagNotifyTag", "LaserTag notify row - tag.", PANEL, "DPanel")