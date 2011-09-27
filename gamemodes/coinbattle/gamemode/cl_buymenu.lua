
local COL = {
	white = Color( 220, 220, 220, 255 ),
	grey = Color( 100, 100, 100, 255 ),
	black = Color( 50, 50, 50, 255 ),
	green = Color(134,203,110,255),
	red = Color(153,2,47,255)
}

local function coltotab(col)
	local tab = {col.r, col.g, col.b, col.a}
	return unpack(tab)
end

/*================
	Back Panel
================*/
local PANEL = {}

function PANEL:Init()
	
	self:SetPos(0,0)
	self:SetSize(ScrW(),ScrH())
	
end

function PANEL:OnMousePressed()
	
	self:Remove()
	
end

function PANEL:Paint()
	
	Derma_DrawBackgroundBlur(self)
	
end

vgui.Register("CBBackPanel", PANEL)

/*================
	Main Panel
================*/
local PANEL = {}

function PANEL:Init()
	
	self.Color = COL.white
	
end

function PANEL:SetColor(color)

	self.Color = color

end

function PANEL:Paint()
	
	draw.RoundedBox(16, 0, 0, self:GetWide(), self:GetTall(), self.Color)
	
end

vgui.Register("CBFrame", PANEL)

/*=================
	Item Button
=================*/
local PANEL = {}

AccessorFunc(PANEL, "m_bClicked", "Clicked", FORCE_BOOL)
AccessorFunc(PANEL, "m_tData", "Data")
AccessorFunc(PANEL, "m_bDisabled", "Disabled", FORCE_BOOL)

function PANEL:Init()
	
	self:SetContentAlignment(5)
	
	self:SetSize(40,40)
	self:SetClicked(false)
	self:SetDisabled(false)
	
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	
end

function PANEL:IsDown()
	
	return self.Depressed
	
end

function PANEL:OnMousePressed(mousecode)
	
	if self:GetDisabled() then return end
	
	self:MouseCapture(true)
	self.Depressed = true
	
end

function PANEL:OnMouseReleased(mousecode)
	
	if self:GetDisabled() then return end
	
	self:MouseCapture(false)
	
	if !self.Depressed then return end
	
	self.Depressed = nil
	
	if mousecode == MOUSE_RIGHT then
		PCallError(self.DoRightClick,self)
	end
	
	if mousecode == MOUSE_LEFT then
		PCallError(self.DoClick,self)
	end
	
end

function PANEL:DoClick()
	
	
end

function PANEL:DoRightClick()
	
	
end

function PANEL:ApplySchemeSettings()
	
	self:SetFGColor(coltotab(COL.black))
	
end

function PANEL:Paint()
	
	local col = COL.black
	if self:GetClicked() then col = COL.green end
	if self:GetDisabled() then col = COL.red end
	
	draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),col)
	
	local col = COL.white
	if self:IsDown() then col = COL.grey end
	draw.RoundedBox(4,2,2,self:GetWide()-4,self:GetTall()-4,col)
	
end

function PANEL:SetDisabled(bool)
	
	self.m_bDisabled = bool
	self:InvalidateLayout()
	
end

vgui.Register("CBButton", PANEL, "Label")

/*=======================
	Vertical Scroller
=======================*/
local PANEL = {}

AccessorFunc(PANEL, "m_iOverlap", "Overlap")

function PANEL:Init()
	
	self.Panels = {}
	self.OffsetY = 0
	
	self.pnlCanvas = vgui.Create( "Panel", self )
	
	self:SetOverlap( 0 )
	
end

function PANEL:AddPanel( pnl )

	table.insert( self.Panels, pnl )
	
	pnl:SetParent( self.pnlCanvas )

end

function PANEL:OnMouseWheeled( dlta )
	
	self.OffsetY = self.OffsetY + dlta * -10
	self:InvalidateLayout( true )
	
	return true
	
end

function PANEL:PerformLayout()

	local w, h = self:GetSize()
	w=w-10
	
	self.pnlCanvas:SetWide( w )
	
	local y = 0
	
	for k, v in pairs( self.Panels ) do
	
		v:SetPos( 0, y )
		v:SetWide( w )
		v:ApplySchemeSettings()
		
		y = y + v:GetTall() - self.m_iOverlap
	
	end
	
	self.pnlCanvas:SetTall( y + self.m_iOverlap )
	
	if ( h < self.pnlCanvas:GetTall() ) then
		self.OffsetY = math.Clamp( self.OffsetY, 0, self.pnlCanvas:GetTall() - self:GetTall() )
	else
		self.OffsetY = 0
	end
	
	self.pnlCanvas.y = self.OffsetY * -1
	self.pnlCanvas:SetPos(0, self.pnlCanvas.y)
	
end

function PANEL:Paint()
	
	draw.RoundedBox(4,0,0,self:GetWide()-10,self:GetTall(),COL.grey)
	
	if self:GetTall() < self.pnlCanvas:GetTall() then
		local circleY = self.OffsetY / (self.pnlCanvas:GetTall() - self:GetTall()) * (self:GetTall()-8)
		draw.RoundedBox(4,self:GetWide()-9,circleY,8,8,COL.grey)
	end

