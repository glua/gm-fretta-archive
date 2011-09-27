ThiefShop = {}
function ThiefShop:PerformLayout()
	
	if not ValidEntity(self.BG) then self.BG = vgui.Create("DFrame") end
	self.BG:SetTitle("Shop")
	self.BG:SetSize(800,600)
	self.BG:SetPos(ScrW()/2-400,ScrH()/2-300)
	if not self.BG.OldClose then
		self.BG.OldClose = self.BG.Close
		self.BG.Close = function(BG) BG:OldClose() gui.EnableScreenClicker(false) end
	end
	self.BG:MakePopup()
	
	if not ValidEntity(self.TopList) then self.TopList = vgui.Create("DPanelList",self.BG) end
	self.TopList:Clear()
	
	self.TopList:SetPos(4,26)
	self.TopList:SetSize(800-8,(600-31)/2-10)
	self.TopList:EnableHorizontal(true)
	
	for k,v in pairs(Thief.GetItems()) do
		--[[local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.DoClick = function(Icon)
			if LocalPlayer():GetNWInt("money") >= Icon.Item:GetPrice() then
				Derma_Query("Are you sure you want to buy this "..Icon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("BuyItem",Icon.Item:GetName()) end,"No",function() end)
			else
				LocalPlayer():PrintMessage(HUD_PRINTCHAT,"You don't have enough money for that "..Icon.Item:GetName())
			end
		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				CreateThiefItemInformationWindow(Icon.Item)
			elseif enum == 107 then
				Icon:DoClick()
			end
		end]]
		local Icon = CreateThiefItemInformationWindow(v,true)
		self.TopList:AddItem(Icon)
		Icon:SetSize(800-18,Icon:GetTall())
	end
	
	self.TopList:EnableVerticalScrollbar(true)
	self.TopList:EnableHorizontal(true)
	self.TopList:InvalidateLayout()
	
	--[[
	if not ValidEntity(self.BottomList) then self.BottomList = vgui.Create("DPanelList",self.BG) end
	self.BottomList:Clear()
	
	self.BottomList:SetPos(4,((600-31)/2)+20)
	self.BottomList:SetSize(800-8,(600-31)/2-10)
	self.BottomList:EnableHorizontal(true)

	for k,v in pairs(LocalPlayer().MyItems or {}) do
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.IIndex = k
		Icon.DoClick = function(Icon)
			Derma_Query("Are you sure you want to sell this "..Icon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("SellItem",Icon.IIndex) end,"No",function() end)
		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				CreateThiefItemInformationWindow(Icon.Item)
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		self.BottomList:AddItem(Icon)
	end
	
	
	self.BottomList:InvalidateLayout()]]
	
	for i=1,5 do
		local DFrame = vgui.Create("DPanel",self.BG)
		DFrame:SetPos(((800-8)/5*(i-1))+10,((600-31)/2)+35)
		DFrame:SetSize((DFrame:GetParent():GetWide()/5)-10,((600-31)/2)-40)
		if LocalPlayer().MyItems and LocalPlayer().MyItems[i] then --Display
			local k = i
			local v = LocalPlayer().MyItems[i]
			local Icon = vgui.Create("SpawnIcon",DFrame)
			Icon:SetModel(v:GetModel())
			Icon.Item = v
			Icon.IIndex = k
			Icon.DoClick = function(Icon)
				Derma_Query("Are you sure you want to sell this "..Icon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("SellItem",Icon.IIndex) end,"No",function() end)
			end
			Icon.OnMousePressed = function(Icon,enum)
				if enum == 108 then
					CreateThiefItemInformationWindow(Icon.Item)
				elseif enum == 107 then
					Icon:DoClick()
				end
			end
			Icon:SetPos((Icon:GetParent():GetWide()/2)-32,10)
			
			local Text = vgui.Create("DLabel",DFrame)
			Text:SetFont("HudHintTextLarge")
			if not Thief.GetItem(v:GetName()) then
				Text:SetText("Worth: $"..(v:GetPrice()*2).."\n"..v:GetInformation())
			else
				Text:SetText("Worth: $"..v:GetPrice().."\n"..string.wrapwords(v:GetInformation(),"HudHintTextLarge",Text:GetParent():GetWide()-14))
			end
			Text:SetSize(Text:GetParent():GetWide()-10,Text:GetParent():GetTall()-76)
			Text:SetPos(5,73)
		else --blank
		
		end
	end
	
	gui.EnableScreenClicker(true)
end

function table.GetKeysUpTo(tbl,key)
	local output = {}
	for k,v in ipairs(tbl) do
		table.insert(output,v)
		if k == key then
			break
		end
	end
	return output
end

function string.wrapwords(textz,font,x)
	surface.SetFont(font)
	local ret = ""
	local len,height = surface.GetTextSize(textz)
	if len > x then
		local tbl = string.Explode(" ",textz)
		for k,v in pairs(tbl) do
			local toolong,_ = surface.GetTextSize(v)
			local length,_ = surface.GetTextSize(table.concat(table.GetKeysUpTo(tbl,k)," "))
			if not(toolong> x-5)  then 
				if length > (x-5) then
					table.insert(tbl,tonumber(k-1),"\n")
				end
			else
				tbl[k] = " Word Too Long To Display\n"
			end
		end
		ret = table.concat(tbl," ")
	else
		ret = textz
	end
	return ret
end

function ThiefShop:Init()

	if self.BG then self.BG:OldClose() end
	gui.EnableScreenClicker(true)
end

function CreateThiefItemInformationWindow(item,buy)

	local BG = vgui.Create("DFrame")
	BG:SetPos((ScrW()/2)-200,(ScrH()/2)-50)
	BG:SetSize(400,100)
	BG:SetTitle(item:GetName())
	
	local SIcon = vgui.Create("SpawnIcon", BG)
	SIcon:SetModel(item:GetModel())
	SIcon:SetPos(6,29)
	SIcon.Item = item
	if buy then
		BG:ShowCloseButton(false)
		BG:SetDraggable(false)
		SIcon.DoClick = function(SIcon)
			if SIcon.Item and LocalPlayer():GetNWInt("money") >= SIcon.Item:GetPrice() then
				Derma_Query("Are you sure you want to buy this "..SIcon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("BuyItem",SIcon.Item:GetName()) end,"No",function() end)
			else
				LocalPlayer():PrintMessage(HUD_PRINTCHAT,"You don't have enough money for that "..SIcon.Item:GetName())
			end
		end
	end
	
	local Cost = vgui.Create("DLabel", BG)
	Cost:SetFont("HudHintTextLarge")
	Cost:SetPos(74,29)
	Cost:SetText("Worth: $"..item:GetPrice().."\n"..item:GetInformation())
	Cost:SizeToContents()
	
	return BG
	
end



function ThiefShop:Paint()

end
vgui.Register("ThiefShop", ThiefShop, "Panel")