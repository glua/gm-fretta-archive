local color_grey = Color(0,0,0,150)

local InvPanel = {}
function InvPanel:PerformLayout()
	for k,v in pairs({"Slot1","Slot2","Slot3","Slot4"}) do
		if ValidEntity(self[v]) then self[v]:Remove() end
	end
	if !ValidEntity(self["Slot1"]) then
		if LocalPlayer().MyItems then
			for k,v in ipairs(LocalPlayer().MyItems) do
				local pos = "Slot"..k
				self[pos] = vgui.Create("SpawnIcon")
				self[pos]:SetParent(self)
				self[pos]:SetModel(v:GetModel())
				self[pos]:SetPos(22, k*2 + 64*(k-1))
			end
		end
	end
end

function InvPanel:UpdateItems()
	local Open = LocalPlayer().Inventory:IsVisible()
	RunConsoleCommand("UpdateItems")
	LocalPlayer().Inventory:Remove()
	LocalPlayer().Inventory = nil
	LocalPlayer().Inventory = vgui.Create("InvPanel")
	LocalPlayer().Inventory:SetPos(20, ScrH()/2-(133+32))
	LocalPlayer().Inventory:SetSize(88, (268+64))
	if Open then
		LocalPlayer().Inventory:Open()
	else
		LocalPlayer().Inventory:Close()
	end
end

function InvPanel:Open()
	RunConsoleCommand("UpdateItems")
	self:SetVisible(true)
	RestoreCursorPosition()
	gui.EnableScreenClicker(true)
end

function InvPanel:Close()
	self:SetVisible(false)
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
end

function InvPanel:Paint()
	draw.RoundedBox(4, -4, 0, self:GetWide() + 4, self:GetTall(), color_grey)
end
vgui.Register("InvPanel", InvPanel, "Panel")