end

vgui.Register("CBVScroller", PANEL)

/*====================
	Purchase Panel
====================*/

local PANEL = {}

AccessorFunc(PANEL, "m_tData", "Data")

function PANEL:Init()
	
	self:SetContentAlignment(5)
	self:SetFont("FRETTA_MEDIUM")
	
end

function PANEL:PerformLayout()
	
	local total = 0

	for i=1,3 do
		total = total + (self:GetData()[i] and self:GetData()[i].cost or 0)
	end
	
	self:SetText("Purchase Total: "..total.."\nYour Coins: "..LocalPlayer():GetBankCoins())
	
end

function PANEL:ApplySchemeSettings()
	
	self:SetFGColor(coltotab(COL.black))
	
end

function PANEL:Paint()
	
	draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),COL.grey)
	
end

vgui.Register("CBPurchase", PANEL, "Label")

/*=================
	Hover Panel
=================*/

local PANEL = {}

function PANEL:Init()

	self.Title = vgui.Create("Label", self)
	self.Desc = vgui.Create("Label", self)

	self.Title:SetContentAlignment(5)
	self.Desc:SetContentAlignment(7)

	self.Title:SetFont("FRETTA_LARGE")
	self.Desc:SetFont("FRETTA_MEDIUM")

	self.Desc:SetWrap(true)

	self.Title:SetText("")
	self.Desc:SetText("")

end

function PANEL:SetHoverText(title, desc)

	self.Title:SetText(title or "")
	self.Desc:SetText(desc or "")

end

function PANEL:PerformLayout()

	self.Title:SetPos(4,4)
	self.Title:SetWidth(self:GetWide()-8)

	self.Desc:SetPos(4,self.Title:GetTall()+8)
	self.Desc:SetSize(self:GetWide()-8, self:GetTall()-self.Title:GetTall()-8)
	
end

function PANEL:ApplySchemeSettings()
	
	self.Title:SetFGColor(coltotab(COL.black))
	self.Desc:SetFGColor(coltotab(COL.black))
	
end

function PANEL:Paint()
	
	draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),COL.grey)
	
end

vgui.Register("CBHover", PANEL)

/*================
	ConCommand
================*/

local function DataToWep(slot, data)
	local wep
	for k,v in pairs(WeaponTable[slot]) do
		if v.entity == data.entity then
			wep = k
			break
		end
	end
	return wep
end

