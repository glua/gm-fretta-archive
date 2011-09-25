function HnsShopMenu()
	--if LocalPlayer():Team() != TEAM_SEEKERS then return end
	if hnshop != nil then
		hnshop:SetVisible(true) -- This can happen? 0_o
	else
		hnshop = vgui.Create("DPanel")
		hnshop:SetPos(ScrW() / 4, ScrH() / 4 )
		hnshop:SetSize(ScrW()/2, ScrH()/2 )
		hnshop:SetVisible( true )
		hnshop:MakePopup()
		local hnshop_items = vgui.Create("DPanelList", hnshop)
		hnshop_items:SetPos(0,0)
		hnshop_items:SetSize(ScrW()/2, ScrH()/2)
		hnshop_items:EnableVerticalScrollbar( true ) 
		hnshop_items:EnableHorizontal( true ) 
		hnshop_items:SetPadding( 4 ) 
		for k,v in SortedPairsByMemberValue(ShopTable, 5) do
			if v[6] or LocalPlayer():Team() == TEAM_SEEKERS then
			local icon = vgui.Create("SpawnIcon", hnshop_items)
			icon:SetModel(v[4])
			icon:SetTooltip(v[1].."\n"..v[2].."\nPrice: "..v[5].." frags")
			hnshop_items:AddItem(icon)
			icon.DoClick = function(icon) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("hns_buy", k) end
			end
		end
	end
end
concommand.Add("+menu_context", HnsShopMenu)

function HnsShopMenuClose()
	if hnshop==nil then return end
	hnshop:SetVisible(false)
	timer.Create("deleteshop", 0.1, 1, function()
	hnshop:Remove()
	hnshop=nil
	end)
end
concommand.Add("-menu_context", HnsShopMenuClose)