// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: The interface that shows up when a round is finished, that displays data about how you did and how everyone else did.

local PANEL = {}

// Internal variables
PANEL.MatTopLeft = surface.GetTextureID("LaserTag/HUD/hud_baseint_topleft")
PANEL.MatTopRight = surface.GetTextureID("LaserTag/HUD/hud_baseint_topright")
PANEL.MatSpacer = surface.GetTextureID("LaserTag/HUD/hud_baseint_spacer")
PANEL.BaseAlpha = 50

local stats = {}

function PANEL:Init()
	local h = ScrH() * 0.9
	local w = h + 200
	
	self:SetSize(w,h)
	self:SetPaintBackground(false)
	
	self.Canvas = vgui.Create("DPanelList",self)
	self.Canvas:SetDrawBackground(false)
	self.Canvas:EnableVerticalScrollbar(true)
	self.Canvas:EnableHorizontal(true)
	self.Canvas:SetSpacing(6)
	
	// Black bar at the top that says "Siren has won" etc.
	self.Result = vgui.Create("DRoundFinishHeader",self)
	
	// Close button.
	self.Close = vgui.Create("DButton",self)
	self.Close:SetSize(100,25)
	self.Close:SetText("Close")
	self.Close:SetDrawBackground(false)
	
	// Just to make sure everything is in place since we rely on GetSize and GetPos pretty early on.
	self:PerformLayout()
end

// Aliases for the self.Result panel that's a child of this panel.
function PANEL:SetText(txt) 		self.Result:SetText(txt) 			end
function PANEL:WinStat(name,img) 	self.Result:WinStat(name,img) 		end
function PANEL:AddItem(item)		self.Canvas:AddItem(item) 			end

function PANEL:PerformLayout()
	local w,h = self:GetSize()
	
	// Results bar at the top...
	self.Result:SetPos(1,32)
	self.Result:SetSize(w-2,h*0.15)
	self.Result:InvalidateLayout()
	
	// Put the button somewhere.
	self.Close:SetPos(0,h - self.Close:GetTall() - 4)
	self.Close:CenterHorizontal()
	
	// Layout the scrolling canvas.
	self.Canvas:SetPos(1,h*0.15 + 38)
	self.Canvas:SetSize(w-2,h-(h*0.15 + 38) - self.Close:GetTall() - 10)
end

function PANEL:Paint()
	local col = team.GetColor(LocalPlayer():Team())
	surface.SetDrawColor(col.r,col.g,col.b,255)
	
	local w,h = self:GetSize()
	
	// Top tab thing.
	surface.SetTexture(self.MatTopLeft)
	surface.DrawTexturedRect(0,0,32,32)
	
	surface.SetTexture(self.MatTopRight)
	surface.DrawTexturedRect(w-32,0,32,32)
	
	surface.SetTexture(self.MatSpacer)
	surface.DrawTexturedRect(32,0,w-64,32)
	
	// Main content background.
	surface.SetDrawColor(col.r,col.g,col.b,self.BaseAlpha)
	surface.DrawRect(0,32,w,h-32)
	
	surface.SetDrawColor(col.r,col.g,col.b,255)
	surface.DrawLine(0,32,0,h)
	surface.DrawLine(w-1,32,w-1,h)
	surface.DrawLine(0,h-1,w,h-1)
end

derma.DefineControl("DRoundFinish", "LaserTag round finish screen.", PANEL, "DPanel")