concommand.Add("cb_buy_menu",function(ply,cmd,args)

	local mycoins = LocalPlayer():GetBankCoins()
	
	local buttonpressed = {}
	local buttons = {}
	
	local back = vgui.Create("CBBackPanel")
	local main = vgui.Create("CBFrame", back)
	local labelprim = vgui.Create("Label",main)
	local scrollprim = vgui.Create("CBVScroller", main)
	local labelsecd = vgui.Create("Label",main)
	local scrollsecd = vgui.Create("CBVScroller", main)
	local labelnade = vgui.Create("Label",main)
	local scrollnade = vgui.Create("CBVScroller", main)
	local purchase = vgui.Create("CBPurchase", main)
	local hover = vgui.Create("CBHover", main)
	local checkout = vgui.Create("CBButton", main)

	main:SetSize(706,450)
	main:Center()
	main:MakePopup()

	labelprim:SetContentAlignment(5)
	labelprim:SetWide(80)
	labelprim:SetFont("FRETTA_MEDIUM")
	labelprim:AlignLeft(16)
	labelprim:AlignTop(16)
	labelprim:SetText("Primary")
	labelprim.ApplySchemeSettings = function()
		labelprim:SetFGColor(coltotab(COL.black))
	end
	
	scrollprim:SetSize(90,394)
	scrollprim:AlignBottom(16)
	scrollprim:AlignLeft(16)
	scrollprim:SetOverlap(-10)
	
	buttons[1] = {}
	for i=1, #WeaponTable[1] do
		
		buttons[1][i] = vgui.Create("CBButton")
		buttons[1][i]:SetData(WeaponTable[1][i])
		buttons[1][i]:SetSize(80,80)
		buttons[1][i]:SetText(buttons[1][i]:GetData().name.."\nCost: "..buttons[1][i]:GetData().cost)
		buttons[1][i].DoClick = function()
			if buttons[1][i]:GetClicked() then
				buttonpressed[1] = nil
			else
				buttonpressed[1] = buttons[1][i]:GetData()
			end
			if not buttonpressed[1] and not buttonpressed[2] and not buttonpressed[3] then
				checkout:SetText("Close Menu")
			else
				checkout:SetText("Checkout")
			end
		end
		buttons[1][i].OnCursorEntered = function()
			hover:SetHoverText(buttons[1][i]:GetData().name,buttons[1][i]:GetData().help)
		end
		buttons[1][i].OnCursorExited = function()
			hover:SetHoverText("","")
		end

		scrollprim:AddPanel(buttons[1][i])
		
	end
	
	labelsecd:SetContentAlignment(5)
	labelsecd:SetWide(80)
	labelsecd:SetFont("FRETTA_MEDIUM")
	labelsecd:AlignLeft(scrollprim:GetWide()+32)
	labelsecd:AlignTop(16)
	labelsecd:SetText("Secondary")
	labelsecd.ApplySchemeSettings = function()
		labelsecd:SetFGColor(coltotab(COL.black))
	end
	
	scrollsecd:SetSize(90,394)
	scrollsecd:AlignBottom(16)
	scrollsecd:AlignLeft(scrollprim:GetWide()+32)
	scrollsecd:SetOverlap(-10)
	
	buttons[2] = {}
	for i=1, #WeaponTable[2] do
		
		buttons[2][i] = vgui.Create("CBButton")
		buttons[2][i]:SetData(WeaponTable[2][i])
		buttons[2][i]:SetSize(80,80)
		buttons[2][i]:SetText(buttons[2][i]:GetData().name.."\nCost: "..buttons[2][i]:GetData().cost)
		buttons[2][i].DoClick = function()
			if buttons[2][i]:GetClicked() then
				buttonpressed[2] = nil
			else
				buttonpressed[2] = buttons[2][i]:GetData()
			end
			if not buttonpressed[1] and not buttonpressed[2] and not buttonpressed[3] then
				checkout:SetText("Close Menu")
			else
				checkout:SetText("Checkout")
			end
		end
		buttons[2][i].OnCursorEntered = function()
			hover:SetHoverText(buttons[2][i]:GetData().name,buttons[2][i]:GetData().help)
		end
		buttons[2][i].OnCursorExited = function()
			hover:SetHoverText("","")
		end

		scrollsecd:AddPanel(buttons[2][i])
		
	end

	labelnade:SetContentAlignment(5)
	labelnade:SetWide(80)
	labelnade:SetFont("FRETTA_MEDIUM")
	labelnade:AlignLeft(scrollprim:GetWide()+scrollsecd:GetWide()+48)
	labelnade:AlignTop(16)
	labelnade:SetText("Grenade")
	labelnade.ApplySchemeSettings = function()
		labelnade:SetFGColor(coltotab(COL.black))
	end
	
	scrollnade:SetSize(90,394)
	scrollnade:AlignBottom(16)
	scrollnade:AlignLeft(scrollprim:GetWide()+scrollsecd:GetWide()+48)
	scrollnade:SetOverlap(-10)
	
	buttons[3] = {}
	for i=1, #WeaponTable[3] do
		
		buttons[3][i] = vgui.Create("CBButton")
		buttons[3][i]:SetData(WeaponTable[3][i])
		buttons[3][i]:SetSize(80,80)
		buttons[3][i]:SetText(buttons[3][i]:GetData().name.."\nCost: "..buttons[3][i]:GetData().cost)
		buttons[3][i].DoClick = function()
			if buttons[3][i]:GetClicked() then
				buttonpressed[3] = nil
			else
				buttonpressed[3] = buttons[3][i]:GetData()
			end
			if not buttonpressed[1] and not buttonpressed[2] and not buttonpressed[3] then
				checkout:SetText("Close Menu")
			else
				checkout:SetText("Checkout")
			end
		end
		buttons[3][i].OnCursorEntered = function()
			hover:SetHoverText(buttons[3][i]:GetData().name,buttons[3][i]:GetData().help)
		end
		buttons[3][i].OnCursorExited = function()
			hover:SetHoverText("","")
		end

		scrollnade:AddPanel(buttons[3][i])
		
	end
	
	purchase:SetSize(356,64)
	purchase:AlignRight(16)
	purchase:AlignBottom(80)
	purchase:SetData(buttonpressed)

	hover:SetSize(356,272)
	hover:AlignTop(16)
	hover:AlignRight(16)
	
	checkout:SetSize(128,48)
	checkout:AlignRight(388/2-checkout:GetWide()/2)
	checkout:AlignBottom(16)
	checkout:SetText("Close Menu")
	checkout.DoClick = function()
		for i=1,3 do
			if buttonpressed[i] then ply:ConCommand("cb_buy_weapon "..i.." "..DataToWep(i,buttonpressed[i])) end
		end
		back:Remove()
	end
	
	back.Think = function()
		
		if not GetGlobalBool("InPreRound",false) then back:Remove() surface.PlaySound("buttons/button19.wav") end
		
		purchase:InvalidateLayout()
		
		local curTotal = 0
		if buttonpressed[1] then curTotal = curTotal + buttonpressed[1].cost end
		if buttonpressed[2] then curTotal = curTotal + buttonpressed[2].cost end
		if buttonpressed[3] then curTotal = curTotal + buttonpressed[3].cost end
		
		for i=1,3 do
			for k,v in pairs(buttons[i]) do
				
				local buttonCost = v:GetData().cost + curTotal
				if v:GetClicked() then buttonCost = buttonCost - v:GetData().cost end
				
				if buttonCost > mycoins then
					v:SetDisabled(true)
				else
					v:SetDisabled(false)
				end
				
				if buttonpressed[i] and buttonpressed[i] == v:GetData() then
					v:SetClicked(true)
				else
					v:SetClicked(false)
				end
			end
		end
		
	end
	
end)
